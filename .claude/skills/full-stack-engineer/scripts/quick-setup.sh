#!/bin/bash

# 全栈项目快速设置脚本
# 用于快速初始化一个全栈开发项目

set -e

PROJECT_NAME="${1:-my-fullstack-app}"
FRONTEND_FRAMEWORK="${2:-react}"
BACKEND_FRAMEWORK="${3:-express}"
DATABASE="${4:-postgresql}"

echo "🚀 开始创建全栈项目: $PROJECT_NAME"
echo "📋 配置: 前端=$FRONTEND_FRAMEWORK, 后端=$BACKEND_FRAMEWORK, 数据库=$DATABASE"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建README
cat > README.md << EOF
# $PROJECT_NAME

全栈Web应用程序

## 技术栈
- 前端: $FRONTEND_FRAMEWORK + TypeScript
- 后端: $BACKEND_FRAMEWORK + TypeScript
- 数据库: $DATABASE

## 快速开始

\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

## 开发

### 前端开发
cd frontend && npm run dev

### 后端开发
cd backend && npm run dev
EOF

# 创建根目录package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Full-stack web application",
  "private": true,
  "scripts": {
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build"
  },
  "devDependencies": {
    "concurrently": "^7.6.0"
  }
}
EOF

# 创建前端应用
echo "⚛️  创建前端应用..."
mkdir -p frontend/src/{components,pages,hooks,services,store,types,utils,styles}

cd frontend

# 前端package.json
cat > package.json << EOF
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "zustand": "^4.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "typescript": "^4.9.0"
  }
}
EOF

# Vite配置
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > tsconfig.node.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# 入口文件
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# React入口文件
cat > src/main.tsx << EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# App组件
cat > src/App.tsx << EOF
import React from 'react'
import { BrowserRouter } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <h1>$PROJECT_NAME</h1>
        <p>全栈应用已成功创建！</p>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

cd ..

# 创建后端应用
echo "🔧 创建后端应用..."
mkdir -p backend/src/{controllers,services,models,middleware,routes,utils,types}

cd backend

# 后端package.json
cat > package.json << EOF
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "dotenv": "^16.0.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/bcryptjs": "^2.4.2",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/node": "^18.14.0",
    "typescript": "^4.9.5",
    "nodemon": "^2.0.20",
    "tsx": "^3.12.0"
  }
}
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# 环境变量模板
cat > .env.example << EOF
NODE_ENV=development
PORT=8000
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=http://localhost:3000
EOF

# 入口文件
cat > src/index.ts << EOF
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import dotenv from 'dotenv'

// 加载环境变量
dotenv.config()

const app = express()
const port = process.env.PORT || 8000

// 中间件
app.use(helmet())
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}))
app.use(express.json())

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'API is running' })
})

