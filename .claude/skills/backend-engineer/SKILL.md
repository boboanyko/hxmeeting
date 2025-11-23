---
name: backend-engineer
description: 专业的后端软件工程师技能，专注于现代后端开发，包括Node.js/Java开发、API设计、数据库设计、微服务架构、性能优化和DevOps实践。此技能应在用户需要进行后端API开发、数据库设计、服务架构实现、后端性能优化时使用。
---

# 后端软件工程师技能

## 技能概述

本技能将Claude转换为专业的后端软件工程师，具备全面的现代后端开发能力，包括API设计、数据库架构、微服务开发、性能优化、安全设计和DevOps实践。

## 技能应用场景

在以下情况下使用此技能：

- 需要设计和实现RESTful API
- 需要进行数据库设计和优化
- 需要开发微服务架构
- 需要实现认证授权系统
- 需要进行性能优化和缓存设计
- 需要集成第三方服务和API
- 需要实现消息队列和异步处理
- 需要进行监控和日志管理

## 核心技术栈

### 后端框架
- **Node.js + Express**: 轻量级Web框架
- **NestJS**: 企业级Node.js框架
- **Spring Boot**: Java企业级框架
- **FastAPI**: Python现代Web框架

### 数据库技术
- **关系数据库**: PostgreSQL, MySQL, Oracle
- **NoSQL数据库**: MongoDB, Redis, Elasticsearch
- **ORM工具**: Prisma, TypeORM, Hibernate, MyBatis
- **数据库连接池**: PgPool, HikariCP

### 微服务技术
- **服务发现**: Consul, Eureka, Nacos
- **API网关**: Kong, Spring Cloud Gateway, Apigee
- **负载均衡**: Nginx, HAProxy
- **容器化**: Docker, Kubernetes

### 中间件技术
- **消息队列**: RabbitMQ, Apache Kafka, Redis Pub/Sub
- **缓存**: Redis, Memcached, Ehcache
- **搜索引擎**: Elasticsearch, Solr
- **文件存储**: MinIO, AWS S3, 阿里云OSS

### 开发和运维工具
- **API文档**: Swagger/OpenAPI, Postman
- **测试框架**: Jest, Mocha, JUnit, TestNG
- **监控工具**: Prometheus, Grafana, ELK Stack
- **CI/CD**: Jenkins, GitLab CI, GitHub Actions

## 后端开发最佳实践

### 1. 项目结构设计

#### Node.js项目结构
```
src/
├── controllers/         # 控制器层
├── services/           # 业务逻辑层
├── repositories/       # 数据访问层
├── models/             # 数据模型
├── middleware/         # 中间件
├── routes/             # 路由定义
├── utils/              # 工具函数
├── config/             # 配置文件
├── types/              # TypeScript类型定义
├── tests/              # 测试文件
└── app.ts              # 应用入口
```

#### Spring Boot项目结构
```
src/main/java/com/example/
├── controller/         # 控制器
├── service/            # 服务层
├── repository/         # 数据访问层
├── entity/             # 实体类
├── dto/                # 数据传输对象
├── config/             # 配置类
├── exception/          # 异常处理
├── util/               # 工具类
└── Application.java    # 应用入口
```

### 2. RESTful API设计

#### API设计原则
- **RESTful风格**: 使用标准HTTP方法
- **资源导向**: URL表示资源
- **状态码**: 正确使用HTTP状态码
- **版本控制**: API版本管理
- **统一响应**: 标准化响应格式

#### API响应格式标准
```typescript
// 标准API响应格式
interface ApiResponse<T> {
  success: boolean;
  code: number;
  message: string;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    timestamp: string;
    requestId: string;
    pagination?: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  };
}
```

