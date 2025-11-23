const express = require('express');
const WebSocket = require('ws');
const path = require('path');
const QRCode = require('qrcode');
const cors = require('cors');
const helmet = require('helmet');
const http = require('http');

// 应用配置
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';
const DOMAIN = NODE_ENV === 'production' ? 'meet.seasoul.top' : 'localhost';

// 创建Express应用
const app = express();
const server = http.createServer(app);

// 中间件配置
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-hashes'", "ws:", "wss:"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "blob:"],
      connectSrc: ["'self'", "ws:", "wss:"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
    },
  },
}));

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(express.static(path.join(__dirname, 'public')));

// 静态文件缓存
app.use((req, res, next) => {
  if (req.url.endsWith('.js') || req.url.endsWith('.css')) {
    res.setHeader('Cache-Control', 'public, max-age=86400');
  }
  next();
});

// 内存数据存储
const participants = new Map(); // participantId -> participant data
let nextId = 1;
let sortedParticipants = [];
let lastUpdateTime = 0;

// 防重提交缓存
const submitCache = new Map(); // ip -> last submit time

// WebSocket连接管理
const clients = new Set();

// 错误消息映射
const errorMessages = {
  'MISSING_REQUIRED': '请填写所有必填字段',
  'INVALID_FORMAT': '请检查输入格式是否正确',
  'DUPLICATE_ENTRY': '您已经提交过了，相同设备可修改数据',
  'SERVER_BUSY': '系统繁忙，请稍后重试',
  'RATE_LIMIT': '提交太频繁，请等待几秒后再试',
  'MAX_PARTICIPANTS': '参与人数已达上限（500人）',
  'INVALID_TARGET': '目标金额必须是大于0的数字，最大999,999.99',
  'DUPLICATE_PERSON': '该人员已存在，将覆盖原有金额',
  'PERSON_EXISTS': '检测到重复人员：{name}（{organization}），当前金额：{currentTarget}万元，是否覆盖为新的金额：{newTarget}万元？'
};

// 常量定义
const MAX_PARTICIPANTS = 500;
const MAX_WS_CONNECTIONS = 50;
const RATE_LIMIT_MS = 5000; // 5秒防重提交

