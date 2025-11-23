---
name: system-tester
description: 专业的系统测试工程师技能，专注于全面的软件测试，包括冒烟测试、单元测试、集成测试、系统测试、性能测试、安全测试等。具备测试策略制定、测试用例设计、自动化测试实施、缺陷管理和测试报告编写能力。此技能应在用户需要进行系统测试规划、测试用例设计、缺陷分析、测试自动化时使用。
---

# 系统测试工程师技能

## 技能概述

本技能将Claude转换为专业的系统测试工程师，具备全面的软件测试能力，包括测试策略制定、测试用例设计、自动化测试实施、性能测试、安全测试和缺陷管理等。

## 技能应用场景

在以下情况下使用此技能：

- 需要制定系统测试策略和测试计划
- 需要设计测试用例和测试场景
- 需要实施各种类型的测试（冒烟、单元、集成、系统、性能、安全测试）
- 需要搭建自动化测试框架
- 需要进行缺陷分析和质量评估
- 需要编写测试报告和质量评估报告
- 需要进行测试环境搭建和维护

## 核心测试技能

### 测试类型和层级
- **单元测试**: 函数和方法级别的测试
- **集成测试**: 模块间接口和数据流测试
- **系统测试**: 端到端功能测试
- **冒烟测试**: 核心功能快速验证
- **性能测试**: 负载、压力、并发测试
- **安全测试**: 漏洞扫描和渗透测试
- **兼容性测试**: 浏览器、设备兼容性
- **用户验收测试**: 业务场景验证

### 测试工具和技术
- **自动化测试**: Selenium, Cypress, Playwright, Jest, JUnit
- **性能测试**: JMeter, LoadRunner, K6
- **API测试**: Postman, Insomnia, REST Assured
- **安全测试**: OWASP ZAP, Burp Suite, Nessus
- **测试管理**: TestRail, Zephyr, JIRA
- **缺陷管理**: Bugzilla, JIRA, Redmine
- **持续集成**: Jenkins, GitLab CI, CircleCI

## 测试流程和最佳实践

### 1. 测试策略制定

#### 测试策略框架
```
测试策略 = 测试目标 + 测试范围 + 测试方法 + 测试资源 + 测试时间线
```

#### 测试策略模板
```markdown
# [项目名称] 测试策略文档

## 1. 测试目标
- 功能完整性：100%功能覆盖
- 性能指标：响应时间<3秒，并发用户≥100
- 质量目标：严重缺陷0个，一般缺陷<5个

## 2. 测试范围
### 包含范围
- 用户认证和权限管理
- 周报创建、编辑、提交
- 数据统计和分析
- AI智能分析
- 系统配置管理

### 排除范围
- 第三方AI模型的稳定性
- 极端网络环境下的表现

## 3. 测试方法
- 静态测试：代码审查、文档审查
- 动态测试：功能测试、性能测试、安全测试
- 手动测试：用户体验测试、探索性测试
- 自动化测试：回归测试、API测试

## 4. 测试资源
- 人力：2名测试工程师
- 环境：开发、测试、预生产环境
- 工具：Selenium、JMeter、Postman

## 5. 时间线
- 需求分析：Week 1
- 测试设计：Week 2
- 测试执行：Week 3-6
- 回归测试：Week 7
- 测试报告：Week 8
```

### 2. 冒烟测试实施

#### 冒烟测试策略
```typescript
// tests/smoke/smoke-test-suite.ts
import { test, expect } from '@playwright/test';

// 冒烟测试用例 - 验证系统核心功能可用性
describe('周报系统冒烟测试', () => {
  test('系统启动检查', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/周报系统/);
    await expect(page.locator('.logo')).toBeVisible();
  });

  test('用户登录功能', async ({ page }) => {
    await page.goto('/login');

    // 输入用户名密码
    await page.fill('[data-testid="username"]', 'admin');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="login-button"]');

    // 验证登录成功
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="user-info"]')).toContainText('管理员');
  });

  test('周报创建功能', async ({ page }) => {
    // 登录
    await page.goto('/login');
    await page.fill('[data-testid="username"]', 'testuser');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="login-button"]');

    // 创建周报
    await page.click('[data-testid="create-report"]');
    await page.fill('[data-testid="report-title"]', '测试周报');
    await page.click('[data-testid="add-project"]');
    await page.selectOption('[data-testid="project-select"]', '测试项目');
    await page.fill('[data-testid="progress"]', '本周完成了功能开发');
    await page.click('[data-testid="save-report"]');

    // 验证创建成功
    await expect(page.locator('.success-message')).toContainText('周报创建成功');
  });

  test('管理员功能访问', async ({ page }) => {
    // 管理员登录
    await page.goto('/login');
    await page.fill('[data-testid="username"]', 'admin');
    await page.fill('[data-testid="password"]', 'admin123');
    await page.click('[data-testid="login-button"]');

    // 验证管理员菜单可见
    await expect(page.locator('[data-testid="analytics-menu"]')).toBeVisible();
    await expect(page.locator('[data-testid="config-menu"]')).toBeVisible();
  });

  test('API健康检查', async ({ request }) => {
    const response = await request.get('/api/health');
    expect(response.status()).toBe(200);

    const body = await response.json();
    expect(body).toHaveProperty('status', 'healthy');
  });
});
```