#### Express.js API实现示例
```typescript
// controllers/UserController.ts
import { Request, Response, NextFunction } from 'express';
import { UserService } from '../services/UserService';
import { CreateUserRequest, UpdateUserRequest } from '../types/user';
import { ApiResponse } from '../types/common';

export class UserController {
  constructor(private userService: UserService) {}

  async getUsers(req: Request, res: Response, next: NextFunction) {
    try {
      const { page = 1, limit = 10, search } = req.query;

      const result = await this.userService.getUsers({
        page: Number(page),
        limit: Number(limit),
        search: search as string,
      });

      const response: ApiResponse = {
        success: true,
        code: 200,
        message: '获取用户列表成功',
        data: result.users,
        meta: {
          timestamp: new Date().toISOString(),
          requestId: req.id,
          pagination: {
            page: result.page,
            limit: result.limit,
            total: result.total,
            totalPages: Math.ceil(result.total / result.limit),
          },
        },
      };

      res.status(200).json(response);
    } catch (error) {
      next(error);
    }
  }

  async createUser(req: Request, res: Response, next: NextFunction) {
    try {
      const userData: CreateUserRequest = req.body;

      const user = await this.userService.createUser(userData);

      const response: ApiResponse = {
        success: true,
        code: 201,
        message: '用户创建成功',
        data: user,
        meta: {
          timestamp: new Date().toISOString(),
          requestId: req.id,
        },
      };

      res.status(201).json(response);
    } catch (error) {
      next(error);
    }
  }

  async updateUser(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const updateData: UpdateUserRequest = req.body;

      const user = await this.userService.updateUser(Number(id), updateData);

      const response: ApiResponse = {
        success: true,
        code: 200,
        message: '用户更新成功',
        data: user,
        meta: {
          timestamp: new Date().toISOString(),
          requestId: req.id,
        },
      };

      res.status(200).json(response);
    } catch (error) {
      next(error);
    }
  }

  async deleteUser(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;

      await this.userService.deleteUser(Number(id));

      const response: ApiResponse = {
        success: true,
        code: 200,
        message: '用户删除成功',
        meta: {
          timestamp: new Date().toISOString(),
          requestId: req.id,
        },
      };

      res.status(200).json(response);
    } catch (error) {
      next(error);
    }
  }
}
```

### 3. 数据库设计和ORM

#### 数据库设计原则
- **规范化**: 避免数据冗余
- **索引优化**: 提高查询性能
- **外键约束**: 保证数据完整性
- **数据类型**: 选择合适的数据类型
- **命名规范**: 统一的命名约定

#### Prisma ORM示例
```typescript
// schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  username  String   @unique
  password  String
  name      String
  role      Role     @default(USER)
  status    Status   @default(ACTIVE)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // 关联关系
  reports   WeeklyReport[]
  analyses  AIAnalysis[]

  @@map("users")
}

model Project {
  id          Int      @id @default(autoincrement())
  name        String
  description String?
  status      Status   @default(ACTIVE)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  // 关联关系
  reportProjects ReportProject[]

  @@map("projects")
}

model WeeklyReport {
  id          Int      @id @default(autoincrement())
  title       String?
  employeeId  Int
  startDate   DateTime
  endDate     DateTime
  weekNumber  Int
  status      ReportStatus @default(DRAFT)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  // 关联关系
  employee      User           @relation(fields: [employeeId], references: [id])
  reportProjects ReportProject[]

  @@unique([employeeId, startDate, endDate])
  @@map("weekly_reports")
}

model ReportProject {
  id             Int      @id @default(autoincrement())
  reportId       Int
  projectId      Int
  status         String
  priority       String
  progressContent String?
  progressHtml   String?
  createdAt      DateTime @default(now())

  // 关联关系
  report  WeeklyReport @relation(fields: [reportId], references: [id])
  project Project       @relation(fields: [projectId], references: [id])

  @@map("report_projects")
}

model AIAnalysis {
  id           Int      @id @default(autoincrement())
  userId       Int
  question     String
  answer       String?
  reportIds    Int[]
  aiModel      String?
  analysisType String?
  createdAt    DateTime @default(now())

  // 关联关系
  user User @relation(fields: [userId], references: [id])

  @@map("ai_analyses")
}

enum Role {
  USER
  ADMIN
}

enum Status {
  ACTIVE
  INACTIVE
  DELETED
}

enum ReportStatus {
  DRAFT
  SUBMITTED
  APPROVED
  REJECTED
}
```