// 启动服务器
app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`)
})
EOF

# 基础路由
cat > src/routes/index.ts << EOF
import { Router } from 'express'

const router = Router()

// API路由
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'API is working' })
})

export default router
EOF

cd ..

# 创建Docker配置
echo "🐳 创建Docker配置..."
mkdir -p docker
cat > docker/docker-compose.yml << EOF
version: '3.8'

services:
  frontend:
    build:
      context: ../
      dockerfile: docker/Dockerfile.frontend
    ports:
      - "3000:80"
    depends_on:
      - backend

  backend:
    build:
      context: ../
      dockerfile: docker/Dockerfile.backend
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=production
      - PORT=8000
    env_file:
      - ../backend/.env

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend
EOF

cat > docker/Dockerfile.frontend << EOF
FROM node:18-alpine as build

WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci --only=production

COPY frontend/ ./
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > docker/Dockerfile.backend << EOF
FROM node:18-alpine

WORKDIR /app

COPY backend/package*.json ./
RUN npm ci --only=production

COPY backend/dist ./dist

EXPOSE 8000

CMD ["node", "dist/index.js"]
EOF

cat > docker/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:8000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /api {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOF

# 创建GitHub Actions配置
echo "🚀 创建CI/CD配置..."
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << EOF
name: CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: |
          frontend/package-lock.json
          backend/package-lock.json

    - name: Install dependencies
      run: |
        npm ci
        cd frontend && npm ci
        cd ../backend && npm ci

    - name: Run tests
      run: |
        cd frontend && npm test
        cd ../backend && npm test

    - name: Build
      run: |
        cd frontend && npm run build
        cd ../backend && npm run build
EOF

# 安装根依赖
echo "📦 安装根依赖..."
npm install

echo "✅ 全栈项目创建完成！"
echo ""
echo "📁 项目结构:"
echo "  $PROJECT_NAME/"
echo "  ├── frontend/          # React前端应用"
echo "  ├── backend/           # Node.js后端API"
echo "  ├── docker/            # Docker配置"
echo "  └── .github/workflows/ # CI/CD配置"
echo ""
echo "🚀 快速开始:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm run install:all  # 安装所有依赖"
echo "  3. npm run dev          # 启动开发服务器"
echo ""
echo "📖 文档:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端API: http://localhost:8000/api/health"
echo ""
echo "🔧 开发命令:"
echo "  - 前端开发: cd frontend && npm run dev"
echo "  - 后端开发: cd backend && npm run dev"
echo "  - 构建项目: npm run build"
echo "  - 运行测试: npm test""# 快速创建全栈项目的脚本
# 使用示例: ./quick-setup.sh my-app react express postgresql

set -e

PROJECT_NAME="${1:-my-fullstack-app}"
FRONTEND_FRAMEWORK="${2:-react}"
BACKEND_FRAMEWORK="${3:-express}"
DATABASE="${4:-postgresql}"

echo "🚀 开始创建全栈项目: $PROJECT_NAME"
echo "📋 配置: 前端=$FRONTEND_FRAMEWORK, 后端=$BACKEND_FRAMEWORK, 数据库=$DATABASE"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建README
cat > README.md << EOF
# $PROJECT_NAME

全栈Web应用程序

## 技术栈
- 前端: $FRONTEND_FRAMEWORK + TypeScript
- 后端: $BACKEND_FRAMEWORK + TypeScript
- 数据库: $DATABASE

## 快速开始

\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

## 开发

### 前端开发
cd frontend && npm run dev

### 后端开发
cd backend && npm run dev
EOF

# 创建根目录package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Full-stack web application",
  "private": true,
  "scripts": {
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build"
  },
  "devDependencies": {
    "concurrently": "^7.6.0"
  }
}
EOF

# 创建前端应用
echo "⚛️  创建前端应用..."
mkdir -p frontend/src/{components,pages,hooks,services,store,types,utils,styles}

cd frontend

# 前端package.json
cat > package.json << EOF
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "zustand": "^4.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "typescript": "^4.9.0"
  }
}
EOF

# Vite配置
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > tsconfig.node.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# 入口文件
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# React入口文件
cat > src/main.tsx << EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# App组件
cat > src/App.tsx << EOF
import React from 'react'
import { BrowserRouter } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <h1>$PROJECT_NAME</h1>
        <p>全栈应用已成功创建！</p>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

cd ..

# 创建后端应用
echo "🔧 创建后端应用..."
mkdir -p backend/src/{controllers,services,models,middleware,routes,utils,types}

cd backend

# 后端package.json
cat > package.json << EOF
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "dotenv": "^16.0.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/bcryptjs": "^2.4.2",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/node": "^18.14.0",
    "typescript": "^4.9.5",
    "nodemon": "^2.0.20",
    "tsx": "^3.12.0"
  }
}
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# 环境变量模板
cat > .env.example << EOF
NODE_ENV=development
PORT=8000
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=http://localhost:3000
EOF

# 入口文件
cat > src/index.ts << EOF
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import dotenv from 'dotenv'

// 加载环境变量
dotenv.config()

const app = express()
const port = process.env.PORT || 8000

// 中间件
app.use(helmet())
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}))
app.use(express.json())

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'API is running' })
})

// 启动服务器
app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`)
})
EOF

# 基础路由
cat > src/routes/index.ts << EOF
import { Router } from 'express'

const router = Router()

// API路由
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'API is working' })
})

export default router
EOF

cd ..

# 创建Docker配置
echo "🐳 创建Docker配置..."
mkdir -p docker
cat > docker/docker-compose.yml << EOF
version: '3.8'

services:
  frontend:
    build:
      context: ../
      dockerfile: docker/Dockerfile.frontend
    ports:
      - "3000:80"
    depends_on:
      - backend

  backend:
    build:
      context: ../
      dockerfile: docker/Dockerfile.backend
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=production
      - PORT=8000
    env_file:
      - ../backend/.env

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend
EOF