#### 冒烟测试报告模板
```markdown
# 冒烟测试报告

**测试时间**: 2025-11-16 10:00-10:30
**测试环境**: 测试环境
**测试版本**: V1.2.0

## 测试结果概览
- 总用例数: 5
- 通过: 4
- 失败: 1
- 跳过: 0
- 通过率: 80%

## 测试用例执行情况

| 用例ID | 用例描述 | 状态 | 执行时间 | 备注 |
|--------|----------|------|----------|------|
| SMK-001 | 系统启动检查 | ✅ 通过 | 2s | 正常 |
| SMK-002 | 用户登录功能 | ✅ 通过 | 3s | 正常 |
| SMK-003 | 周报创建功能 | ❌ 失败 | 5s | 保存接口报错 |
| SMK-004 | 管理员功能访问 | ✅ 通过 | 1s | 正常 |
| SMK-005 | API健康检查 | ✅ 通过 | <1s | 正常 |

## 失败用例分析
**SMK-003: 周报创建功能失败**
- 错误信息: "500 Internal Server Error"
- 失败原因: 数据库连接异常
- 严重程度: 严重
- 负责人: 开发团队
- 预计修复时间: 2小时

## 风险评估
- **高风险**: 1个核心功能失败，影响用户正常使用
- **建议**: 修复失败用例后重新执行冒烟测试

## 结论
系统基本功能可用，但存在严重缺陷，建议修复后再进行后续测试。
```

### 3. 单元测试设计

#### 前端单元测试
```typescript
// src/components/__tests__/ReportForm.test.tsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ReportForm } from '../ReportForm';
import { vi } from 'vitest';

// Mock API服务
vi.mock('../../services/api', () => ({
  reportService: {
    createReport: vi.fn(),
    updateReport: vi.fn(),
    getProjects: vi.fn(),
  },
}));

describe('ReportForm组件单元测试', () => {
  const mockProjects = [
    { id: 1, name: '项目A' },
    { id: 2, name: '项目B' },
  ];

  beforeEach(() => {
    vi.clearAllMocks();
  });

  test('表单渲染正确', () => {
    render(<ReportForm />);

    expect(screen.getByLabelText(/周报标题/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/选择员工/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /添加项目/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /保存周报/i })).toBeInTheDocument();
  });

  test('必填字段验证', async () => {
    const user = userEvent.setup();
    render(<ReportForm />);

    const saveButton = screen.getByRole('button', { name: /保存周报/i });
    await user.click(saveButton);

    expect(screen.getByText(/标题不能为空/i)).toBeInTheDocument();
    expect(screen.getByText(/请选择员工/i)).toBeInTheDocument();
    expect(screen.getByText(/至少添加一个项目/i)).toBeInTheDocument();
  });

  test('添加项目功能', async () => {
    const user = userEvent.setup();
    render(<ReportForm />);

    const addProjectButton = screen.getByRole('button', { name: /添加项目/i });
    await user.click(addProjectButton);

    expect(screen.getByLabelText(/选择项目/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/项目状态/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/优先级/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/工作进展/i)).toBeInTheDocument();
  });

  test('表单提交成功', async () => {
    const user = userEvent.setup();
    const mockOnSubmit = vi.fn();

    render(<ReportForm onSubmit={mockOnSubmit} />);

    // 填写表单
    await user.type(screen.getByLabelText(/周报标题/i), '测试周报');
    await user.selectOptions(screen.getByLabelText(/选择员工/i), '1');

    // 添加项目
    await user.click(screen.getByRole('button', { name: /添加项目/i }));
    await user.selectOptions(screen.getByLabelText(/选择项目/i), '1');
    await user.selectOptions(screen.getByLabelText(/项目状态/i), '进行中');
    await user.selectOptions(screen.getByLabelText(/优先级/i), '高');
    await user.type(screen.getByLabelText(/工作进展/i), '完成了功能开发');

    // 提交表单
    await user.click(screen.getByRole('button', { name: /保存周报/i }));

    await waitFor(() => {
      expect(mockOnSubmit).toHaveBeenCalledWith({
        title: '测试周报',
        employeeId: '1',
        projects: [
          {
            projectId: '1',
            status: '进行中',
            priority: '高',
            progress: '完成了功能开发',
          },
        ],
      });
    });
  });

  test('表单重置功能', async () => {
    const user = userEvent.setup();
    render(<ReportForm />);

    // 填写内容
    await user.type(screen.getByLabelText(/周报标题/i), '测试内容');

    // 重置表单
    await user.click(screen.getByRole('button', { name: /重置/i }));

    expect(screen.getByLabelText(/周报标题/i)).toHaveValue('');
  });
});
```

#### 后端单元测试
```typescript
// tests/unit/services/UserService.test.ts
import { UserService } from '../../../src/services/UserService';
import { UserRepository } from '../../../src/repositories/UserRepository';
import { AuthService } from '../../../src/services/AuthService';
import { PrismaClient } from '@prisma/client';
import { jest } from '@jest/globals';

describe('UserService单元测试', () => {
  let userService: UserService;
  let userRepository: jest.Mocked<UserRepository>;
  let authService: jest.Mocked<AuthService>;
  let prisma: jest.Mocked<PrismaClient>;

  beforeEach(() => {
    userRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      findByEmail: jest.fn(),
      findMany: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      count: jest.fn(),
    } as any;

    authService = {
      hashPassword: jest.fn(),
      verifyPassword: jest.fn(),
    } as any;

    userService = new UserService(userRepository, authService);
  });

  describe('createUser', () => {
    it('应该成功创建用户', async () => {
      // Arrange
      const userData = {
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
        name: '测试用户',
      };

      const hashedPassword = 'hashedPassword123';
      const createdUser = {
        id: 1,
        ...userData,
        password: hashedPassword,
        role: 'USER',
        status: 'ACTIVE',
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      authService.hashPassword.mockResolvedValue(hashedPassword);
      userRepository.create.mockResolvedValue(createdUser);

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(authService.hashPassword).toHaveBeenCalledWith('password123');
      expect(userRepository.create).toHaveBeenCalledWith({
        ...userData,
        password: hashedPassword,
      });
      expect(result).toEqual(createdUser);
    });

    it('应该拒绝重复的邮箱', async () => {
      // Arrange
      const userData = {
        email: 'existing@example.com',
        username: 'testuser',
        password: 'password123',
        name: '测试用户',
      };

      userRepository.findByEmail.mockResolvedValue({ id: 1 } as any);

      // Act & Assert
      await expect(userService.createUser(userData)).rejects.toThrow('邮箱已被注册');
    });
  });

  describe('getUserById', () => {
    it('应该返回用户信息', async () => {
      // Arrange
      const userId = 1;
      const user = {
        id: userId,
        email: 'test@example.com',
        username: 'testuser',
        name: '测试用户',
      };

      userRepository.findById.mockResolvedValue(user as any);

      // Act
      const result = await userService.getUserById(userId);

      // Assert
      expect(userRepository.findById).toHaveBeenCalledWith(userId);
      expect(result).toEqual(user);
    });

    it('用户不存在时应该返回null', async () => {
      // Arrange
      userRepository.findById.mockResolvedValue(null);

      // Act
      const result = await userService.getUserById(999);

      // Assert
      expect(result).toBeNull();
    });
  });
});
```