#### Repository模式实现
```typescript
// repositories/BaseRepository.ts
import { PrismaClient } from '@prisma/client';

export abstract class BaseRepository<T, CreateData, UpdateData> {
  constructor(protected prisma: PrismaClient) {}

  abstract create(data: CreateData): Promise<T>;
  abstract findById(id: number): Promise<T | null>;
  abstract findMany(options?: any): Promise<T[]>;
  abstract update(id: number, data: UpdateData): Promise<T>;
  abstract delete(id: number): Promise<void>;
  abstract count(options?: any): Promise<number>;
}

// repositories/UserRepository.ts
import { PrismaClient, User, Prisma } from '@prisma/client';
import { BaseRepository } from './BaseRepository';

export class UserRepository extends BaseRepository<
  User,
  Prisma.UserCreateInput,
  Prisma.UserUpdateInput
> {
  constructor(prisma: PrismaClient) {
    super(prisma);
  }

  async create(data: Prisma.UserCreateInput): Promise<User> {
    return this.prisma.user.create({ data });
  }

  async findById(id: number): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
      include: {
        reports: {
          select: {
            id: true,
            title: true,
            startDate: true,
            endDate: true,
            status: true,
          },
        },
      },
    });
  }

  async findMany(options: {
    page?: number;
    limit?: number;
    search?: string;
    role?: string;
    status?: string;
  }): Promise<User[]> {
    const { page = 1, limit = 10, search, role, status } = options;
    const skip = (page - 1) * limit;

    const where: Prisma.UserWhereInput = {};

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
        { username: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (role) {
      where.role = role as Prisma.Role;
    }

    if (status) {
      where.status = status as Prisma.Status;
    }

    return this.prisma.user.findMany({
      where,
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        email: true,
        username: true,
        name: true,
        role: true,
        status: true,
        createdAt: true,
        updatedAt: true,
        _count: {
          select: { reports: true },
        },
      },
    });
  }

  async update(id: number, data: Prisma.UserUpdateInput): Promise<User> {
    return this.prisma.user.update({
      where: { id },
      data,
    });
  }

  async delete(id: number): Promise<void> {
    await this.prisma.user.update({
      where: { id },
      data: { status: 'DELETED' },
    });
  }

  async count(options?: {
    search?: string;
    role?: string;
    status?: string;
  }): Promise<number> {
    const { search, role, status } = options || {};

    const where: Prisma.UserWhereInput = {
      status: { not: 'DELETED' },
    };

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } },
        { username: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (role) {
      where.role = role as Prisma.Role;
    }

    if (status) {
      where.status = status as Prisma.Status;
    }

    return this.prisma.user.count({ where });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email },
    });
  }

  async findByUsername(username: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { username },
    });
  }
}
```

### 4. 认证和授权