// 工具函数
function log(message, level = 'info') {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] [${level.toUpperCase()}] ${message}`);
}

function getClientIP(req) {
  return req.headers['x-forwarded-for']?.split(',')[0] ||
         req.connection.remoteAddress ||
         req.socket.remoteAddress ||
         (req.connection.socket ? req.connection.socket.remoteAddress : null);
}

function createErrorResponse(res, errorType, details = null) {
  return res.status(400).json({
    success: false,
    message: errorMessages[errorType] || '操作失败，请重试',
    errorType: errorType,
    details: details,
    timestamp: Date.now()
  });
}

function createSuccessResponse(res, data, message = '操作成功') {
  return res.json({
    success: true,
    message: message,
    data: data,
    timestamp: Date.now()
  });
}

function validateParticipantData(data) {
  const errors = [];

  if (!data.organization || typeof data.organization !== 'string' || data.organization.trim().length === 0) {
    errors.push('机构名称不能为空');
  } else if (data.organization.trim().length > 50) {
    errors.push('机构名称不能超过50个字符');
  }

  if (!data.name || typeof data.name !== 'string' || data.name.trim().length === 0) {
    errors.push('姓名不能为空');
  } else if (data.name.trim().length > 20) {
    errors.push('姓名不能超过20个字符');
  }

  if (!data.target || isNaN(data.target)) {
    errors.push('目标金额必须是数字');
  } else {
    const target = parseFloat(data.target);
    if (target <= 0) {
      errors.push('目标金额必须大于0');
    } else if (target > 999999.99) {
      errors.push('目标金额不能超过999,999.99');
    }
  }

  return errors;
}

function checkRateLimit(ip) {
  const lastSubmit = submitCache.get(ip) || 0;
  const now = Date.now();

  if (now - lastSubmit < RATE_LIMIT_MS) {
    return false;
  }

  submitCache.set(ip, now);
  return true;
}

function findDuplicatePerson(organization, name) {
  // 遍历所有参与者，查找相同机构和姓名的人员
  for (const participant of participants.values()) {
    if (participant.organization === organization && participant.name === name) {
      return participant;
    }
  }
  return null;
}

function sortParticipants() {
  const now = Date.now();
  if (now - lastUpdateTime < 1000 && sortedParticipants.length > 0) {
    return sortedParticipants;
  }

  sortedParticipants = Array.from(participants.values())
    .sort((a, b) => {
      if (b.target !== a.target) {
        return b.target - a.target; // 金额降序
      }
      return a.timestamp - b.timestamp; // 时间升序
    });

  lastUpdateTime = now;
  return sortedParticipants;
}

function addParticipant(participant) {
  participants.set(participant.id, participant);
  sortParticipants();
  broadcastUpdate();
}

function updateParticipant(id, updatedData) {
  const existing = participants.get(id);
  if (existing) {
    participants.set(id, { ...existing, ...updatedData, timestamp: Date.now() });
    sortParticipants();
    broadcastUpdate();
    return true;
  }
  return false;
}

function broadcastUpdate() {
  if (clients.size === 0) return;

  const message = JSON.stringify({
    type: 'update',
    data: sortParticipants(),
    total: participants.size,
    timestamp: Date.now()
  });

  clients.forEach(ws => {
    if (ws.readyState === WebSocket.OPEN) {
      try {
        ws.send(message);
      } catch (error) {
        log(`发送WebSocket消息失败: ${error.message}`, 'warn');
      }
    }
  });
}

// WebSocket服务器配置
const wss = new WebSocket.Server({
  path: '/ws',
  server: server,
  maxPayload: 1024 * 1024 // 1MB
});

wss.on('connection', (ws, req) => {
  // 连接数限制
  if (clients.size >= MAX_WS_CONNECTIONS) {
    ws.close(1008, '连接数已达上限');
    log(`WebSocket连接被拒绝，已达最大连接数: ${MAX_WS_CONNECTIONS}`, 'warn');
    return;
  }

  clients.add(ws);
  const clientIP = getClientIP(req);
  log(`WebSocket客户端连接，IP: ${clientIP}，当前连接数: ${clients.size}`);

  // 发送初始数据
  try {
    ws.send(JSON.stringify({
      type: 'initial',
      data: sortParticipants(),
      total: participants.size,
      timestamp: Date.now()
    }));
  } catch (error) {
    log(`发送WebSocket初始数据失败: ${error.message}`, 'warn');
  }

  ws.on('close', (code, reason) => {
    clients.delete(ws);
    log(`WebSocket客户端断开，剩余连接数: ${clients.size}，代码: ${code}，原因: ${reason || '未知'}`);
  });

  ws.on('error', (error) => {
    clients.delete(ws);
    log(`WebSocket错误: ${error.message}`, 'error');
  });

  ws.on('pong', () => {
    ws.isAlive = true;
  });
});

// WebSocket心跳检测
setInterval(() => {
  clients.forEach(ws => {
    if (!ws.isAlive) {
      ws.terminate();
      clients.delete(ws);
      return;
    }
    ws.isAlive = false;
    ws.ping();
  });
}, 30000);

// 路由配置

// 主页 - 大屏展示页面
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'display.html'));
});

// 数据收集页面
app.get('/submit', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'submit.html'));
});

// 管理页面
app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});

// API路由

// 生成二维码
app.get('/api/qrcode', async (req, res) => {
  try {
    const submitURL = `http://${DOMAIN}:${PORT}/submit`;
    const qrDataUrl = await QRCode.toDataURL(submitURL, {
      width: 256,
      margin: 2,
      color: {
        dark: '#000000',
        light: '#FFFFFF'
      }
    });

    res.setHeader('Content-Type', 'image/svg+xml');
    res.end(`<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="300" height="320" viewBox="0 0 300 320">
  <rect width="300" height="320" fill="white" stroke="black" stroke-width="2"/>
  <image x="22" y="22" width="256" height="256" xlink:href="${qrDataUrl.replace('data:image/png;base64,', 'data:image/png;base64,')}" transform="scale(1.0)"/>
  <text x="150" y="295" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" fill="black">扫描填写信息</text>
</svg>`);
  } catch (error) {
    log(`生成二维码失败: ${error.message}`, 'error');
    res.status(500).json({ error: '二维码生成失败' });
  }
});