cat > docker/Dockerfile.frontend << EOF
FROM node:18-alpine as build

WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci --only=production

COPY frontend/ ./
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat > docker/Dockerfile.backend << EOF
FROM node:18-alpine

WORKDIR /app

COPY backend/package*.json ./
RUN npm ci --only=production

COPY backend/dist ./dist

EXPOSE 8000

CMD ["node", "dist/index.js"]
EOF

cat > docker/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:8000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /api {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOF

# 创建GitHub Actions配置
echo "🚀 创建CI/CD配置..."
mkdir -p .github/workflows
cat > .github/workflows/ci.yml << EOF
name: CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: |
          frontend/package-lock.json
          backend/package-lock.json

    - name: Install dependencies
      run: |
        npm ci
        cd frontend && npm ci
        cd ../backend && npm ci

    - name: Run tests
      run: |
        cd frontend && npm test
        cd ../backend && npm test

    - name: Build
      run: |
        cd frontend && npm run build
        cd ../backend && npm run build
EOF

# 安装根依赖
echo "📦 安装根依赖..."
npm install

echo "✅ 全栈项目创建完成！"
echo ""
echo "📁 项目结构:"
echo "  $PROJECT_NAME/"
echo "  ├── frontend/          # React前端应用"
echo "  ├── backend/           # Node.js后端API"
echo "  ├── docker/            # Docker配置"
echo "  └── .github/workflows/ # CI/CD配置"
echo ""
echo "🚀 快速开始:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm run install:all  # 安装所有依赖"
echo "  3. npm run dev          # 启动开发服务器"
echo ""
echo "📖 文档:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端API: http://localhost:8000/api/health"
echo ""
echo "🔧 开发命令:"
echo "  - 前端开发: cd frontend && npm run dev"
echo "  - 后端开发: cd backend && npm run dev"
echo "  - 构建项目: npm run build"
echo "  - 运行测试: npm test""# 快速创建全栈项目的脚本
# 使用示例: ./quick-setup.sh my-app react express postgresql

set -e

PROJECT_NAME="${1:-my-fullstack-app}"
FRONTEND_FRAMEWORK="${2:-react}"
BACKEND_FRAMEWORK="${3:-express}"
DATABASE="${4:-postgresql}"

echo "🚀 开始创建全栈项目: $PROJECT_NAME"
echo "📋 配置: 前端=$FRONTEND_FRAMEWORK, 后端=$BACKEND_FRAMEWORK, 数据库=$DATABASE"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建README
cat > README.md << EOF
# $PROJECT_NAME

全栈Web应用程序

## 技术栈
- 前端: $FRONTEND_FRAMEWORK + TypeScript
- 后端: $BACKEND_FRAMEWORK + TypeScript
- 数据库: $DATABASE

## 快速开始

\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

## 开发

### 前端开发
cd frontend && npm run dev

### 后端开发
cd backend && npm run dev
EOF

# 创建根目录package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Full-stack web application",
  "private": true,
  "scripts": {
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build"
  },
  "devDependencies": {
    "concurrently": "^7.6.0"
  }
}
EOF

# 创建前端应用
echo "⚛️  创建前端应用..."
mkdir -p frontend/src/{components,pages,hooks,services,store,types,utils,styles}

cd frontend

# 前端package.json
cat > package.json << EOF
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "zustand": "^4.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "typescript": "^4.9.0"
  }
}
EOF

# Vite配置
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > tsconfig.node.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# 入口文件
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# React入口文件
cat > src/main.tsx << EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# App组件
cat > src/App.tsx << EOF
import React from 'react'
import { BrowserRouter } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <h1>$PROJECT_NAME</h1>
        <p>全栈应用已成功创建！</p>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

cd ..

# 创建后端应用
echo "🔧 创建后端应用..."
mkdir -p backend/src/{controllers,services,models,middleware,routes,utils,types}

cd backend

# 后端package.json
cat > package.json << EOF
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "dotenv": "^16.0.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/bcryptjs": "^2.4.2",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/node": "^18.14.0",
    "typescript": "^4.9.5",
    "nodemon": "^2.0.20",
    "tsx": "^3.12.0"
  }
}
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# 环境变量模板
cat > .env.example << EOF
NODE_ENV=development
PORT=8000
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=http://localhost:3000
EOF