### 4. 集成测试设计

#### API集成测试
```typescript
// tests/integration/api/reports.test.ts
import request from 'supertest';
import { app } from '../../../src/app';
import { PrismaClient } from '@prisma/client';
import { setupTestDatabase, cleanupTestDatabase } from '../../helpers/database';

const prisma = new PrismaClient();

describe('Reports API集成测试', () => {
  let authToken: string;
  let testUserId: number;
  let testProjectId: number;

  beforeAll(async () => {
    // 设置测试数据库
    await setupTestDatabase();

    // 创建测试用户
    const user = await prisma.user.create({
      data: {
        email: 'test@example.com',
        username: 'testuser',
        password: 'hashedPassword',
        name: '测试用户',
        role: 'USER',
      },
    });
    testUserId = user.id;

    // 创建测试项目
    const project = await prisma.project.create({
      data: {
        name: '测试项目',
        description: '测试项目描述',
      },
    });
    testProjectId = project.id;

    // 获取认证token
    const loginResponse = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'password123',
      });

    authToken = loginResponse.body.data.token;
  });

  afterAll(async () => {
    await cleanupTestDatabase();
    await prisma.$disconnect();
  });

  describe('POST /api/reports', () => {
    it('应该成功创建周报', async () => {
      const reportData = {
        title: '测试周报',
        startDate: '2025-11-10',
        endDate: '2025-11-14',
        projects: [
          {
            projectId: testProjectId,
            status: '进行中',
            priority: '高',
            progress: '完成了用户登录功能',
          },
        ],
      };

      const response = await request(app)
        .post('/api/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .send(reportData);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.title).toBe(reportData.title);
      expect(response.body.data.projects).toHaveLength(1);
    });

    it('未认证用户应该被拒绝', async () => {
      const response = await request(app)
        .post('/api/reports')
        .send({
          title: '未认证周报',
        });

      expect(response.status).toBe(401);
      expect(response.body.success).toBe(false);
    });

    it('应该验证必填字段', async () => {
      const response = await request(app)
        .post('/api/reports')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          title: '',
          startDate: '2025-11-10',
          endDate: '2025-11-14',
        });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.error.message).toContain('标题不能为空');
    });
  });

  describe('GET /api/reports', () => {
    it('应该返回用户的周报列表', async () => {
      const response = await request(app)
        .get('/api/reports')
        .set('Authorization', `Bearer ${authToken}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('应该支持分页', async () => {
      const response = await request(app)
        .get('/api/reports?page=1&limit=5')
        .set('Authorization', `Bearer ${authToken}`);

      expect(response.status).toBe(200);
      expect(response.body.meta.pagination).toBeDefined();
      expect(response.body.meta.pagination.page).toBe(1);
      expect(response.body.meta.pagination.limit).toBe(5);
    });
  });

  describe('PUT /api/reports/:id', () => {
    let reportId: number;

    beforeEach(async () => {
      // 创建测试周报
      const report = await prisma.weeklyReport.create({
        data: {
          employeeId: testUserId,
          title: '原始周报',
          startDate: new Date('2025-11-10'),
          endDate: new Date('2025-11-14'),
          weekNumber: 46,
          status: 'DRAFT',
        },
      });
      reportId = report.id;
    });

    it('应该成功更新周报', async () => {
      const updateData = {
        title: '更新后的周报',
        status: 'SUBMITTED',
      };

      const response = await request(app)
        .put(`/api/reports/${reportId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.title).toBe(updateData.title);
      expect(response.body.data.status).toBe(updateData.status);
    });

    it('不能更新其他用户的周报', async () => {
      // 创建另一个用户
      const otherUser = await prisma.user.create({
        data: {
          email: 'other@example.com',
          username: 'otheruser',
          password: 'hashedPassword',
          name: '其他用户',
          role: 'USER',
        },
      });

      const otherReport = await prisma.weeklyReport.create({
        data: {
          employeeId: otherUser.id,
          title: '其他用户的周报',
          startDate: new Date('2025-11-10'),
          endDate: new Date('2025-11-14'),
          weekNumber: 46,
          status: 'DRAFT',
        },
      });

      const response = await request(app)
        .put(`/api/reports/${otherReport.id}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          title: '尝试更新',
        });

      expect(response.status).toBe(403);
      expect(response.body.success).toBe(false);
    });
  });
});
```

### 5. 系统测试设计

#### 端到端测试场景
```typescript
// tests/e2e/complete-workflow.test.ts
import { test, expect } from '@playwright/test';

test.describe('周报系统完整工作流测试', () => {
  test.beforeEach(async ({ page }) => {
    // 设置测试数据
    await page.goto('/login');
    await page.fill('[data-testid="username"]', 'testuser');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="login-button"]');
    await expect(page).toHaveURL('/dashboard');
  });

  test('完整的周报创建和管理流程', async ({ page }) => {
    // 1. 创建周报
    await page.click('[data-testid="create-report"]');
    await expect(page).toHaveURL('/reports/create');

    // 填写基本信息
    await page.fill('[data-testid="report-title"]', '系统测试周报');

    // 添加项目
    await page.click('[data-testid="add-project"]');
    await page.selectOption('[data-testid="project-select"]', '周报系统V1.2');
    await page.selectOption('[data-testid="status-select"]', '有序推进');
    await page.selectOption('[data-testid="priority-select"]', '优先级高');
    await page.fill('[data-testid="progress-textarea"]',
      '1. 完成了用户认证模块\n' +
      '2. 实现了周报创建功能\n' +
      '3. 修复了数据验证bug'
    );

    // 保存周报
    await page.click('[data-testid="save-report"]');
    await expect(page.locator('.success-message')).toBeVisible();
    await expect(page.locator('.success-message')).toContainText('周报创建成功');

    // 2. 查看周报列表
    await page.click('[data-testid="reports-menu"]');
    await expect(page).toHaveURL('/reports');

    // 验证新创建的周报在列表中
    await expect(page.locator('text=系统测试周报')).toBeVisible();

    // 3. 编辑周报
    await page.click('[data-testid="edit-report"]');
    await expect(page.locator('[data-testid="report-title"]')).toHaveValue('系统测试周报');

    // 修改内容
    await page.fill('[data-testid="report-title"]', '修改后的测试周报');
    await page.click('[data-testid="save-report"]');
    await expect(page.locator('.success-message')).toContainText('周报更新成功');

    // 4. 提交周报
    await page.click('[data-testid="submit-report"]');
    await page.click('[data-testid="confirm-submit"]');
    await expect(page.locator('.success-message')).toContainText('周报提交成功');

    // 5. 验证周报状态
    await expect(page.locator('[data-testid="report-status"]')).toContainText('已提交');
  });

  test('管理员查看和统计功能', async ({ page }) => {
    // 切换到管理员账号
    await page.click('[data-testid="user-menu"]');
    await page.click('[data-testid="logout"]');

    await page.fill('[data-testid="username"]', 'admin');
    await page.fill('[data-testid="password"]', 'admin123');
    await page.click('[data-testid="login-button"]');

    // 1. 查看统计概览
    await page.click('[data-testid="analytics-menu"]');
    await expect(page).toHaveURL('/analytics');

    // 验证统计数据
    await expect(page.locator('[data-testid="total-reports"]')).toBeVisible();
    await expect(page.locator('[data-testid="total-users"]')).toBeVisible();
    await expect(page.locator('[data-testid="total-projects"]')).toBeVisible();

    // 2. 查看图表数据
    await expect(page.locator('[data-testid="user-chart"]')).toBeVisible();
    await expect(page.locator('[data-testid="project-chart"]')).toBeVisible();

    // 3. 搜索和筛选周报
    await page.click('[data-testid="reports-menu"]');
    await page.fill('[data-testid="search-input"]', '测试');
    await page.click('[data-testid="search-button"]');

    // 验证搜索结果
    await expect(page.locator('.report-item')).toHaveCount.greaterThan(0);

    // 4. 导出功能
    await page.click('[data-testid="export-button"]');
    await page.selectOption('[data-testid="export-format"]', 'excel');
    await page.click('[data-testid="confirm-export"]');

    // 验证下载开始（实际项目中可能需要处理下载对话框）
    await expect(page.locator('.export-success')).toBeVisible();
  });

  test('系统配置管理功能', async ({ page }) => {
    // 管理员登录
    await page.goto('/login');
    await page.fill('[data-testid="username"]', 'admin');
    await page.fill('[data-testid="password"]', 'admin123');
    await page.click('[data-testid="login-button"]');

    // 1. 进入系统配置
    await page.click('[data-testid="config-menu"]');
    await expect(page).toHaveURL('/config');

    // 2. 员工管理
    await page.click('[data-testid="employees-tab"]');
    await page.click('[data-testid="add-employee"]');
    await page.fill('[data-testid="employee-name"]', '新员工');
    await page.fill('[data-testid="employee-type"]', '开发');
    await page.click('[data-testid="save-employee"]');
    await expect(page.locator('.success-message')).toContainText('员工添加成功');

    // 3. 项目管理
    await page.click('[data-testid="projects-tab"]');
    await page.click('[data-testid="add-project"]');
    await page.fill('[data-testid="project-name"]', '新项目');
    await page.fill('[data-testid="project-description"]', '项目描述');
    await page.click('[data-testid="save-project"]');
    await expect(page.locator('.success-message')).toContainText('项目添加成功');

    // 4. 验证数据在其他地方可见
    await page.goto('/reports/create');
    await page.click('[data-testid="add-project"]');
    await expect(page.locator('option[value="新项目"]')).toBeVisible();
  });
});
```

### 6. 性能测试设计

#### JMeter性能测试计划
```xml
<!-- performance/weekly-report-system.jmx -->
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0" jmeter="5.4.3">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="周报系统性能测试" enabled="true">
      <stringProp name="TestPlan.comments">周报系统性能测试计划</stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.tearDown_on_shutdown">true</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
      <elementProp name="TestPlan.user_defined_variables" elementType="Arguments">
        <collectionProp name="Arguments.arguments">
          <elementProp name="BASE_URL" elementType="Argument">
            <stringProp name="Argument.name">BASE_URL</stringProp>
            <stringProp name="Argument.value">http://localhost:3000</stringProp>
          </elementProp>
          <elementProp name="AUTH_TOKEN" elementType="Argument">
            <stringProp name="Argument.name">AUTH_TOKEN</stringProp>
            <stringProp name="Argument.value">${__P(auth_token,)}</stringProp>
          </elementProp>
        </collectionProp>
      </elementProp>
    </TestPlan>
    <hashTree>
      <!-- 用户登录线程组 -->
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="用户登录测试" enabled="true">
        <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
        <elementProp name="ThreadGroup.main_controller" elementType="LoopController">
          <boolProp name="LoopController.continue_forever">false</boolProp>
          <stringProp name="LoopController.loops">1</stringProp>
        </elementProp>
        <stringProp name="ThreadGroup.num_threads">10</stringProp>
        <stringProp name="ThreadGroup.ramp_time">5</stringProp>
        <boolProp name="ThreadGroup.scheduler">false</boolProp>
        <stringProp name="ThreadGroup.duration"></stringProp>
        <stringProp name="ThreadGroup.delay"></stringProp>
      </ThreadGroup>
      <hashTree>
        <!-- 登录请求 -->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="用户登录" enabled="true">
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
            <collectionProp name="Arguments.arguments">
              <elementProp name="email" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">test@example.com</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
              </elementProp>
              <elementProp name="password" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">password123</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
              </elementProp>
            </collectionProp>
          </elementProp>
          <stringProp name="HTTPSampler.domain">${BASE_URL}</stringProp>
          <stringProp name="HTTPSampler.port">80</stringProp>
          <stringProp name="HTTPSampler.protocol">http</stringProp>
          <stringProp name="HTTPSampler.contentEncoding">utf-8</stringProp>
          <stringProp name="HTTPSampler.path">/api/auth/login</stringProp>
          <stringProp name="HTTPSampler.method">POST</stringProp>
          <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
          <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
          <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          <stringProp name="HTTPSampler.connect_timeout"></stringProp>
          <stringProp name="HTTPSampler.response_timeout"></stringProp>
        </HTTPSamplerProxy>
        <hashTree/>
        <!-- 响应断言 -->
        <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="响应断言" enabled="true">
          <collectionProp name="Asserion.test_strings">
            <stringProp name="49586">200</stringProp>
          </collectionProp>
          <stringProp name="Assertion.custom_message"></stringProp>
          <stringProp name="Assertion.test_field">Assertion.response_code</stringProp>
          <boolProp name="Assertion.assume_success">false</boolProp>
          <intProp name="Assertion.test_type">1</intProp>
        </ResponseAssertion>
        <hashTree/>
      </hashTree>

      <!-- 周报操作线程组 -->
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="周报操作测试" enabled="true">
        <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
        <elementProp name="ThreadGroup.main_controller" elementType="LoopController">
          <boolProp name="LoopController.continue_forever">false</boolProp>
          <stringProp name="LoopController.loops">10</stringProp>
        </elementProp>
        <stringProp name="ThreadGroup.num_threads">20</stringProp>
        <stringProp name="ThreadGroup.ramp_time">10</stringProp>
        <boolProp name="ThreadGroup.scheduler">true</boolProp>
        <stringProp name="ThreadGroup.duration">300</stringProp>
        <stringProp name="ThreadGroup.delay"></stringProp>
      </ThreadGroup>
      <hashTree>
        <!-- 获取周报列表 -->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="获取周报列表" enabled="true">
          <stringProp name="HTTPSampler.domain">${BASE_URL}</stringProp>
          <stringProp name="HTTPSampler.port">80</stringProp>
          <stringProp name="HTTPSampler.protocol">http</stringProp>
          <stringProp name="HTTPSampler.contentEncoding">utf-8</stringProp>
          <stringProp name="HTTPSampler.path">/api/reports</stringProp>
          <stringProp name="HTTPSampler.method">GET</stringProp>
          <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
          <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
          <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          <stringProp name="HTTPSampler.connect_timeout"></stringProp>
          <stringProp name="HTTPSampler.response_timeout"></stringProp>
        </HTTPSamplerProxy>
        <hashTree/>

        <!-- 创建周报 -->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="创建周报" enabled="true">
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
            <collectionProp name="Arguments.arguments">
              <elementProp name="title" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">性能测试周报_${__time(yyyy-MM-dd HH:mm:ss)}</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
              </elementProp>
              <elementProp name="startDate" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">2025-11-10</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
              </elementProp>
              <elementProp name="endDate" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">true</boolProp>
                <stringProp name="Argument.value">2025-11-14</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
              </elementProp>
            </collectionProp>
          </elementProp>
          <stringProp name="HTTPSampler.domain">${BASE_URL}</stringProp>
          <stringProp name="HTTPSampler.port">80</stringProp>
          <stringProp name="HTTPSampler.protocol">http</stringProp>
          <stringProp name="HTTPSampler.contentEncoding">utf-8</stringProp>
          <stringProp name="HTTPSampler.path">/api/reports</stringProp>
          <stringProp name="HTTPSampler.method">POST</stringProp>
          <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
          <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
        </HTTPSamplerProxy>
        <hashTree/>
      </hashTree>

      <!-- 性能报告生成器 -->
      <ResultCollector guiclass="ViewResultsFullVisualizer" testclass="ResultCollector" testname="查看结果树" enabled="true">
        <boolProp name="ResultCollector.error_logging">false</boolProp>
        <objProp>
          <name>saveConfig</name>
          <value class="SampleSaveConfiguration">
            <time>true</time>
            <latency>true</latency>
            <timestamp>true</timestamp>
            <success>true</success>
            <label>true</label>
            <code>true</code>
            <message>true</message>
            <threadName>true</threadName>
            <dataType>true</dataType>
            <encoding>false</encoding>
            <assertions>true</assertions>
            <subresults>true</subresults>
            <responseData>false</responseData>
            <samplerData>false</samplerData>
            <xml>false</xml>
            <fieldNames>true</fieldNames>
            <responseHeaders>false</responseHeaders>
            <requestHeaders>false</requestHeaders>
            <responseDataOnError>false</responseDataOnError>
            <saveAssertionResultsFailureMessage>true</saveAssertionResultsFailureMessage>
            <assertionsResultsToSave>0</assertionsResultsToSave>
            <bytes>true</bytes>
            <sentBytes>true</sentBytes>
            <url>true</url>
            <threadCounts>true</threadCounts>
            <idleTime>true</idleTime>
            <connectTime>true</connectTime>
          </value>
        </objProp>
        <stringProp name="filename">performance/results.jtl</stringProp>
      </ResultCollector>
      <hashTree/>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

