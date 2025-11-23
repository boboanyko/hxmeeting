# React设计模式参考指南

## 1. 组件设计模式

### 1.1 容器组件与展示组件模式 (Container/Presentation Pattern)

#### 展示组件 (Presentational Components)
```typescript
// components/UserCard.tsx
interface UserCardProps {
  user: {
    id: string;
    name: string;
    email: string;
    avatar: string;
  };
  onEdit?: (userId: string) => void;
  onDelete?: (userId: string) => void;
}

const UserCard: React.FC<UserCardProps> = ({ user, onEdit, onDelete }) => {
  return (
    <div className="user-card">
      <img src={user.avatar} alt={user.name} className="user-avatar" />
      <div className="user-info">
        <h3 className="user-name">{user.name}</h3>
        <p className="user-email">{user.email}</p>
      </div>
      <div className="user-actions">
        {onEdit && (
          <button onClick={() => onEdit(user.id)}>编辑</button>
        )}
        {onDelete && (
          <button onClick={() => onDelete(user.id)}>删除</button>
        )}
      </div>
    </div>
  );
};
```

#### 容器组件 (Container Components)
```typescript
// containers/UserListContainer.tsx
import { useEffect, useState } from 'react';
import { useUsers } from '../hooks/useUsers';
import UserCard from '../components/UserCard';

const UserListContainer: React.FC = () => {
  const { users, loading, error, fetchUsers, deleteUser } = useUsers();

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const handleEdit = (userId: string) => {
    // 导航到编辑页面
    navigate(`/users/${userId}/edit`);
  };

  const handleDelete = async (userId: string) => {
    if (window.confirm('确定要删除这个用户吗？')) {
      await deleteUser(userId);
    }
  };

  if (loading) return <div>加载中...</div>;
  if (error) return <div>加载失败: {error}</div>;

  return (
    <div className="user-list">
      {users.map(user => (
        <UserCard
          key={user.id}
          user={user}
          onEdit={handleEdit}
          onDelete={handleDelete}
        />
      ))}
    </div>
  );
};
```

### 1.2 高阶组件模式 (Higher-Order Components - HOC)

#### 基础HOC实现
```typescript
// hocs/withLoading.tsx
import React, { ComponentType } from 'react';

interface WithLoadingProps {
  loading: boolean;
}

const withLoading = <P extends object>(
  Component: ComponentType<P>
): ComponentType<P & WithLoadingProps> => {
  const WithLoadingComponent = (props: P & WithLoadingProps) => {
    const { loading, ...rest } = props;

    if (loading) {
      return <div className="loading-spinner">加载中...</div>;
    }

    return <Component {...(rest as P)} />;
  };

  WithLoadingComponent.displayName = `withLoading(${
    Component.displayName || Component.name
  })`;

  return WithLoadingComponent;
};

export default withLoading;
```

#### 使用HOC
```typescript
// components/UserList.tsx
import React from 'react';
import withLoading from '../hocs/withLoading';

interface UserListProps {
  users: User[];
}

const UserList: React.FC<UserListProps> = ({ users }) => {
  return (
    <div className="user-list">
      {users.map(user => (
        <div key={user.id}>{user.name}</div>
      ))}
    </div>
  );
};

export default withLoading(UserList);
```

### 1.3 自定义Hook模式 (Custom Hooks Pattern)

#### 数据获取Hook
```typescript
// hooks/useApi.ts
import { useState, useEffect, useCallback } from 'react';

interface UseApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

interface UseApiReturn<T> extends UseApiState<T> {
  execute: () => Promise<void>;
  reset: () => void;
}

export const useApi = <T>(
  apiFunction: () => Promise<T>
): UseApiReturn<T> => {
  const [state, setState] = useState<UseApiState<T>>({
    data: null,
    loading: false,
    error: null,
  });

  const execute = useCallback(async () => {
    setState(prev => ({ ...prev, loading: true, error: null }));

    try {
      const data = await apiFunction();
      setState({ data, loading: false, error: null });
    } catch (error) {
      setState({
        data: null,
        loading: false,
        error: error instanceof Error ? error.message : '未知错误',
      });
    }
  }, [apiFunction]);

  const reset = useCallback(() => {
    setState({
      data: null,
      loading: false,
      error: null,
    });
  }, []);

  return { ...state, execute, reset };
};
```

