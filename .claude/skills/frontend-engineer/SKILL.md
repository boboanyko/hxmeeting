---
name: frontend-engineer
description: 专业的前端软件工程师技能，专注于现代Web前端开发，包括React/Vue组件开发、TypeScript编程、状态管理、性能优化和用户体验设计。此技能应在用户需要进行前端功能实现、组件开发、UI优化、前端架构设计时使用。
---

# 前端软件工程师技能

## 技能概述

本技能将Claude转换为专业的前端软件工程师，具备全面的现代前端开发能力，包括组件化开发、状态管理、性能优化、前端工程化和用户体验设计。

## 技能应用场景

在以下情况下使用此技能：

- 需要开发React/Vue组件和页面
- 需要实现前端状态管理和数据流
- 需要进行前端性能优化
- 需要设计前端项目架构
- 需要集成第三方库和API
- 需要实现响应式设计和移动端适配
- 需要进行前端测试和质量保证

## 核心技术栈

### 基础技术
- **HTML5/CSS3**: 语义化标签、现代CSS特性
- **JavaScript/TypeScript**: 现代ES6+语法、类型安全
- **前端工程化**: Webpack、Vite、ESLint、Prettier

### 框架和库
- **React**: 组件开发、Hooks、Context API
- **Vue 3**: Composition API、响应式系统
- **状态管理**: Redux、MobX、Pinia、Zustand
- **路由**: React Router、Vue Router

### UI和样式
- **CSS框架**: Ant Design、Element Plus、Tailwind CSS
- **CSS预处理器**: Sass、Less
- **CSS-in-JS**: Styled-components、Emotion
- **响应式设计**: Flexbox、Grid、媒体查询

### 开发工具
- **构建工具**: Vite、Webpack、Rollup
- **代码质量**: ESLint、Prettier、TypeScript
- **测试框架**: Jest、React Testing Library、Cypress
- **调试工具**: Chrome DevTools、React DevTools

## 开发流程和最佳实践

### 1. 项目初始化

#### 创建React项目
```bash
# 使用Vite创建React项目
npm create vite@latest frontend-app -- --template react-ts

# 进入项目目录
cd frontend-app

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

#### 项目结构规划
```
src/
├── components/          # 可复用组件
│   ├── common/         # 通用组件
│   ├── business/       # 业务组件
│   └── ui/            # UI组件
├── pages/              # 页面组件
├── hooks/              # 自定义Hooks
├── store/              # 状态管理
├── services/           # API服务
├── utils/              # 工具函数
├── types/              # TypeScript类型定义
├── assets/             # 静态资源
└── styles/             # 样式文件
```

### 2. 组件开发规范

#### 组件设计原则
- **单一职责**: 每个组件只负责一个功能
- **可复用性**: 设计通用的、可配置的组件
- **可测试性**: 组件逻辑与UI分离
- **性能优化**: 使用React.memo、useMemo等

#### 组件模板
```typescript
// components/common/Button/Button.tsx
import React from 'react';
import { ButtonProps } from './Button.types';
import './Button.css';

const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  loading = false,
  onClick,
  className,
  ...props
}) => {
  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    if (!disabled && !loading && onClick) {
      onClick(event);
    }
  };

  const buttonClass = `
    btn
    btn--${variant}
    btn--${size}
    ${disabled ? 'btn--disabled' : ''}
    ${loading ? 'btn--loading' : ''}
    ${className || ''}
  `;

  return (
    <button
      className={buttonClass}
      disabled={disabled || loading}
      onClick={handleClick}
      {...props}
    >
      {loading ? <span className="btn__spinner" /> : children}
    </button>
  );
};

export default Button;
```

### 3. 状态管理

#### Zustand状态管理示例
```typescript
// store/authStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: string;
  username: string;
  email: string;
  role: string;
}

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  login: (credentials: LoginCredentials) => Promise<void>;
  logout: () => void;
  updateUser: (user: Partial<User>) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      isAuthenticated: false,

      login: async (credentials) => {
        try {
          const response = await authService.login(credentials);
          const { user, token } = response.data;

          set({
            user,
            token,
            isAuthenticated: true,
          });
        } catch (error) {
          console.error('Login failed:', error);
          throw error;
        }
      },

      logout: () => {
        set({
          user: null,
          token: null,
          isAuthenticated: false,
        });
      },

      updateUser: (userData) => {
        const currentUser = get().user;
        if (currentUser) {
          set({
            user: { ...currentUser, ...userData },
          });
        }
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);
```

### 4. API集成

#### API服务封装
```typescript
// services/api.ts
import axios, { AxiosInstance, AxiosRequestConfig } from 'axios';
import { useAuthStore } from '../store/authStore';

class ApiService {
  private client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: import.meta.env.VITE_API_BASE_URL,
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    // 请求拦截器
    this.client.interceptors.request.use(
      (config) => {
        const token = useAuthStore.getState().token;
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    // 响应拦截器
    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          useAuthStore.getState().logout();
          window.location.href = '/login';
        }
        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.get(url, config);
    return response.data;
  }