#### JWT认证实现
```typescript
// services/AuthService.ts
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { UserRepository } from '../repositories/UserRepository';
import { LoginRequest, RegisterRequest, AuthResponse } from '../types/auth';

export class AuthService {
  constructor(
    private userRepository: UserRepository,
    private jwtSecret: string,
    private jwtExpiresIn: string
  ) {}

  async register(userData: RegisterRequest): Promise<AuthResponse> {
    // 检查用户是否已存在
    const existingUser = await this.userRepository.findByEmail(userData.email);
    if (existingUser) {
      throw new Error('邮箱已被注册');
    }

    const existingUsername = await this.userRepository.findByUsername(userData.username);
    if (existingUsername) {
      throw new Error('用户名已被使用');
    }

    // 加密密码
    const hashedPassword = await bcrypt.hash(userData.password, 10);

    // 创建用户
    const user = await this.userRepository.create({
      ...userData,
      password: hashedPassword,
    });

    // 生成JWT令牌
    const token = this.generateToken(user);

    return {
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        name: user.name,
        role: user.role,
      },
      token,
      expiresIn: this.jwtExpiresIn,
    };
  }

  async login(credentials: LoginRequest): Promise<AuthResponse> {
    // 查找用户
    const user = await this.userRepository.findByEmail(credentials.email);
    if (!user) {
      throw new Error('邮箱或密码错误');
    }

    // 验证密码
    const isPasswordValid = await bcrypt.compare(
      credentials.password,
      user.password
    );
    if (!isPasswordValid) {
      throw new Error('邮箱或密码错误');
    }

    // 检查用户状态
    if (user.status !== 'ACTIVE') {
      throw new Error('账户已被禁用');
    }

    // 生成JWT令牌
    const token = this.generateToken(user);

    return {
      user: {
        id: user.id,
        email: user.email,
        username: user.username,
        name: user.name,
        role: user.role,
      },
      token,
      expiresIn: this.jwtExpiresIn,
    };
  }

  async refreshToken(refreshToken: string): Promise<AuthResponse> {
    try {
      const decoded = jwt.verify(refreshToken, this.jwtSecret) as any;
      const user = await this.userRepository.findById(decoded.userId);

      if (!user || user.status !== 'ACTIVE') {
        throw new Error('无效的刷新令牌');
      }

      const token = this.generateToken(user);

      return {
        user: {
          id: user.id,
          email: user.email,
          username: user.username,
          name: user.name,
          role: user.role,
        },
        token,
        expiresIn: this.jwtExpiresIn,
      };
    } catch (error) {
      throw new Error('无效的刷新令牌');
    }
  }

  private generateToken(user: any): string {
    return jwt.sign(
      {
        userId: user.id,
        email: user.email,
        role: user.role,
      },
      this.jwtSecret,
      { expiresIn: this.jwtExpiresIn }
    );
  }

  async verifyToken(token: string): Promise<any> {
    try {
      return jwt.verify(token, this.jwtSecret);
    } catch (error) {
      throw new Error('无效的访问令牌');
    }
  }
}
```

#### 权限中间件
```typescript
// middleware/auth.ts
import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../services/AuthService';

interface AuthenticatedRequest extends Request {
  user?: {
    userId: number;
    email: string;
    role: string;
  };
}

export const authenticateToken = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      code: 401,
      message: '访问令牌缺失',
    });
  }

  try {
    const decoded = req.app.locals.authService.verifyToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      code: 401,
      message: '无效的访问令牌',
    });
  }
};

export const requireRole = (roles: string[]) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        code: 401,
        message: '未认证',
      });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        code: 403,
        message: '权限不足',
      });
    }

    next();
  };
};
```

### 5. 缓存策略