// 提交参与者信息
app.post('/api/participant', (req, res) => {
  try {
    const clientIP = getClientIP(req);

    // 防重提交检查
    if (!checkRateLimit(clientIP)) {
      return createErrorResponse(res, 'RATE_LIMIT');
    }

    // 数据验证
    const validationErrors = validateParticipantData(req.body);
    if (validationErrors.length > 0) {
      return createErrorResponse(res, 'INVALID_FORMAT', validationErrors);
    }

    const organization = req.body.organization.trim();
    const name = req.body.name.trim();
    const target = parseFloat(req.body.target);

    // 检查是否存在重复人员（同一机构+同一姓名）
    const existingPerson = findDuplicatePerson(organization, name);

    if (existingPerson) {
      // 检测到重复人员，返回提醒信息
      return createSuccessResponse(res, {
        isDuplicate: true,
        existingPerson: {
          id: existingPerson.id,
          name: existingPerson.name,
          organization: existingPerson.organization,
          currentTarget: existingPerson.target,
          newTarget: target
        },
        message: errorMessages['PERSON_EXISTS']
          .replace('{name}', existingPerson.name)
          .replace('{organization}', existingPerson.organization)
          .replace('{currentTarget}', existingPerson.target)
          .replace('{newTarget}', target)
      }, '检测到重复人员');
    }

    // 参与人数检查（只有新增时才检查）
    if (participants.size >= MAX_PARTICIPANTS) {
      return createErrorResponse(res, 'MAX_PARTICIPANTS');
    }

    const participant = {
      id: nextId++,
      organization: organization,
      name: name,
      target: target,
      timestamp: Date.now()
    };

    addParticipant(participant);

    log(`新增参与者: ${participant.name} (${participant.organization}) - 目标: ${participant.target}万元`);

    createSuccessResponse(res, {
      participant: participant,
      isDuplicate: false
    }, '提交成功！');
  } catch (error) {
    log(`提交参与者失败: ${error.message}`, 'error');
    createErrorResponse(res, 'SERVER_BUSY');
  }
});

// 确认覆盖已存在的人员信息
app.post('/api/participant/confirm', (req, res) => {
  try {
    const { personId, newTarget } = req.body;

    if (!personId || !newTarget) {
      return createErrorResponse(res, 'MISSING_REQUIRED', ['缺少必要参数']);
    }

    const existingPerson = participants.get(personId);
    if (!existingPerson) {
      return createErrorResponse(res, 'INVALID_FORMAT', ['人员不存在']);
    }

    // 更新金额
    const oldTarget = existingPerson.target;
    existingPerson.target = parseFloat(newTarget);
    existingPerson.timestamp = Date.now();

    // 重新排序并广播更新
    sortParticipants();
    broadcastUpdate();

    log(`覆盖更新人员: ${existingPerson.name} (${existingPerson.organization}) - 原金额: ${oldTarget}万元 → 新金额: ${existingPerson.target}万元`);

    createSuccessResponse(res, {
      participant: existingPerson,
      oldTarget: oldTarget,
      newTarget: existingPerson.target,
      isUpdated: true
    }, '金额更新成功！');
  } catch (error) {
    log(`确认覆盖失败: ${error.message}`, 'error');
    createErrorResponse(res, 'SERVER_BUSY');
  }
});

// 获取参与者列表
app.get('/api/participants', (req, res) => {
  try {
    const participants = sortParticipants();
    createSuccessResponse(res, {
      participants: participants,
      total: participants.length,
      timestamp: Date.now()
    });
  } catch (error) {
    log(`获取参与者列表失败: ${error.message}`, 'error');
    createErrorResponse(res, 'SERVER_BUSY');
  }
});