  async post<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.post(url, data, config);
    return response.data;
  }

  async put<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.put(url, data, config);
    return response.data;
  }

  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.delete(url, config);
    return response.data;
  }
}

export const apiService = new ApiService();
```

### 5. 路由管理

#### React Router配置
```typescript
// router/index.tsx
import React from 'react';
import { createBrowserRouter, Navigate } from 'react-router-dom';
import Layout from '../components/Layout';
import ProtectedRoute from '../components/ProtectedRoute';

// 页面组件
import Login from '../pages/Login';
import Dashboard from '../pages/Dashboard';
import Reports from '../pages/Reports';
import Analytics from '../pages/Analytics';
import Settings from '../pages/Settings';
import NotFound from '../pages/NotFound';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <Navigate to="/dashboard" replace />,
  },
  {
    path: '/login',
    element: <Login />,
  },
  {
    path: '/',
    element: (
      <ProtectedRoute>
        <Layout />
      </ProtectedRoute>
    ),
    children: [
      {
        path: 'dashboard',
        element: <Dashboard />,
      },
      {
        path: 'reports',
        element: <Reports />,
      },
      {
        path: 'analytics',
        element: (
          <ProtectedRoute requiredRole="admin">
            <Analytics />
          </ProtectedRoute>
        ),
      },
      {
        path: 'settings',
        element: (
          <ProtectedRoute requiredRole="admin">
            <Settings />
          </ProtectedRoute>
        ),
      },
    ],
  },
  {
    path: '*',
    element: <NotFound />,
  },
]);
```

### 6. 表单处理

#### React Hook Form + Zod验证
```typescript
// components/ReportForm/ReportForm.tsx
import React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Button, Input, Select, DatePicker } from '../ui';

const reportSchema = z.object({
  title: z.string().min(1, '标题不能为空'),
  employeeId: z.string().min(1, '请选择员工'),
  startDate: z.date(),
  endDate: z.date(),
  projects: z.array(z.object({
    projectId: z.string(),
    status: z.string(),
    priority: z.string(),
    progress: z.string().min(1, '请填写工作进展'),
  })).min(1, '至少添加一个项目'),
});

type ReportFormData = z.infer<typeof reportSchema>;

interface ReportFormProps {
  initialData?: Partial<ReportFormData>;
  onSubmit: (data: ReportFormData) => Promise<void>;
  loading?: boolean;
}

const ReportForm: React.FC<ReportFormProps> = ({
  initialData,
  onSubmit,
  loading = false,
}) => {
  const {
    register,
    control,
    handleSubmit,
    formState: { errors, isValid },
    watch,
    setValue,
  } = useForm<ReportFormData>({
    resolver: zodResolver(reportSchema),
    defaultValues: initialData,
  });

  const handleFormSubmit = async (data: ReportFormData) => {
    try {
      await onSubmit(data);
    } catch (error) {
      console.error('Form submission failed:', error);
    }
  };

  return (
    <form onSubmit={handleSubmit(handleFormSubmit)} className="report-form">
      <div className="form-group">
        <label htmlFor="title">周报标题</label>
        <Input
          id="title"
          {...register('title')}
          error={errors.title?.message}
          placeholder="请输入周报标题"
        />
      </div>

      <div className="form-group">
        <label htmlFor="employeeId">选择员工</label>
        <Select
          id="employeeId"
          {...register('employeeId')}
          error={errors.employeeId?.message}
          options={employeeOptions}
          placeholder="请选择员工"
        />
      </div>

      {/* 其他表单字段... */}

      <div className="form-actions">
        <Button
          type="submit"
          loading={loading}
          disabled={!isValid}
          variant="primary"
        >
          保存周报
        </Button>
      </div>
    </form>
  );
};

export default ReportForm;
```

### 7. 性能优化

#### 代码分割和懒加载
```typescript
// 路由级别的代码分割
import { lazy, Suspense } from 'react';
import { Spinner } from '../components/ui';

const Dashboard = lazy(() => import('../pages/Dashboard'));
const Reports = lazy(() => import('../pages/Reports'));
const Analytics = lazy(() => import('../pages/Analytics'));

// 使用Suspense包装
<Suspense fallback={<Spinner />}>
  <Dashboard />
</Suspense>
```

#### 组件优化
```typescript
// 使用React.memo优化组件
const ReportCard = React.memo<ReportCardProps>(({ report, onEdit, onDelete }) => {
  return (
    <div className="report-card">
      {/* 组件内容 */}
    </div>
  );
}, (prevProps, nextProps) => {
  // 自定义比较函数
  return prevProps.report.id === nextProps.report.id;
});