# 入口文件
cat > src/index.ts << EOF
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import dotenv from 'dotenv'

// 加载环境变量
dotenv.config()

const app = express()
const port = process.env.PORT || 8000

// 中间件
app.use(helmet())
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}))
app.use(express.json())

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'API is running' })
})

// 启动服务器
app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`)
})
EOF

# 基础路由
cat > src/routes/index.ts << EOF
import { Router } from 'express'

const router = Router()

// API路由
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'API is working' })
})

export default router
EOF

cd ..

# 安装根依赖
echo "📦 安装根依赖..."
npm install

echo "✅ 全栈项目创建完成！"
echo ""
echo "📁 项目结构:"
echo "  $PROJECT_NAME/"
echo "  ├── frontend/          # React前端应用"
echo "  ├── backend/           # Node.js后端API"
echo "  └── docker/            # Docker配置"
echo ""
echo "🚀 快速开始:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm run install:all  # 安装所有依赖"
echo "  3. npm run dev          # 启动开发服务器"
echo ""
echo "📖 文档:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端API: http://localhost:8000/api/health"
echo ""
echo "🔧 开发命令:"
echo "  - 前端开发: cd frontend && npm run dev"
echo "  - 后端开发: cd backend && npm run dev"
echo "  - 构建项目: npm run build"
echo "  - 运行测试: npm test""# 快速创建全栈项目的脚本
# 使用示例: ./quick-setup.sh my-app react express postgresql

set -e

PROJECT_NAME="${1:-my-fullstack-app}"
FRONTEND_FRAMEWORK="${2:-react}"
BACKEND_FRAMEWORK="${3:-express}"
DATABASE="${4:-postgresql}"

echo "🚀 开始创建全栈项目: $PROJECT_NAME"
echo "📋 配置: 前端=$FRONTEND_FRAMEWORK, 后端=$BACKEND_FRAMEWORK, 数据库=$DATABASE"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建README
cat > README.md << EOF
# $PROJECT_NAME

全栈Web应用程序

## 技术栈
- 前端: $FRONTEND_FRAMEWORK + TypeScript
- 后端: $BACKEND_FRAMEWORK + TypeScript
- 数据库: $DATABASE

## 快速开始

\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

## 开发

### 前端开发
cd frontend && npm run dev

### 后端开发
cd backend && npm run dev
EOF

# 创建根目录package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Full-stack web application",
  "private": true,
  "scripts": {
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build"
  },
  "devDependencies": {
    "concurrently": "^7.6.0"
  }
}
EOF

# 创建前端应用
echo "⚛️  创建前端应用..."
mkdir -p frontend/src/{components,pages,hooks,services,store,types,utils,styles}

cd frontend

# 前端package.json
cat > package.json << EOF
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "zustand": "^4.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "typescript": "^4.9.0"
  }
}
EOF

# Vite配置
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > tsconfig.node.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# 入口文件
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# React入口文件
cat > src/main.tsx << EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# App组件
cat > src/App.tsx << EOF
import React from 'react'
import { BrowserRouter } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <h1>$PROJECT_NAME</h1>
        <p>全栈应用已成功创建！</p>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

cd ..

# 创建后端应用
echo "🔧 创建后端应用..."
mkdir -p backend/src/{controllers,services,models,middleware,routes,utils,types}

cd backend

# 后端package.json
cat > package.json << EOF
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "dotenv": "^16.0.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/bcryptjs": "^2.4.2",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/node": "^18.14.0",
    "typescript": "^4.9.5",
    "nodemon": "^2.0.20",
    "tsx": "^3.12.0"
  }
}
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# 环境变量模板
cat > .env.example << EOF
NODE_ENV=development
PORT=8000
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=http://localhost:3000
EOF

# 入口文件
cat > src/index.ts << EOF
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import dotenv from 'dotenv'

// 加载环境变量
dotenv.config()

const app = express()
const port = process.env.PORT || 8000

// 中间件
app.use(helmet())
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}))
app.use(express.json())

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'API is running' })
})

// 启动服务器
app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`)
})
EOF

# 基础路由
cat > src/routes/index.ts << EOF
import { Router } from 'express'

const router = Router()