#### 性能测试脚本
```typescript
// tests/performance/load-test.ts
import { check, sleep } from 'k6';
import http from 'k6/http';

export let options = {
  stages: [
    { duration: '2m', target: 10 }, // 2分钟内增加到10个用户
    { duration: '5m', target: 10 }, // 保持10个用户5分钟
    { duration: '2m', target: 50 }, // 2分钟内增加到50个用户
    { duration: '5m', target: 50 }, // 保持50个用户5分钟
    { duration: '2m', target: 0 },  // 2分钟内减少到0个用户
  ],
  thresholds: {
    http_req_duration: ['p(95)<3000'], // 95%的请求响应时间小于3秒
    http_req_failed: ['rate<0.1'],     // 错误率小于10%
  },
};

const BASE_URL = 'http://localhost:3000';
let authToken: string;

export function setup() {
  // 获取认证token
  const loginResponse = http.post(`${BASE_URL}/api/auth/login`, {
    email: 'test@example.com',
    password: 'password123',
  });

  check(loginResponse, {
    '登录成功': (r) => r.status === 200,
    '获取token': (r) => r.json('data.token') !== undefined,
  });

  authToken = loginResponse.json('data.token');
  return { authToken };
}

export default function(data) {
  const headers = {
    Authorization: `Bearer ${data.authToken}`,
    'Content-Type': 'application/json',
  };

  // 1. 获取周报列表
  let response = http.get(`${BASE_URL}/api/reports`, { headers });
  check(response, {
    '获取周报列表成功': (r) => r.status === 200,
    '返回数据格式正确': (r) => r.json('success') === true,
  });

  sleep(1);

  // 2. 创建周报
  const reportData = {
    title: `性能测试周报_${Date.now()}`,
    startDate: '2025-11-10',
    endDate: '2025-11-14',
    projects: [
      {
        projectId: 1,
        status: '进行中',
        priority: '高',
        progress: '性能测试内容',
      },
    ],
  };

  response = http.post(`${BASE_URL}/api/reports`, JSON.stringify(reportData), {
    headers,
  });
  check(response, {
    '创建周报成功': (r) => r.status === 201,
    '周报数据正确': (r) => r.json('data.title') === reportData.title,
  });

  sleep(2);

  // 3. 获取统计数据
  response = http.get(`${BASE_URL}/api/analytics/overview`, { headers });
  check(response, {
    '获取统计数据成功': (r) => r.status === 200,
    '统计数据存在': (r) => r.json('data.totalReports') >= 0,
  });

  sleep(1);
}

export function teardown(data) {
  console.log('性能测试完成');
}
```