#### Redis缓存实现
```typescript
// services/CacheService.ts
import Redis from 'ioredis';

export class CacheService {
  private redis: Redis;

  constructor(redisUrl: string) {
    this.redis = new Redis(redisUrl);
  }

  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redis.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      console.error('Cache get error:', error);
      return null;
    }
  }

  async set(key: string, value: any, ttl: number = 3600): Promise<void> {
    try {
      await this.redis.setex(key, ttl, JSON.stringify(value));
    } catch (error) {
      console.error('Cache set error:', error);
    }
  }

  async del(key: string): Promise<void> {
    try {
      await this.redis.del(key);
    } catch (error) {
      console.error('Cache delete error:', error);
    }
  }

  async exists(key: string): Promise<boolean> {
    try {
      const result = await this.redis.exists(key);
      return result === 1;
    } catch (error) {
      console.error('Cache exists error:', error);
      return false;
    }
  }

  async invalidatePattern(pattern: string): Promise<void> {
    try {
      const keys = await this.redis.keys(pattern);
      if (keys.length > 0) {
        await this.redis.del(...keys);
      }
    } catch (error) {
      console.error('Cache invalidate pattern error:', error);
    }
  }
}

// 缓存装饰器
export function Cache(ttl: number = 3600, keyPrefix: string = '') {
  return function (target: any, propertyName: string, descriptor: PropertyDescriptor) {
    const method = descriptor.value;

    descriptor.value = async function (...args: any[]) {
      const cacheKey = `${keyPrefix}:${propertyName}:${JSON.stringify(args)}`;
      const cacheService: CacheService = this.cacheService;

      // 尝试从缓存获取
      const cachedResult = await cacheService.get(cacheKey);
      if (cachedResult !== null) {
        return cachedResult;
      }

      // 执行原方法
      const result = await method.apply(this, args);

      // 将结果存入缓存
      await cacheService.set(cacheKey, result, ttl);

      return result;
    };
  };
}

// 使用示例
export class ReportService {
  constructor(
    private reportRepository: ReportRepository,
    private cacheService: CacheService
  ) {}

  @Cache(1800, 'reports') // 缓存30分钟
  async getReportStatistics(timeRange: string): Promise<any> {
    return this.reportRepository.getStatistics(timeRange);
  }
}
```

### 6. 消息队列

#### RabbitMQ集成
```typescript
// services/MessageQueueService.ts
import amqp from 'amqplib';

export interface MessagePayload {
  type: string;
  data: any;
  timestamp: string;
}

export class MessageQueueService {
  private connection: amqp.Connection | null = null;
  private channel: amqp.Channel | null = null;

  constructor(private rabbitmqUrl: string) {}

  async connect(): Promise<void> {
    try {
      this.connection = await amqp.connect(this.rabbitmqUrl);
      this.channel = await this.connection.createChannel();
      console.log('Connected to RabbitMQ');
    } catch (error) {
      console.error('Failed to connect to RabbitMQ:', error);
      throw error;
    }
  }

  async publishToQueue(queueName: string, message: MessagePayload): Promise<void> {
    if (!this.channel) {
      throw new Error('Channel not initialized');
    }

    try {
      await this.channel.assertQueue(queueName, { durable: true });
      this.channel.sendToQueue(
        queueName,
        Buffer.from(JSON.stringify(message)),
        { persistent: true }
      );
      console.log(`Message sent to queue ${queueName}:`, message.type);
    } catch (error) {
      console.error('Failed to publish message:', error);
      throw error;
    }
  }

  async consumeFromQueue(
    queueName: string,
    handler: (message: MessagePayload) => Promise<void>
  ): Promise<void> {
    if (!this.channel) {
      throw new Error('Channel not initialized');
    }

    try {
      await this.channel.assertQueue(queueName, { durable: true });

      this.channel.consume(queueName, async (msg) => {
        if (msg) {
          try {
            const message: MessagePayload = JSON.parse(msg.content.toString());
            await handler(message);
            this.channel!.ack(msg);
            console.log(`Message processed from queue ${queueName}:`, message.type);
          } catch (error) {
            console.error('Failed to process message:', error);
            this.channel!.nack(msg, false, false); // 拒绝并丢弃消息
          }
        }
      });

      console.log(`Started consuming from queue ${queueName}`);
    } catch (error) {
      console.error('Failed to consume from queue:', error);
      throw error;
    }
  }

  async close(): Promise<void> {
    if (this.channel) {
      await this.channel.close();
    }
    if (this.connection) {
      await this.connection.close();
    }
  }
}

// 使用示例
export class AIAnalysisService {
  constructor(
    private messageQueueService: MessageQueueService,
    private aiModelService: AIModelService
  ) {}

  async analyzeReports(reportIds: number[], question: string): Promise<string> {
    // 将分析任务放入队列
    await this.messageQueueService.publishToQueue('ai_analysis', {
      type: 'REPORT_ANALYSIS',
      data: {
        reportIds,
        question,
      },
      timestamp: new Date().toISOString(),
    });

    // 返回任务ID，客户端可以轮询结果
    return `analysis_${Date.now()}`;
  }

  async processAnalysisTask(message: MessagePayload): Promise<void> {
    const { reportIds, question } = message.data;

    try {
      // 获取报告数据
      const reports = await this.getReportsByIds(reportIds);

      // 调用AI模型
      const analysis = await this.aiModelService.analyze(reports, question);

      // 保存分析结果
      await this.saveAnalysisResult(analysis);

      // 发送通知
      await this.sendAnalysisNotification(analysis);
    } catch (error) {
      console.error('Analysis task failed:', error);
    }
  }
}
```

### 7. 错误处理和日志

#### 全局错误处理中间件
```typescript
// middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';
import { Prisma } from '@prisma/client';

export interface CustomError extends Error {
  statusCode?: number;
  code?: string;
}

export const errorHandler = (
  error: CustomError,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  console.error('Error occurred:', {
    message: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
  });

  // Prisma错误处理
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    switch (error.code) {
      case 'P2002':
        return res.status(409).json({
          success: false,
          code: 409,
          message: '数据已存在，请检查唯一性约束',
          error: {
            code: 'DUPLICATE_ENTRY',
            message: '记录已存在',
          },
        });
      case 'P2025':
        return res.status(404).json({
          success: false,
          code: 404,
          message: '记录未找到',
          error: {
            code: 'NOT_FOUND',
            message: '请求的资源不存在',
          },
        });
      default:
        return res.status(500).json({
          success: false,
          code: 500,
          message: '数据库操作失败',
          error: {
            code: 'DATABASE_ERROR',
            message: '数据库操作失败',
          },
        });
    }
  }

  // 验证错误
  if (error.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      code: 400,
      message: '请求参数验证失败',
      error: {
        code: 'VALIDATION_ERROR',
        message: error.message,
      },
    });
  }

  // 认证错误
  if (error.name === 'UnauthorizedError') {
    return res.status(401).json({
      success: false,
      code: 401,
      message: '认证失败',
      error: {
        code: 'UNAUTHORIZED',
        message: '无效的认证信息',
      },
    });
  }

  // 权限错误
  if (error.name === 'ForbiddenError') {
    return res.status(403).json({
      success: false,
      code: 403,
      message: '权限不足',
      error: {
        code: 'FORBIDDEN',
        message: '没有权限执行此操作',
      },
    });
  }

  // 自定义错误
  if (error.statusCode) {
    return res.status(error.statusCode).json({
      success: false,
      code: error.statusCode,
      message: error.message,
      error: {
        code: error.code || 'UNKNOWN_ERROR',
        message: error.message,
      },
    });
  }

  // 默认服务器错误
  return res.status(500).json({
    success: false,
    code: 500,
    message: '服务器内部错误',
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: '服务器处理请求时发生错误',
    },
  });
};
```