// API路由
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'API is working' })
})

export default router
EOF

cd ..

# 安装根依赖
echo "📦 安装根依赖..."
npm install

echo "✅ 全栈项目创建完成！"
echo ""
echo "📁 项目结构:"
echo "  $PROJECT_NAME/"
echo "  ├── frontend/          # React前端应用"
echo "  ├── backend/           # Node.js后端API"
echo "  └── docker/            # Docker配置"
echo ""
echo "🚀 快速开始:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm run install:all  # 安装所有依赖"
echo "  3. npm run dev          # 启动开发服务器"
echo ""
echo "📖 文档:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端API: http://localhost:8000/api/health"
echo ""
echo "🔧 开发命令:"
echo "  - 前端开发: cd frontend && npm run dev"
echo "  - 后端开发: cd backend && npm run dev"
echo "  - 构建项目: npm run build"
echo "  - 运行测试: npm test""# 快速创建全栈项目的脚本
# 使用示例: ./quick-setup.sh my-app react express postgresql

set -e

PROJECT_NAME="${1:-my-fullstack-app}"
FRONTEND_FRAMEWORK="${2:-react}"
BACKEND_FRAMEWORK="${3:-express}"
DATABASE="${4:-postgresql}"

echo "🚀 开始创建全栈项目: $PROJECT_NAME"
echo "📋 配置: 前端=$FRONTEND_FRAMEWORK, 后端=$BACKEND_FRAMEWORK, 数据库=$DATABASE"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建README
cat > README.md << EOF
# $PROJECT_NAME

全栈Web应用程序

## 技术栈
- 前端: $FRONTEND_FRAMEWORK + TypeScript
- 后端: $BACKEND_FRAMEWORK + TypeScript
- 数据库: $DATABASE

## 快速开始

\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

## 开发

### 前端开发
cd frontend && npm run dev

### 后端开发
cd backend && npm run dev
EOF

# 创建根目录package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Full-stack web application",
  "private": true,
  "scripts": {
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build"
  },
  "devDependencies": {
    "concurrently": "^7.6.0"
  }
}
EOF

# 创建前端应用
echo "⚛️  创建前端应用..."
mkdir -p frontend/src/{components,pages,hooks,services,store,types,utils,styles}

cd frontend

# 前端package.json
cat > package.json << EOF
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "zustand": "^4.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "typescript": "^4.9.0"
  }
}
EOF

# Vite配置
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > tsconfig.node.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# 入口文件
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# React入口文件
cat > src/main.tsx << EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# App组件
cat > src/App.tsx << EOF
import React from 'react'
import { BrowserRouter } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <h1>$PROJECT_NAME</h1>
        <p>全栈应用已成功创建！</p>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

cd ..

# 创建后端应用
echo "🔧 创建后端应用..."
mkdir -p backend/src/{controllers,services,models,middleware,routes,utils,types}

cd backend

# 后端package.json
cat > package.json << EOF
{
  "name": "backend",
  "version": "1.0.0",
  "description": "Backend API",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^6.0.1",
    "dotenv": "^16.0.3",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/cors": "^2.8.13",
    "@types/bcryptjs": "^2.4.2",
    "@types/jsonwebtoken": "^9.0.1",
    "@types/node": "^18.14.0",
    "typescript": "^4.9.5",
    "nodemon": "^2.0.20",
    "tsx": "^3.12.0"
  }
}
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

# 环境变量模板
cat > .env.example << EOF
NODE_ENV=development
PORT=8000
JWT_SECRET=your-super-secret-jwt-key
CORS_ORIGIN=http://localhost:3000
EOF

# 入口文件
cat > src/index.ts << EOF
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import dotenv from 'dotenv'

// 加载环境变量
dotenv.config()

const app = express()
const port = process.env.PORT || 8000

// 中间件
app.use(helmet())
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}))
app.use(express.json())

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'API is running' })
})