### 7. 缺陷管理

#### 缺陷报告模板
```markdown
# 缺陷报告

**缺陷ID**: BUG-2025-001
**项目**: 周报系统V1.2
**报告人**: 测试工程师
**报告日期**: 2025-11-16
**严重等级**: 严重
**优先级**: 高

## 缺陷基本信息
- **标题**: 周报保存时出现数据库连接超时
- **模块**: 周报管理
- **版本**: V1.2.0
- **环境**: 测试环境

## 缺陷描述
### 现象
当用户创建或编辑周报并点击保存时，系统偶尔出现数据库连接超时错误，导致周报保存失败。

### 重现步骤
1. 使用普通用户账号登录系统
2. 点击"创建周报"按钮
3. 填写周报标题和项目信息
4. 点击"保存周报"按钮
5. 观察系统响应

### 预期结果
周报应该成功保存，并显示"保存成功"的提示信息。

### 实际结果
系统显示"数据库连接超时"的错误信息，周报保存失败。

### 重现概率
约30%的概率可以重现此问题。

## 环境信息
- **操作系统**: Windows 10
- **浏览器**: Chrome 119.0
- **数据库**: PostgreSQL 15.0
- **应用服务器**: Node.js 18.x

## 附件
- [错误截图](images/database-timeout-error.png)
- [浏览器控制台日志](logs/console.log)
- [服务器日志](logs/server.log)

## 根本原因分析
1. 数据库连接池配置不当，最大连接数设置过小
2. 在高并发情况下，数据库连接耗尽
3. 没有实现连接重试机制

## 解决建议
1. 增加数据库连接池的最大连接数
2. 实现数据库连接重试机制
3. 优化数据库查询性能
4. 添加数据库连接监控

## 修复验证计划
1. 调整连接池配置后，重复测试保存操作100次
2. 使用JMeter进行并发保存测试，验证问题是否解决
3. 监控数据库连接使用情况，确保连接池正常工作

## 状态
- **当前状态**: 待修复
- **负责人**: 开发团队
- **预计修复时间**: 2025-11-18
```