#### 表单处理Hook
```typescript
// hooks/useForm.ts
import { useState, useCallback } from 'react';

interface FormState<T> {
  values: T;
  errors: Partial<Record<keyof T, string>>;
  touched: Partial<Record<keyof T, boolean>>;
}

interface UseFormReturn<T> extends FormState<T> {
  setValue: <K extends keyof T>(field: K, value: T[K]) => void;
  setError: <K extends keyof T>(field: K, error: string) => void;
  setTouched: <K extends keyof T>(field: K) => void;
  validate: () => boolean;
  reset: (values?: T) => void;
}

export const useForm = <T extends Record<string, any>>(
  initialValues: T,
  validate?: (values: T) => Partial<Record<keyof T, string>>
): UseFormReturn<T> => {
  const [state, setState] = useState<FormState<T>>({
    values: initialValues,
    errors: {},
    touched: {},
  });

  const setValue = useCallback(<K extends keyof T>(field: K, value: T[K]) => {
    setState(prev => ({
      ...prev,
      values: { ...prev.values, [field]: value },
    }));
  }, []);

  const setError = useCallback(<K extends keyof T>(field: K, error: string) => {
    setState(prev => ({
      ...prev,
      errors: { ...prev.errors, [field]: error },
    }));
  }, []);

  const setTouched = useCallback(<K extends keyof T>(field: K) => {
    setState(prev => ({
      ...prev,
      touched: { ...prev.touched, [field]: true },
    }));
  }, []);

  const validate = useCallback(() => {
    if (!validate) return true;

    const errors = validate(state.values);
    setState(prev => ({ ...prev, errors }));
    return Object.keys(errors).length === 0;
  }, [validate, state.values]);

  const reset = useCallback((values?: T) => {
    setState({
      values: values || initialValues,
      errors: {},
      touched: {},
    });
  }, [initialValues]);

  return {
    ...state,
    setValue,
    setError,
    setTouched,
    validate,
    reset,
  };
};
```

### 1.4 Render Props模式

#### 基础Render Props实现
```typescript
// components/DataFetcher.tsx
import React, { useState, useEffect } from 'react';

interface DataFetcherProps<T> {
  url: string;
  children: (props: {
    data: T | null;
    loading: boolean;
    error: string | null;
    refetch: () => void;
  }) => React.ReactNode;
}

function DataFetcher<T>({ url, children }: DataFetcherProps<T>) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchData = async () => {
    setLoading(true);
    setError(null);

    try {
      const response = await fetch(url);
      const result = await response.json();
      setData(result);
    } catch (err) {
      setError(err instanceof Error ? err.message : '请求失败');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [url]);

  return (
    <>
      {children({
        data,
        loading,
        error,
        refetch: fetchData,
      })}
    </>
  );
}

// 使用示例
const UserList = () => {
  return (
    <DataFetcher<User[]> url="/api/users">
      {({ data, loading, error, refetch }) => {
        if (loading) return <div>加载中...</div>;
        if (error) return <div>错误: {error}</div>;
        if (!data) return <div>暂无数据</div>;

        return (
          <div>
            <button onClick={refetch}>刷新</button>
            {data.map(user => (
              <div key={user.id}>{user.name}</div>
            ))}
          </div>
        );
      }}
    </DataFetcher>
  );
};
```

## 2. 状态管理模式

### 2.1 Context API + useReducer模式

#### 创建Context
```typescript
// context/AuthContext.tsx
import React, { createContext, useContext, useReducer, ReactNode } from 'react';

interface User {
  id: string;
  name: string;
  email: string;
  role: string;
}

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  loading: boolean;
}

type AuthAction =
  | { type: 'LOGIN_START' }
  | { type: 'LOGIN_SUCCESS'; payload: { user: User; token: string } }
  | { type: 'LOGIN_FAILURE' }
  | { type: 'LOGOUT' }
  | { type: 'SET_LOADING'; payload: boolean };

const initialState: AuthState = {
  user: null,
  token: null,
  isAuthenticated: false,
  loading: false,
};

const authReducer = (state: AuthState, action: AuthAction): AuthState => {
  switch (action.type) {
    case 'LOGIN_START':
      return { ...state, loading: true };
    case 'LOGIN_SUCCESS':
      return {
        ...state,
        user: action.payload.user,
        token: action.payload.token,
        isAuthenticated: true,
        loading: false,
      };
    case 'LOGIN_FAILURE':
      return {
        ...state,
        user: null,
        token: null,
        isAuthenticated: false,
        loading: false,
      };
    case 'LOGOUT':
      return {
        ...state,
        user: null,
        token: null,
        isAuthenticated: false,
      };
    case 'SET_LOADING':
      return { ...state, loading: action.payload };
    default:
      return state;
  }
};

const AuthContext = createContext<{
  state: AuthState;
  dispatch: React.Dispatch<AuthAction>;
} | null>(null);

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [state, dispatch] = useReducer(authReducer, initialState);

  return (
    <AuthContext.Provider value={{ state, dispatch }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};
```

### 2.2 自定义状态管理Hook

#### 轻量级状态管理
```typescript
// hooks/useStore.ts
import { useState, useCallback } from 'react';

interface StoreState {
  [key: string]: any;
}

interface StoreActions {
  setState: <K extends keyof StoreState>(
    key: K,
    value: StoreState[K]
  ) => void;
  getState: <K extends keyof StoreState>(key: K) => StoreState[K];
  clearState: () => void;
}

export const useStore = <T extends StoreState>(
  initialState: T
): [T, StoreActions] => {
  const [state, setState] = useState<T>(initialState);

  const setItem = useCallback(
    <K extends keyof T>(key: K, value: T[K]) => {
      setState(prev => ({ ...prev, [key]: value }));
    },
    []
  );

  const getItem = useCallback(
    <K extends keyof T>(key: K): T[K] => {
      return state[key];
    },
    [state]
  );

  const clearState = useCallback(() => {
    setState(initialState);
  }, [initialState]);

  const actions: StoreActions = {
    setState: setItem,
    getState: getItem,
    clearState,
  };

  return [state, actions];
};
```

## 3. 性能优化模式

### 3.1 组件记忆化模式

#### React.memo使用
```typescript
// components/ExpensiveComponent.tsx
import React from 'react';

interface ExpensiveComponentProps {
  data: complexData;
  onUpdate: (id: string) => void;
}

const ExpensiveComponent = React.memo<ExpensiveComponentProps>(
  ({ data, onUpdate }) => {
    console.log('ExpensiveComponent rendered');

    return (
      <div>
        {data.items.map(item => (
          <div key={item.id}>
            <span>{item.name}</span>
            <button onClick={() => onUpdate(item.id)}>
              更新
            </button>
          </div>
        ))}
      </div>
    );
  },
  (prevProps, nextProps) => {
    // 自定义比较函数
    return (
      prevProps.data.version === nextProps.data.version &&
      prevProps.onUpdate === nextProps.onUpdate
    );
  }
);

export default ExpensiveComponent;
```

#### useMemo和useCallback使用
```typescript
// components/DataProcessor.tsx
import React, { useMemo, useCallback } from 'react';

interface DataProcessorProps {
  rawData: RawData[];
  filter: FilterOptions;
  onItemClick: (item: ProcessedItem) => void;
}

const DataProcessor: React.FC<DataProcessorProps> = ({
  rawData,
  filter,
  onItemClick,
}) => {
  // 记忆化处理后的数据
  const processedData = useMemo(() => {
    console.log('Processing data...');
    return rawData
      .filter(item => item.status === filter.status)
      .map(item => ({
        ...item,
        displayName: `${item.firstName} ${item.lastName}`,
        formattedDate: new Date(item.createdAt).toLocaleDateString(),
      }));
  }, [rawData, filter.status]);

  // 记忆化点击处理函数
  const handleClick = useCallback(
    (item: ProcessedItem) => {
      onItemClick(item);
    },
    [onItemClick]
  );

  return (
    <div>
      {processedData.map(item => (
        <div key={item.id} onClick={() => handleClick(item)}>
          {item.displayName} - {item.formattedDate}
        </div>
      ))}
    </div>
  );
};
```

### 3.2 虚拟滚动模式

#### 虚拟列表实现
```typescript
// components/VirtualList.tsx
import React, { useState, useEffect, useRef, useMemo } from 'react';

interface VirtualListProps<T> {
  items: T[];
  itemHeight: number;
  containerHeight: number;
  renderItem: (item: T, index: number) => React.ReactNode;
}

function VirtualList<T>({
  items,
  itemHeight,
  containerHeight,
  renderItem,
}: VirtualListProps<T>) {
  const [scrollTop, setScrollTop] = useState(0);
  const containerRef = useRef<HTMLDivElement>(null);

  const visibleRange = useMemo(() => {
    const startIndex = Math.floor(scrollTop / itemHeight);
    const endIndex = Math.min(
      startIndex + Math.ceil(containerHeight / itemHeight) + 1,
      items.length
    );
    return { startIndex, endIndex };
  }, [scrollTop, itemHeight, containerHeight, items.length]);

  const visibleItems = useMemo(() => {
    return items.slice(visibleRange.startIndex, visibleRange.endIndex);
  }, [items, visibleRange]);

  const handleScroll = (e: React.UIEvent<HTMLDivElement>) => {
    setScrollTop(e.currentTarget.scrollTop);
  };

  return (
    <div
      ref={containerRef}
      style={{ height: containerHeight, overflow: 'auto' }}
      onScroll={handleScroll}
    >
      <div style={{ height: items.length * itemHeight, position: 'relative' }}>
        <div
          style={{
            transform: `translateY(${visibleRange.startIndex * itemHeight}px)`,
          }}
        >
          {visibleItems.map((item, index) => (
            <div
              key={visibleRange.startIndex + index}
              style={{ height: itemHeight }}
            >
              {renderItem(item, visibleRange.startIndex + index)}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// 使用示例
const BigList = () => {
  const items = Array.from({ length: 10000 }, (_, i) => ({
    id: i,
    name: `Item ${i}`,
    description: `This is item number ${i}`,
  }));

  return (
    <VirtualList
      items={items}
      itemHeight={60}
      containerHeight={400}
      renderItem={(item, index) => (
        <div style={{ padding: '10px', borderBottom: '1px solid #eee' }}>
          <h4>{item.name}</h4>
          <p>{item.description}</p>
        </div>
      )}
    />
  );
};
```