#### 日志服务
```typescript
// services/LoggerService.ts
import winston from 'winston';
import DailyRotateFile from 'winston-daily-rotate-file';

export class LoggerService {
  private logger: winston.Logger;

  constructor() {
    this.logger = winston.createLogger({
      level: process.env.LOG_LEVEL || 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.errors({ stack: true }),
        winston.format.json()
      ),
      defaultMeta: {
        service: 'weekly-report-api',
        version: process.env.APP_VERSION || '1.0.0',
      },
      transports: [
        // 控制台输出
        new winston.transports.Console({
          format: winston.format.combine(
            winston.format.colorize(),
            winston.format.simple()
          ),
        }),

        // 错误日志文件
        new DailyRotateFile({
          filename: 'logs/error-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          level: 'error',
          maxSize: '20m',
          maxFiles: '14d',
        }),

        // 组合日志文件
        new DailyRotateFile({
          filename: 'logs/combined-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          maxSize: '20m',
          maxFiles: '14d',
        }),
      ],
    });
  }

  info(message: string, meta?: any): void {
    this.logger.info(message, meta);
  }

  error(message: string, error?: Error | any, meta?: any): void {
    this.logger.error(message, { error, ...meta });
  }

  warn(message: string, meta?: any): void {
    this.logger.warn(message, meta);
  }

  debug(message: string, meta?: any): void {
    this.logger.debug(message, meta);
  }

  // 请求日志
  logRequest(req: Request, res: Response, duration: number): void {
    this.info('HTTP Request', {
      method: req.method,
      url: req.url,
      statusCode: res.statusCode,
      duration: `${duration}ms`,
      ip: req.ip,
      userAgent: req.get('User-Agent'),
    });
  }

  // 业务日志
  logUserAction(userId: number, action: string, details?: any): void {
    this.info('User Action', {
      userId,
      action,
      details,
      timestamp: new Date().toISOString(),
    });
  }

  // 安全日志
  logSecurityEvent(event: string, details?: any): void {
    this.warn('Security Event', {
      event,
      details,
      timestamp: new Date().toISOString(),
    });
  }
}
```

### 8. API文档生成

#### Swagger/OpenAPI配置
```typescript
// config/swagger.ts
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: '周报系统 API',
      version: '1.0.0',
      description: '周报管理系统后端API文档',
    },
    servers: [
      {
        url: 'http://localhost:3000/api/v1',
        description: '开发环境',
      },
      {
        url: 'https://api.weekly-report.com/api/v1',
        description: '生产环境',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        User: {
          type: 'object',
          required: ['email', 'username', 'password', 'name'],
          properties: {
            id: {
              type: 'integer',
              description: '用户ID',
            },
            email: {
              type: 'string',
              format: 'email',
              description: '邮箱地址',
            },
            username: {
              type: 'string',
              description: '用户名',
            },
            name: {
              type: 'string',
              description: '姓名',
            },
            role: {
              type: 'string',
              enum: ['USER', 'ADMIN'],
              description: '用户角色',
            },
            status: {
              type: 'string',
              enum: ['ACTIVE', 'INACTIVE'],
              description: '用户状态',
            },
            createdAt: {
              type: 'string',
              format: 'date-time',
              description: '创建时间',
            },
          },
        },
        ApiResponse: {
          type: 'object',
          required: ['success', 'code', 'message'],
          properties: {
            success: {
              type: 'boolean',
              description: '请求是否成功',
            },
            code: {
              type: 'integer',
              description: '状态码',
            },
            message: {
              type: 'string',
              description: '响应消息',
            },
            data: {
              type: 'object',
              description: '响应数据',
            },
            error: {
              type: 'object',
              properties: {
                code: { type: 'string' },
                message: { type: 'string' },
              },
            },
          },
        },
      },
    },
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ['./src/routes/*.ts', './src/controllers/*.ts'],
};

export const specs = swaggerJsdoc(options);
export const swaggerUiOptions = {
  explorer: true,
  customCss: '.swagger-ui .topbar { display: none }',
};
```

## 可重用资源使用

### 脚本资源 (scripts/)
- `database-migration.js`: 数据库迁移脚本
- `api-generator.js`: API代码生成器
- `performance-monitor.js`: 性能监控工具

### 参考资源 (references/)
- `api-design-patterns.md`: API设计模式参考
- `database-best-practices.md`: 数据库最佳实践
- `security-guidelines.md`: 后端安全指南
- `performance-optimization.md`: 性能优化策略

### 模板资源 (assets/)
- `project-templates/`: 项目模板库
- `docker-templates/`: Docker配置模板
- `ci-cd-templates/`: CI/CD配置模板

这个后端工程师技能提供了完整的现代后端开发能力，包括API设计、数据库操作、微服务架构、缓存策略、消息队列等，能够帮助您构建高质量、高性能的后端服务。