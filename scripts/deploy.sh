#!/bin/bash

# 互动目标展示系统部署脚本
# 使用方法: ./scripts/deploy.sh [development|production]

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查系统环境
check_system() {
    log_info "检查系统环境..."

    # 检查Node.js
    if ! command -v node &> /dev/null; then
        log_error "Node.js未安装，请先安装Node.js (v14+)"
        exit 1
    fi

    NODE_VERSION=$(node --version | cut -d'v' -f2)
    log_info "Node.js版本: v$NODE_VERSION"

    # 检查npm
    if ! command -v npm &> /dev/null; then
        log_error "npm未安装"
        exit 1
    fi

    # 检查端口是否被占用
    PORT=${PORT:-3000}
    if lsof -i :$PORT &> /dev/null; then
        log_warning "端口$PORT已被占用"
        read -p "是否终止占用进程？(y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
            log_success "已终止占用进程"
        else
            log_error "请更改端口配置或停止占用进程"
            exit 1
        fi
    fi

    log_success "系统环境检查完成"
}

# 安装依赖
install_dependencies() {
    log_info "安装项目依赖..."

    if [ ! -d "node_modules" ]; then
        npm install
    else
        log_info "依赖已存在，跳过安装"
    fi

    log_success "依赖安装完成"
}

# 环境配置
setup_environment() {
    log_info "配置环境变量..."

    ENV=${1:-development}

    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            log_info "已从.env.example创建.env文件"
        else
            cat > .env << EOF
PORT=3000
NODE_ENV=$ENV
DOMAIN=${ENV:-development}="localhost"
EOF
        fi

        if [ "$ENV" = "production" ]; then
            sed -i "s/localhost/meet.seasoul.top/" .env
        fi

        log_warning "请编辑.env文件配置正确的环境变量"
    else
        log_info "环境配置文件已存在"
    fi

    log_success "环境配置完成"
}

# 构建应用
build_app() {
    log_info "构建应用..."

    # 这里可以添加构建步骤，如TypeScript编译等
    # npm run build

    log_success "应用构建完成"
}

# 启动应用
start_app() {
    log_info "启动应用..."

    ENV=${1:-development}

    if [ "$ENV" = "production" ]; then
        # 生产环境使用PM2管理
        if command -v pm2 &> /dev/null; then
            pm2 start app.js --name "meeting-system"
            pm2 save
            log_success "应用已通过PM2启动"
        else
            log_warning "PM2未安装，使用直接启动方式"
            nohup node app.js > logs/app.log 2>&1 &
            echo $! > app.pid
            log_success "应用已启动，PID: $(cat app.pid)"
        fi
    else
        # 开发环境直接启动
        npm start
    fi
}

# 健康检查
health_check() {
    log_info "执行健康检查..."

    PORT=${PORT:-3000}
    MAX_RETRIES=10
    RETRY_COUNT=0

    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        if curl -f http://localhost:$PORT/api/stats &> /dev/null; then
            log_success "应用启动成功，健康检查通过"
            return 0
        fi

        RETRY_COUNT=$((RETRY_COUNT + 1))
        log_info "等待应用启动... ($RETRY_COUNT/$MAX_RETRIES)"
        sleep 3
    done

    log_error "健康检查失败，应用可能未正常启动"
    return 1
}

# 创建日志目录
setup_logs() {
    mkdir -p logs
    log_info "日志目录已创建"
}

# 主函数
main() {
    echo "======================================"
    echo "  互动目标展示系统部署脚本"
    echo "======================================"
    echo

    ENV=${1:-development}
    log_info "部署环境: $ENV"

    # 检查是否在项目根目录
    if [ ! -f "package.json" ]; then
        log_error "请在项目根目录运行此脚本"
        exit 1
    fi

    # 执行部署步骤
    check_system
    setup_logs
    setup_environment $ENV
    install_dependencies
    build_app

    if [ "$ENV" != "development" ]; then
        start_app $ENV
        health_check

        echo
        log_success "部署完成！"
        echo
        log_info "访问地址:"
        log_info "  大屏展示: http://localhost:$PORT/"
        log_info "  数据收集: http://localhost:$PORT/submit"
        log_info "  管理后台: http://localhost:$PORT/admin"
        echo
        log_info "查看日志: tail -f logs/app.log"
        if [ -f "app.pid" ]; then
            log_info "停止服务: kill \$(cat app.pid)"
        fi
    else
        start_app $ENV
    fi
}

# 帮助信息
show_help() {
    echo "使用方法:"
    echo "  $0 [development|production]"
    echo ""
    echo "说明:"
    echo "  development  - 开发环境部署（默认）"
    echo "  production   - 生产环境部署"
    echo ""
    echo "环境变量:"
    echo "  PORT          - 服务端口（默认: 3000）"
    echo "  NODE_ENV      - 运行环境"
    echo "  DOMAIN        - 服务域名"
    echo ""
    echo "示例:"
    echo "  $0 development"
    echo "  $0 production"
    echo "  PORT=8080 $0 production"
}

# 解析命令行参数
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac