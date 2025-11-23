# 🎯 互动目标展示系统

一个简洁高效的实时数据收集和展示系统，专为会议、培训、活动等场景设计。支持用户扫码填写信息，实时大屏展示排行榜。

## ✨ 功能特性

### 🎮 核心功能
- **二维码收集**：自动生成二维码，用户扫码即可填写信息
- **实时展示**：数据实时同步，大屏秒级更新排行榜
- **智能排名**：按目标金额自动排序，前三名特殊标识
- **移动端优化**：响应式设计，完美适配手机操作

### 🛠️ 管理功能
- **数据管理**：清空数据、导出Excel、查看详情
- **系统监控**：实时统计、内存监控、连接状态
- **日志系统**：操作日志记录，问题追踪

### 🚀 技术特点
- **极简架构**：单体应用，无外部依赖
- **高性能**：纯内存存储，支持100+并发
- **易部署**：一键部署，Docker化支持
- **高可用**：优雅降级，自动重连

## 📋 系统要求

### 最低配置
- **操作系统**：Linux/macOS/Windows
- **Node.js**：14.0+
- **内存**：2GB RAM
- **磁盘**：1GB 可用空间
- **网络**：HTTP/HTTPS 访问

### 推荐配置
- **CPU**：2核心
- **内存**：4GB RAM
- **网络**：100Mbps 带宽

## 📁 项目文件结构

### 根目录文件
```
Meeting/
├── app.js                      # 主应用文件 - Node.js后端服务器
├── package.json                # 项目配置和依赖管理
├── package-lock.json           # 依赖版本锁定文件
├── Dockerfile                  # Docker镜像构建配置
├── docker-compose.yml          # Docker容器编排配置
├── .env.example                # 环境变量配置文件模板
├── .env                        # 环境变量配置文件（需创建）
├── .gitignore                  # Git忽略文件配置
├── test.js                     # 系统健康检查测试脚本
└── README.md                   # 项目说明文档
```

### 前端文件结构
```
public/                         # 静态资源目录
├── display.html               # 大屏展示页面 - 实时排行榜展示
├── submit.html                # 数据收集页面 - 用户信息填写
├── admin.html                 # 管理后台页面 - 系统管理界面
│
├── styles/                    # CSS样式文件
│   ├── display.css           # 大屏展示样式 - 排行榜视觉效果
│   ├── submit.css            # 数据收集样式 - 表单界面样式
│   └── admin.css             # 管理后台样式 - 管理界面样式
│
└── scripts/                   # JavaScript脚本文件
    ├── display.js            # 大屏交互逻辑 - WebSocket实时更新
    ├── submit.js             # 表单交互逻辑 - 用户输入验证和提交
    └── admin.js              # 管理后台逻辑 - 数据统计和管理
```

### 后端文件结构
```
app.js                          # Express服务器主文件
├── 中间件配置
│   ├── helmet.js             # 安全中间件 - CSP等安全配置
│   ├── cors.js               # 跨域中间件
│   └── static.js             # 静态文件服务
│
├── API路由
│   ├── /api/participant      # 参与者数据提交接口
│   ├── /api/participants     # 参与者列表获取接口
│   ├── /api/stats            # 系统统计信息接口
│   ├── /api/qrcode           # 二维码生成接口
│   └── /ws                   # WebSocket实时通信
│
└── 核心功能
    ├── 数据存储              # 内存数据管理（Map/Array）
    ├── 排序算法              # 按金额实时排序
    ├── 并发控制              # 限流和防重提交
    └── WebSocket广播         # 实时数据推送
```

### 部署和运维文件
```
scripts/
└── deploy.sh                  # 一键部署脚本 - 自动化部署

docs/                          # 项目文档目录
├── 产品PRD需求文档.md        # 产品需求文档
├── 系统架构设计文档.md       # 系统架构设计文档
└── 用户需求.txt              # 原始用户需求文档

.history/                      # 文件修改历史记录
└── public/                    # 前端文件修改历史
    ├── scripts/
    │   ├── display_*.js      # 大屏脚本历史版本
    │   └── submit_*.js       # 提交脚本历史版本
    └── ...
```

### 配置文件说明
```
# 环境配置 (.env)
PORT=3000                    # 服务端口
NODE_ENV=development         # 运行环境
DOMAIN=localhost             # 服务域名
MAX_PARTICIPANTS=500         # 最大参与人数
MAX_WS_CONNECTIONS=50        # 最大WebSocket连接数

# 依赖配置 (package.json)
├── express                  # Web框架
├── ws                       # WebSocket库
├── qrcode                   # 二维码生成
├── cors                     # 跨域处理
├── helmet                   # 安全中间件
└── nodemon                  # 开发热重载
```

### 技术栈文件
```
# 前端技术
├── HTML5 + CSS3 + JavaScript  # 原生Web技术
├── 响应式设计               # 移动端适配
├── 事件委托模式             # 避免内联事件处理器
└── WebSocket客户端          # 实时通信

# 后端技术
├── Node.js + Express        # JavaScript运行时和Web框架
├── 内存存储                 # 纯内存数据管理
├── WebSocket服务器          # 实时双向通信
├── 安全中间件               # CSP、XSS防护
└── Docker容器化            # 容器化部署
```

## 🚀 快速开始

### 方式一：直接部署（推荐开发环境）

#### 1. 下载项目
```bash
git clone <repository-url>
cd Meeting
```

#### 2. 安装依赖
```bash
npm install
```

#### 3. 配置环境
```bash
# 复制环境配置文件
cp .env.example .env

# 编辑配置文件（开发环境可保持默认）
nano .env
```

#### 4. 启动服务
```bash
# 开发环境
npm start

# 或使用开发模式（自动重启）
npm run dev
```

#### 5. 访问系统
- 大屏展示：http://localhost:3000/
- 数据收集：http://localhost:3000/submit
- 管理后台：http://localhost:3000/admin
- 二维码：http://localhost:3000/api/qrcode

### 方式二：自动化部署脚本

#### 开发环境部署
```bash
# 给脚本执行权限
chmod +x scripts/deploy.sh

# 一键部署开发环境
./scripts/deploy.sh development
```

#### 生产环境部署
```bash
# 生产环境部署
./scripts/deploy.sh production
```

### 方式三：Docker部署

#### 1. 构建镜像
```bash
docker build -t meeting-system .
```

#### 2. 运行容器
```bash
docker run -d \
  --name meeting-system \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -e DOMAIN=meet.seasoul.top \
  meeting-system
```

#### 3. 使用Docker Compose（推荐）
```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

## ⚙️ 详细配置

### 环境变量说明

| 变量名 | 说明 | 默认值 | 必填 |
|--------|------|--------|------|
| `PORT` | 服务端口 | 3000 | 否 |
| `NODE_ENV` | 运行环境 | development | 否 |
| `DOMAIN` | 服务域名 | localhost | 否 |
| `MAX_PARTICIPANTS` | 最大参与人数 | 500 | 否 |
| `MAX_WS_CONNECTIONS` | 最大WebSocket连接 | 50 | 否 |

### 生产环境配置示例

```bash
# .env 文件内容
PORT=3000
NODE_ENV=production
DOMAIN=meet.seasoul.top
MAX_PARTICIPANTS=500
MAX_WS_CONNECTIONS=50
```

### 反向代理配置（Nginx）

```nginx
server {
    listen 80;
    server_name meet.seasoul.top;

    # 重定向到HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name meet.seasoul.top;

    # SSL证书配置
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    # 代理到Node.js应用
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;

        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

### PM2进程管理（生产环境推荐）

#### 1. 安装PM2
```bash
npm install -g pm2
```

#### 2. 启动应用
```bash
pm2 start app.js --name "meeting-system"
pm2 save
pm2 startup
```

#### 3. PM2常用命令
```bash
# 查看状态
pm2 status

# 查看日志
pm2 logs meeting-system

# 重启应用
pm2 restart meeting-system

# 停止应用
pm2 stop meeting-system

# 删除应用
pm2 delete meeting-system
```

## 🔧 运维指南

### 日志管理

#### 日志文件位置
- 应用日志：`logs/app.log`
- 错误日志：`logs/error.log`
- 访问日志：控制台输出

#### 日志轮转配置（logrotate）
```bash
# /etc/logrotate.d/meeting-system
/path/to/meeting-system/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    postrotate
        pm2 reloadLogs
    endscript
}
```

### 监控配置

#### 1. 健康检查
```bash
# 检查服务状态
curl -f http://localhost:3000/api/stats

# 检查WebSocket连接
curl -i -N -H "Connection: Upgrade" \
     -H "Upgrade: websocket" \
     -H "Sec-WebSocket-Key: test" \
     -H "Sec-WebSocket-Version: 13" \
     http://localhost:3000/ws
```

#### 2. 系统监控脚本
```bash
#!/bin/bash
# monitor.sh

API_URL="http://localhost:3000/api/stats"
LOG_FILE="/var/log/meeting-system-monitor.log"

while true; do
    if curl -f $API_URL > /dev/null 2>&1; then
        echo "$(date): 服务正常" >> $LOG_FILE
    else
        echo "$(date): 服务异常，尝试重启" >> $LOG_FILE
        pm2 restart meeting-system
    fi
    sleep 60
done
```

### 备份策略

#### 数据备份（虽然数据是临时的）
```bash
#!/bin/bash
# backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/meeting-system"
API_URL="http://localhost:3000/api/participants"

mkdir -p $BACKUP_DIR

# 导出参与者数据
curl -s $API_URL | jq '.data.participants' > $BACKUP_DIR/participants_$DATE.json

# 备份配置文件
cp .env $BACKUP_DIR/config_$DATE

# 清理7天前的备份
find $BACKUP_DIR -name "*.json" -mtime +7 -delete
find $BACKUP_DIR -name "config_*" -mtime +7 -delete

echo "备份完成: $BACKUP_DIR/participants_$DATE.json"
```

### 安全配置

#### 1. 防火墙配置
```bash
# Ubuntu/Debian
ufw allow 3000/tcp
ufw enable

# CentOS/RHEL
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --reload
```

#### 2. 安全头配置
应用已内置helmet.js安全中间件，包括：
- XSS防护
- 内容类型检测
- 跨域保护
- 点击劫持防护

#### 3. 限流配置
```bash
# 使用nginx限流
http {
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

    server {
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://localhost:3000;
        }
    }
}
```

## 📊 性能调优

### 1. 内存优化
- 默认最大500条记录，约占用1MB内存
- 系统预留500MB内存空间
- 超过1GB使用量时自动清理

### 2. 并发处理
- 支持100个并发用户提交
- 支持50个WebSocket连接
- 5秒防重提交机制

### 3. 网络优化
- 静态文件缓存：24小时
- Gzip压缩（生产环境）
- Keep-Alive连接复用

## 🐛 故障排查

### 常见问题

#### 1. 端口被占用
```bash
# 查看占用进程
lsof -i :3000

# 终止进程
kill -9 <PID>

# 或更改端口
export PORT=8080
npm start
```

#### 2. 内存不足
```bash
# 查看内存使用
free -h

# 查看Node.js进程内存
ps aux | grep node

# 重启应用释放内存
pm2 restart meeting-system
```

#### 3. WebSocket连接失败
- 检查防火墙配置
- 验证反向代理WebSocket支持
- 确认域名解析正确

#### 4. 数据提交失败
- 检查网络连接
- 验证表单数据格式
- 查看服务器日志

### 调试模式

#### 1. 启用调试日志
```bash
export DEBUG=*
npm start
```

#### 2. 启用Node.js调试
```bash
node --inspect app.js
# 然后在Chrome DevTools中调试
```

## 📱 使用指南

### 用户操作流程

#### 1. 参与者操作
1. 扫描二维码或访问提交页面
2. 填写机构名称（必填）
3. 填写个人姓名（必填）
4. 填写目标金额（必填）
5. 确认信息并提交
6. 在大屏查看实时排名

#### 2. 管理员操作
1. 访问管理后台
2. 查看系统统计信息
3. 管理参与者数据
4. 导出数据报表
5. 监控系统状态

### 快捷键说明

#### 大屏页面
- `F5` / `Ctrl+R`：手动刷新数据
- `ESC`：退出全屏

#### 管理后台
- `Ctrl+R`：刷新统计数据
- `Ctrl+E`：导出数据
- `ESC`：关闭弹窗

## 🔄 更新升级

### 版本更新流程

#### 1. 备份数据
```bash
# 导出当前数据
curl http://localhost:3000/api/participants > backup.json

# 备份配置
cp .env .env.backup
```

#### 2. 更新代码
```bash
git pull origin main
npm install
```

#### 3. 重启服务
```bash
pm2 restart meeting-system
# 或
docker-compose restart
```

#### 4. 验证更新
```bash
curl http://localhost:3000/api/stats
```

### 回滚操作
```bash
git checkout <previous-tag>
npm install
pm2 restart meeting-system
```

## 🤝 技术支持

### 开发团队
- 前端开发：响应式Web界面
- 后端开发：Node.js/Express服务
- 系统架构：微服务设计
- 运维支持：Docker/DevOps

### 联系方式
- 技术问题：查看系统日志
- 功能建议：提交GitHub Issue
- 紧急故障：联系运维团队

### 贡献指南
1. Fork项目仓库
2. 创建功能分支
3. 提交代码变更
4. 创建Pull Request

## 📄 许可证

MIT License - 详见[LICENSE](LICENSE)文件

## 🎯 版本历史

### v1.0.0 (2024-11-22)
- ✨ 初始版本发布
- 🎮 核心功能实现
- 🛠️ 管理后台完成
- 📱 移动端优化
- 🚀 Docker化部署
- 📊 实时数据展示

---

**💡 温馨提示**：
- 首次部署建议在测试环境验证
- 生产环境请配置HTTPS和防火墙
- 定期备份重要配置文件
- 监控系统性能和日志

**🎉 祝您使用愉快！**

---

## 📊 项目统计

- **总文件数**：20+ 个核心文件
- **代码行数**：约 2000+ 行
- **依赖数**：7 个主要依赖包
- **部署时间**：< 5 分钟
- **内存占用**：< 200MB
- **支持并发**：100+ 用户同时在线

**💡 项目特点**：
- 💯 零外部依赖 - 纯内存存储
- 🚀 秒级部署 - Docker一键启动
- 🔒 安全可靠 - CSP防护 + 输入验证
- 📱 移动优先 - 响应式设计
- 🎯 专注核心 - 功能精简实用