// 启动服务器
app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`)
})
EOF

# 基础路由
cat > src/routes/index.ts << EOF
import { Router } from 'express'

const router = Router()

// API路由
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'API is working' })
})

export default router
EOF

cd ..

# 安装根依赖
echo "📦 安装根依赖..."
npm install

echo "✅ 全栈项目创建完成！"
echo ""
echo "📁 项目结构:"
echo "  $PROJECT_NAME/"
echo "  ├── frontend/          # React前端应用"
echo "  ├── backend/           # Node.js后端API"
echo "  └── docker/            # Docker配置"
echo ""
echo "🚀 快速开始:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm run install:all  # 安装所有依赖"
echo "  3. npm run dev          # 启动开发服务器"
echo ""
echo "📖 文档:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端API: http://localhost:8000/api/health"
echo ""
echo "🔧 开发命令:"
echo "  - 前端开发: cd frontend && npm run dev"
echo "  - 后端开发: cd backend && npm run dev"
echo "  - 构建项目: npm run build"
echo "  - 运行测试: npm test""# 快速创建全栈项目的脚本
# 使用示例: ./quick-setup.sh my-app react express postgresql

set -e

PROJECT_NAME="${1:-my-fullstack-app}"
FRONTEND_FRAMEWORK="${2:-react}"
BACKEND_FRAMEWORK="${3:-express}"
DATABASE="${4:-postgresql}"

echo "🚀 开始创建全栈项目: $PROJECT_NAME"
echo "📋 配置: 前端=$FRONTEND_FRAMEWORK, 后端=$BACKEND_FRAMEWORK, 数据库=$DATABASE"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 创建README
cat > README.md << EOF
# $PROJECT_NAME

全栈Web应用程序

## 技术栈
- 前端: $FRONTEND_FRAMEWORK + TypeScript
- 后端: $BACKEND_FRAMEWORK + TypeScript
- 数据库: $DATABASE

## 快速开始

\`\`\`bash
# 安装依赖
npm run install:all

# 启动开发服务器
npm run dev
\`\`\`

## 开发

### 前端开发
cd frontend && npm run dev

### 后端开发
cd backend && npm run dev
EOF

# 创建根目录package.json
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Full-stack web application",
  "private": true,
  "scripts": {
    "install:all": "npm install && cd frontend && npm install && cd ../backend && npm install",
    "dev": "concurrently \"npm run dev:frontend\" \"npm run dev:backend\"",
    "dev:frontend": "cd frontend && npm run dev",
    "dev:backend": "cd backend && npm run dev",
    "build": "npm run build:frontend && npm run build:backend",
    "build:frontend": "cd frontend && npm run build",
    "build:backend": "cd backend && npm run build"
  },
  "devDependencies": {
    "concurrently": "^7.6.0"
  }
}
EOF

# 创建前端应用
echo "⚛️  创建前端应用..."
mkdir -p frontend/src/{components,pages,hooks,services,store,types,utils,styles}

cd frontend

# 前端package.json
cat > package.json << EOF
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "axios": "^1.3.0",
    "zustand": "^4.3.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "@vitejs/plugin-react": "^3.1.0",
    "vite": "^4.1.0",
    "typescript": "^4.9.0"
  }
}
EOF

# Vite配置
cat > vite.config.ts << EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
EOF

# TypeScript配置
cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ES6"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

cat > tsconfig.node.json << EOF
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts"]
}
EOF

# 入口文件
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$PROJECT_NAME</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

# React入口文件
cat > src/main.tsx << EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# App组件
cat > src/App.tsx << EOF
import React from 'react'
import { BrowserRouter } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <div className="App">
        <h1>$PROJECT_NAME</h1>
        <p>全栈应用已成功创建！</p>
      </div>
    </BrowserRouter>
  )
}

export default App
EOF

cd ..

# 安装根依赖
echo "📦 安装根依赖..."
npm install

echo "✅ 全栈项目创建完成！"
echo ""
echo "📁 项目结构:"
echo "  $PROJECT_NAME/"
echo "  ├── frontend/          # React前端应用"
echo "  ├── backend/           # Node.js后端API"
echo "  └── docker/            # Docker配置"
echo ""
echo "🚀 快速开始:"
echo "  1. cd $PROJECT_NAME"
echo "  2. npm run install:all  # 安装所有依赖"
echo "  3. npm run dev          # 启动开发服务器"
echo ""
echo "📖 文档:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端API: http://localhost:8000/api/health"
echo ""
echo "🔧 开发命令:"
echo "  - 前端开发: cd frontend && npm run dev"
echo "  - 后端开发: cd backend && npm run dev"
echo "  - 构建项目: npm run build"
echo "  - 运行测试: npm test"