// 获取统计信息
app.get('/api/stats', (req, res) => {
  try {
    const stats = {
      total: participants.size,
      maxParticipants: MAX_PARTICIPANTS,
      wsConnections: clients.size,
      memoryUsage: process.memoryUsage(),
      uptime: process.uptime(),
      lastUpdate: lastUpdateTime
    };
    createSuccessResponse(res, stats);
  } catch (error) {
    log(`获取统计信息失败: ${error.message}`, 'error');
    createErrorResponse(res, 'SERVER_BUSY');
  }
});

// 清空所有数据
app.delete('/api/participants', (req, res) => {
  try {
    const count = participants.size;
    participants.clear();
    sortedParticipants = [];
    nextId = 1;
    lastUpdateTime = 0;
    broadcastUpdate();

    log(`清空了${count}条参与者数据`);
    createSuccessResponse(res, { clearedCount: count }, '数据已清空');
  } catch (error) {
    log(`清空数据失败: ${error.message}`, 'error');
    createErrorResponse(res, 'SERVER_BUSY');
  }
});

// 错误处理中间件
app.use((err, req, res, next) => {
  log(`服务器错误: ${err.message}`, 'error');
  res.status(500).json({
    success: false,
    message: '服务器内部错误',
    timestamp: Date.now()
  });
});

// 404处理
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: '页面未找到',
    timestamp: Date.now()
  });
});

// 系统监控和清理
setInterval(() => {
  // 清理过期的防重提交缓存
  const now = Date.now();
  for (const [ip, timestamp] of submitCache.entries()) {
    if (now - timestamp > 60000) { // 1分钟后清理
      submitCache.delete(ip);
    }
  }
}, 300000); // 每5分钟清理一次

// 内存监控
setInterval(() => {
  const memUsage = process.memoryUsage();
  const memUsedMB = Math.round(memUsage.heapUsed / 1024 / 1024);
  const memTotalMB = Math.round(memUsage.heapTotal / 1024 / 1024);

  if (memUsedMB > 500) { // 内存使用超过500MB时警告
    log(`内存使用过高: ${memUsedMB}MB/${memTotalMB}MB，参与者数: ${participants.size}，WebSocket连接数: ${clients.size}`, 'warn');

    // 如果内存使用接近1GB，触发紧急清理
    if (memUsedMB > 1024) {
      log('内存使用过高，触发紧急数据清理', 'error');
      participants.clear();
      sortedParticipants = [];
      broadcastUpdate();
    }
  }
}, 60000); // 每分钟检查一次

// 服务器启动
server.listen(PORT, '0.0.0.0', () => {
  log(`互动目标展示系统启动成功`);
  log(`服务器地址: http://${DOMAIN}:${PORT}`);
  log(`环境: ${NODE_ENV}`);
  log(`大屏展示: http://${DOMAIN}:${PORT}/`);
  log(`数据收集: http://${DOMAIN}:${PORT}/submit`);
  log(`管理页面: http://${DOMAIN}:${PORT}/admin`);
  log(`WebSocket: ws://${DOMAIN}:${PORT}/ws`);
});

// 优雅关闭
process.on('SIGTERM', () => {
  log('收到SIGTERM信号，开始优雅关闭...');
  server.close(() => {
    wss.close(() => {
      log('服务器已关闭');
      process.exit(0);
    });
  });
});

process.on('SIGINT', () => {
  log('收到SIGINT信号，开始优雅关闭...');
  server.close(() => {
    wss.close(() => {
      log('服务器已关闭');
      process.exit(0);
    });
  });
});

// 未捕获异常处理
process.on('uncaughtException', (error) => {
  log(`未捕获异常: ${error.message}`, 'error');
  console.error(error.stack);
});

process.on('unhandledRejection', (reason, promise) => {
  log(`未处理的Promise拒绝: ${reason}`, 'error');
});

module.exports = app;