#### 缺陷跟踪和管理
```typescript
// services/BugTrackingService.ts
export interface Bug {
  id: string;
  title: string;
  description: string;
  severity: 'critical' | 'high' | 'medium' | 'low';
  priority: 'urgent' | 'high' | 'medium' | 'low';
  status: 'new' | 'assigned' | 'in_progress' | 'resolved' | 'closed' | 'reopened';
  assignee?: string;
  reporter: string;
  createdAt: Date;
  updatedAt: Date;
  project: string;
  module: string;
  version: string;
  environment: string;
  reproductionSteps: string[];
  expectedResult: string;
  actualResult: string;
  attachments: string[];
  rootCause?: string;
  resolution?: string;
}

export class BugTrackingService {
  private bugs: Map<string, Bug> = new Map();

  createBug(bugData: Omit<Bug, 'id' | 'createdAt' | 'updatedAt'>): Bug {
    const bug: Bug = {
      ...bugData,
      id: this.generateBugId(),
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    this.bugs.set(bug.id, bug);
    return bug;
  }

  updateBug(id: string, updates: Partial<Bug>): Bug | null {
    const bug = this.bugs.get(id);
    if (!bug) return null;

    const updatedBug = {
      ...bug,
      ...updates,
      updatedAt: new Date(),
    };

    this.bugs.set(id, updatedBug);
    return updatedBug;
  }

  getBug(id: string): Bug | null {
    return this.bugs.get(id) || null;
  }

  getBugs(filters: {
    project?: string;
    severity?: string;
    status?: string;
    assignee?: string;
  }): Bug[] {
    return Array.from(this.bugs.values()).filter(bug => {
      if (filters.project && bug.project !== filters.project) return false;
      if (filters.severity && bug.severity !== filters.severity) return false;
      if (filters.status && bug.status !== filters.status) return false;
      if (filters.assignee && bug.assignee !== filters.assignee) return false;
      return true;
    });
  }

  getBugStatistics(project: string): {
    total: number;
    byStatus: Record<string, number>;
    bySeverity: Record<string, number>;
    openBugs: number;
    criticalBugs: number;
  } {
    const bugs = this.getBugs({ project });

    const byStatus = bugs.reduce((acc, bug) => {
      acc[bug.status] = (acc[bug.status] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const bySeverity = bugs.reduce((acc, bug) => {
      acc[bug.severity] = (acc[bug.severity] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    const openBugs = bugs.filter(bug =>
      ['new', 'assigned', 'in_progress', 'reopened'].includes(bug.status)
    ).length;

    const criticalBugs = bugs.filter(bug =>
      bug.severity === 'critical' &&
      ['new', 'assigned', 'in_progress', 'reopened'].includes(bug.status)
    ).length;

    return {
      total: bugs.length,
      byStatus,
      bySeverity,
      openBugs,
      criticalBugs,
    };
  }

  private generateBugId(): string {
    const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    const sequence = this.bugs.size + 1;
    return `BUG-${date}-${sequence.toString().padStart(3, '0')}`;
  }
}
```

### 8. 测试报告模板

#### 综合测试报告
```markdown
# 周报系统V1.2 系统测试报告

**报告版本**: V1.0
**测试周期**: 2025-11-16 至 2025-11-23
**测试环境**: 测试环境
**测试版本**: V1.2.0

## 执行摘要

### 测试概况
- **总测试用例数**: 156
- **执行用例数**: 156
- **通过用例数**: 142
- **失败用例数**: 12
- **跳过用例数**: 2
- **通过率**: 91.0%

### 缺陷统计
- **发现缺陷总数**: 15个
- **严重缺陷**: 2个
- **主要缺陷**: 6个
- **次要缺陷**: 5个
- **轻微缺陷**: 2个
- **已修复缺陷**: 8个
- **待修复缺陷**: 7个

### 质量评估
- **功能完整性**: 95%
- **性能达标率**: 90%
- **安全性评估**: 良好
- **用户体验**: 良好
- **发布建议**: 条件发布（修复严重缺陷后）

## 详细测试结果

### 1. 功能测试结果

#### 1.1 用户认证模块
| 测试项 | 用例数 | 通过 | 失败 | 跳过 | 通过率 |
|--------|--------|------|------|------|--------|
| 用户登录 | 8 | 8 | 0 | 0 | 100% |
| 用户注册 | 6 | 6 | 0 | 0 | 100% |
| 密码重置 | 4 | 3 | 1 | 0 | 75% |
| 权限验证 | 12 | 11 | 1 | 0 | 91.7% |
| **小计** | **30** | **28** | **2** | **0** | **93.3%** |

#### 1.2 周报管理模块
| 测试项 | 用例数 | 通过 | 失败 | 跳过 | 通过率 |
|--------|--------|------|------|------|--------|
| 周报创建 | 15 | 14 | 1 | 0 | 93.3% |
| 周报编辑 | 12 | 11 | 1 | 0 | 91.7% |
| 周报提交 | 8 | 7 | 1 | 0 | 87.5% |
| 周报搜索 | 6 | 6 | 0 | 0 | 100% |
| 数据导出 | 5 | 4 | 1 | 0 | 80% |
| **小计** | **46** | **42** | **4** | **0** | **91.3%** |

#### 1.3 统计分析模块
| 测试项 | 用例数 | 通过 | 失败 | 跳过 | 通过率 |
|--------|--------|------|------|------|--------|
| 统计概览 | 8 | 8 | 0 | 0 | 100% |
| 图表展示 | 10 | 9 | 1 | 0 | 90% |
| 数据筛选 | 6 | 6 | 0 | 0 | 100% |
| **小计** | **24** | **23** | **1** | **0** | **95.8%** |

#### 1.4 AI智能分析模块
| 测试项 | 用例数 | 通过 | 失败 | 跳过 | 通过率 |
|--------|--------|------|------|------|--------|
| AI分析请求 | 12 | 10 | 2 | 0 | 83.3% |
| 结果展示 | 6 | 5 | 1 | 0 | 83.3% |
| 历史记录 | 4 | 4 | 0 | 0 | 100% |
| **小计** | **22** | **19** | **3** | **0** | **86.4%** |

#### 1.5 系统配置模块
| 测试项 | 用例数 | 通过 | 失败 | 跳过 | 通过率 |
|--------|--------|------|------|------|--------|
| 员工管理 | 10 | 10 | 0 | 0 | 100% |
| 项目管理 | 8 | 8 | 0 | 0 | 100% |
| 状态管理 | 6 | 6 | 0 | 0 | 100% |
| AI模型配置 | 4 | 3 | 0 | 1 | 75% |
| **小计** | **28** | **27** | **0** | **1** | **96.4%** |

### 2. 性能测试结果

#### 2.1 响应时间测试
| 操作类型 | 平均响应时间 | 95%响应时间 | 目标时间 | 状态 |
|----------|--------------|--------------|----------|------|
| 用户登录 | 1.2s | 2.1s | <3s | ✅ 通过 |
| 周报创建 | 2.8s | 4.2s | <3s | ❌ 超时 |
| 周报列表 | 1.5s | 2.3s | <3s | ✅ 通过 |
| 统计分析 | 3.2s | 5.1s | <5s | ✅ 通过 |
| AI分析 | 25.3s | 38.7s | <30s | ✅ 通过 |

#### 2.2 并发测试结果
| 并发用户数 | 成功率 | 平均响应时间 | 错误率 | 状态 |
|------------|--------|--------------|--------|------|
| 10 | 100% | 1.8s | 0% | ✅ 通过 |
| 50 | 98% | 3.2s | 2% | ✅ 通过 |
| 100 | 85% | 6.5s | 15% | ❌ 失败 |

### 3. 安全测试结果

| 安全测试项 | 结果 | 风险等级 | 建议 |
|------------|------|----------|------|
| SQL注入防护 | 通过 | 低 | - |
| XSS防护 | 通过 | 低 | - |
| CSRF防护 | 部分通过 | 中 | 完善CSRF Token机制 |
| 认证绕过 | 通过 | 低 | - |
| 权限提升 | 通过 | 低 | - |
| 敏感信息泄露 | 未通过 | 高 | 移除调试信息 |

## 缺陷分析

### 严重缺陷
1. **BUG-2025-001**: 周报保存时数据库连接超时
   - 影响: 核心功能无法正常使用
   - 状态: 待修复
   - 优先级: 紧急

2. **BUG-2025-002**: 高并发下系统响应缓慢
   - 影响: 用户体验差，可能影响正常业务
   - 状态: 修复中
   - 优先级: 高

### 主要缺陷
1. **BUG-2025-003**: AI分析偶发性失败
2. **BUG-2025-004**: 数据导出格式错误
3. **BUG-2025-005**: CSRF防护不完整
4. **BUG-2025-006**: 图表数据显示异常

## 测试环境

### 硬件环境
- **服务器**: 4核CPU, 8GB内存, 100GB SSD
- **数据库**: PostgreSQL 15.0
- **缓存**: Redis 7.0

### 软件环境
- **操作系统**: Ubuntu 20.04 LTS
- **Web服务器**: Nginx 1.20
- **应用服务器**: Node.js 18.x
- **浏览器**: Chrome 119, Firefox 118

## 测试工具

- **功能测试**: Selenium WebDriver, Playwright
- **性能测试**: JMeter, k6
- **API测试**: Postman, REST Assured
- **安全测试**: OWASP ZAP
- **测试管理**: TestRail

## 风险评估

### 高风险项
1. 数据库性能瓶颈可能影响系统稳定性
2. 高并发场景下的系统响应能力
3. 安全防护机制需要加强

### 中风险项
1. AI功能的稳定性和可靠性
2. 用户体验的细节优化

## 建议和结论

### 改进建议
1. **立即修复严重缺陷**: 优先解决数据库连接和并发性能问题
2. **加强安全防护**: 完善CSRF防护，移除敏感信息
3. **优化性能**: 数据库查询优化，增加缓存机制
4. **完善测试**: 增加边界条件和异常场景测试

### 发布建议
- **条件发布**: 修复所有严重缺陷后可以发布
- **后续优化**: 在后续版本中解决主要缺陷
- **监控计划**: 发布后密切监控系统性能和用户反馈

### 质量目标达成情况
- ✅ 功能完整性: 95% (目标90%)
- ✅ 性能指标: 90% (目标90%)
- ✅ 安全性: 基本达标
- ✅ 用户体验: 良好

---

**测试负责人**: 系统测试工程师
**审核人**: 质量经理
**批准人**: 项目经理
**报告日期**: 2025-11-23
```

## 可重用资源使用

### 脚本资源 (scripts/)
- `test-runner.js`: 自动化测试执行脚本
- `performance-monitor.js`: 性能监控脚本
- `bug-tracker.js`: 缺陷跟踪脚本

### 参考资源 (references/)
- `testing-strategies.md`: 测试策略参考
- `test-case-templates.md`: 测试用例模板
- `automation-frameworks.md`: 自动化测试框架指南
- `performance-testing.md`: 性能测试最佳实践

### 模板资源 (assets/)
- `test-templates/`: 各类测试模板
- `report-templates/`: 测试报告模板
- `bug-templates/`: 缺陷报告模板

这个系统测试工程师技能提供了完整的测试能力，包括各种测试类型的实施、缺陷管理、测试报告编写等，能够帮助您确保软件质量并持续改进测试流程。