## 4. 错误边界模式

### 4.1 错误边界组件
```typescript
// components/ErrorBoundary.tsx
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface ErrorBoundaryProps {
  children: ReactNode;
  fallback?: ReactNode;
  onError?: (error: Error, errorInfo: ErrorInfo) => void;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error?: Error;
}

class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('ErrorBoundary caught an error:', error, errorInfo);
    this.props.onError?.(error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <div className="error-boundary">
          <h2>出现了一些问题</h2>
          <p>{this.state.error?.message}</p>
          <button onClick={() => this.setState({ hasError: false, error: undefined })}>
            重试
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// Hook版本的错误边界
export const useErrorBoundary = () => {
  const [error, setError] = useState<Error | null>(null);

  const resetError = useCallback(() => {
    setError(null);
  }, []);

  const captureError = useCallback((error: Error) => {
    setError(error);
  }, []);

  if (error) {
    throw error;
  }

  return { captureError, resetError };
};
```

## 5. 复合组件模式

### 5.1 复合组件实现
```typescript
// components/Tabs/Tabs.tsx
import React, { createContext, useContext, useState, ReactNode } from 'react';

interface TabsContextValue {
  activeTab: string;
  setActiveTab: (tabId: string) => void;
}

const TabsContext = createContext<TabsContextValue | null>(null);

const useTabs = () => {
  const context = useContext(TabsContext);
  if (!context) {
    throw new Error('Tabs components must be used within Tabs provider');
  }
  return context;
};

interface TabsProps {
  defaultTab?: string;
  children: ReactNode;
  className?: string;
}

const Tabs: React.FC<TabsProps> & {
  Tab: typeof Tab;
  TabPanel: typeof TabPanel;
} = ({ defaultTab, children, className = '' }) => {
  const [activeTab, setActiveTab] = useState(defaultTab || '');

  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div className={`tabs ${className}`}>
        {children}
      </div>
    </TabsContext.Provider>
  );
};

interface TabProps {
  tabId: string;
  children: ReactNode;
  className?: string;
}

const Tab: React.FC<TabProps> = ({ tabId, children, className = '' }) => {
  const { activeTab, setActiveTab } = useTabs();
  const isActive = activeTab === tabId;

  return (
    <button
      className={`tab ${isActive ? 'tab--active' : ''} ${className}`}
      onClick={() => setActiveTab(tabId)}
    >
      {children}
    </button>
  );
};

interface TabPanelProps {
  tabId: string;
  children: ReactNode;
  className?: string;
}

const TabPanel: React.FC<TabPanelProps> = ({ tabId, children, className = '' }) => {
  const { activeTab } = useTabs();

  if (activeTab !== tabId) {
    return null;
  }

  return (
    <div className={`tab-panel ${className}`}>
      {children}
    </div>
  );
};

Tabs.Tab = Tab;
Tabs.TabPanel = TabPanel;

export default Tabs;

// 使用示例
const ExampleTabs = () => {
  return (
    <Tabs defaultTab="profile">
      <div className="tab-list">
        <Tabs.Tab tabId="profile">个人资料</Tabs.Tab>
        <Tabs.Tab tabId="settings">设置</Tabs.Tab>
        <Tabs.Tab tabId="notifications">通知</Tabs.Tab>
      </div>

      <div className="tab-content">
        <Tabs.TabPanel tabId="profile">
          <h3>个人资料</h3>
          <p>这里是个人资料内容</p>
        </Tabs.TabPanel>

        <Tabs.TabPanel tabId="settings">
          <h3>设置</h3>
          <p>这里是设置内容</p>
        </Tabs.TabPanel>

        <Tabs.TabPanel tabId="notifications">
          <h3>通知</h3>
          <p>这里是通知内容</p>
        </Tabs.TabPanel>
      </div>
    </Tabs>
  );
};
```

这些设计模式提供了构建高质量React应用的最佳实践，能够帮助您编写更加清晰、可维护和高性能的代码。