// 使用useMemo和useCallback
const ReportList: React.FC<ReportListProps> = ({ reports }) => {
  const filteredReports = useMemo(() => {
    return reports.filter(report => report.status === 'active');
  }, [reports]);

  const handleEdit = useCallback((reportId: string) => {
    // 处理编辑逻辑
  }, []);

  return (
    <div className="report-list">
      {filteredReports.map(report => (
        <ReportCard
          key={report.id}
          report={report}
          onEdit={handleEdit}
        />
      ))}
    </div>
  );
};
```

### 8. 测试策略

#### 单元测试示例
```typescript
// __tests__/components/Button.test.tsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from '../components/ui';

describe('Button Component', () => {
  test('renders button with text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  test('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  test('applies correct variant classes', () => {
    render(<Button variant="secondary">Click me</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('btn--secondary');
  });
});
```

#### 集成测试示例
```typescript
// __tests__/pages/Reports.test.tsx
import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import Reports from '../pages/Reports';

const createTestQueryClient = () => new QueryClient({
  defaultOptions: {
    queries: { retry: false },
    mutations: { retry: false },
  },
});

const renderWithProviders = (ui: React.ReactElement) => {
  const queryClient = createTestQueryClient();
  return render(
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        {ui}
      </BrowserRouter>
    </QueryClientProvider>
  );
};

describe('Reports Page', () => {
  test('renders reports list', async () => {
    renderWithProviders(<Reports />);

    expect(screen.getByText('加载中...')).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText('周报列表')).toBeInTheDocument();
    });
  });
});
```

## UI/UX最佳实践

### 1. 响应式设计

#### CSS媒体查询
```css
/* styles/responsive.css */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px;
}

@media (max-width: 768px) {
  .container {
    padding: 0 12px;
  }

  .grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .container {
    padding: 0 8px;
  }
}
```

### 2. 无障碍访问

#### ARIA属性和语义化HTML
```typescript
const ReportCard: React.FC<ReportCardProps> = ({ report }) => {
  return (
    <article
      className="report-card"
      role="article"
      aria-labelledby={`report-title-${report.id}`}
    >
      <h3 id={`report-title-${report.id}`}>
        {report.title}
      </h3>
      <p>{report.description}</p>
      <button
        aria-label={`查看${report.title}的详细信息`}
        onClick={() => handleViewDetails(report.id)}
      >
        查看详情
      </button>
    </article>
  );
};
```

### 3. 用户体验优化

#### 加载状态和错误处理
```typescript
const useReports = () => {
  const [reports, setReports] = useState<Report[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchReports = async () => {
    setLoading(true);
    setError(null);

    try {
      const data = await apiService.get<Report[]>('/reports');
      setReports(data);
    } catch (err) {
      setError('获取周报列表失败，请稍后重试');
      console.error('Failed to fetch reports:', err);
    } finally {
      setLoading(false);
    }
  };

  return { reports, loading, error, fetchReports };
};
```

## 可重用资源使用

### 脚本资源 (scripts/)
- `setup-project.js`: 项目初始化脚本
- `build-optimizer.js`: 构建优化工具
- `component-generator.js`: 组件代码生成器

### 参考资源 (references/)
- `react-patterns.md`: React设计模式参考
- `typescript-best-practices.md`: TypeScript最佳实践
- `performance-guide.md`: 前端性能优化指南
- `testing-guide.md`: 前端测试策略

### 模板资源 (assets/)
- `component-templates/`: 组件模板库
- `page-templates/`: 页面模板库
- `style-templates/`: 样式模板库

## 代码质量保证

### 1. ESLint配置
```json
{
  "extends": [
    "@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "react/prop-types": "off",
    "react/react-in-jsx-scope": "off"
  }
}
```

### 2. Prettier配置
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

### 3. TypeScript配置
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  }
}
```

## 部署和优化

### 1. 构建优化
```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@components': resolve(__dirname, 'src/components'),
      '@pages': resolve(__dirname, 'src/pages'),
      '@utils': resolve(__dirname, 'src/utils'),
    },
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          router: ['react-router-dom'],
          ui: ['antd'],
        },
      },
    },
    chunkSizeWarningLimit: 1000,
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
});
```

### 2. 环境配置
```typescript
// .env.development
VITE_API_BASE_URL=http://localhost:8080/api
VITE_APP_TITLE=周报系统-开发环境

// .env.production
VITE_API_BASE_URL=https://api.weekly-report.com/api
VITE_APP_TITLE=周报系统
```

## 调试和开发工具

### 1. React DevTools
- 组件树检查
- Props和状态调试
- 性能分析

### 2. Redux DevTools
- 状态变化追踪
- 时间旅行调试
- Action历史记录

### 3. Chrome DevTools
- 性能分析
- 网络请求监控
- 内存使用分析

这个前端工程师技能提供了完整的现代前端开发能力，包括组件开发、状态管理、性能优化、测试策略等，能够帮助您构建高质量的前端应用。