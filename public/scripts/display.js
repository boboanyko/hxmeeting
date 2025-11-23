class DisplayManager {
    constructor() {
        this.ws = null;
        this.reconnectAttempts = 0;
        this.maxReconnectAttempts = 5;
        this.reconnectDelay = 3000;
        this.heartbeatInterval = null;
        this.participants = [];
        this.currentHighlight = null;

        this.init();
    }

    init() {
        this.hideLoading();
        this.setupWebSocket();
        this.startServerTime();
        this.bindEvents();
    }

    hideLoading() {
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay) {
            loadingOverlay.style.opacity = '0';
            setTimeout(() => {
                loadingOverlay.style.display = 'none';
            }, 300);
        }
    }

    setupWebSocket() {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = `${protocol}//${window.location.host}/ws`;

        try {
            this.ws = new WebSocket(wsUrl);
            this.bindWebSocketEvents();
            this.updateConnectionStatus('connecting');
            console.log(`正在连接WebSocket: ${wsUrl}`);
        } catch (error) {
            console.error('WebSocket连接失败:', error);
            this.updateConnectionStatus('disconnected');
            this.scheduleReconnect();
        }
    }

    bindWebSocketEvents() {
        this.ws.onopen = () => {
            console.log('WebSocket连接成功');
            this.updateConnectionStatus('connected');
            this.reconnectAttempts = 0;
            this.startHeartbeat();
            this.showNotification('连接成功', 'success');
        };

        this.ws.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                this.handleWebSocketMessage(data);
            } catch (error) {
                console.error('解析WebSocket消息失败:', error);
            }
        };

        this.ws.onclose = (event) => {
            console.log(`WebSocket连接关闭: ${event.code} - ${event.reason}`);
            this.updateConnectionStatus('disconnected');
            this.stopHeartbeat();

            if (this.reconnectAttempts < this.maxReconnectAttempts) {
                this.scheduleReconnect();
            } else {
                this.showNotification('连接失败，请刷新页面重试', 'error');
            }
        };

        this.ws.onerror = (error) => {
            console.error('WebSocket错误:', error);
            this.updateConnectionStatus('disconnected');
            this.showNotification('连接出现错误', 'error');
        };
    }

    handleWebSocketMessage(data) {
        switch (data.type) {
            case 'initial':
                this.handleInitialData(data);
                break;
            case 'update':
                this.handleDataUpdate(data);
                break;
            default:
                console.warn('未知消息类型:', data.type);
        }
    }

    handleInitialData(data) {
        this.participants = data.data || [];
        this.updateDisplay();
        this.showNotification(`已加载 ${this.participants.length} 条参与者数据`, 'success');
    }

    handleDataUpdate(data) {
        const oldParticipants = [...this.participants];
        this.participants = data.data || [];

        this.detectChanges(oldParticipants, this.participants);
        this.updateDisplay();
    }

    detectChanges(oldData, newData) {
        // 检测新增
        const newParticipants = newData.filter(item =>
            !oldData.some(oldItem => oldItem.id === item.id)
        );

        newParticipants.forEach(participant => {
            this.showNotification(`🎉 新参与者: ${participant.name} (${participant.organization})`, 'success');
        });

        // 检测排名变化
        const oldTop3 = oldData.slice(0, 3);
        const newTop3 = newData.slice(0, 3);

        if (JSON.stringify(oldTop3.map(p => p.id)) !== JSON.stringify(newTop3.map(p => p.id))) {
            this.highlightTop3();
        }
    }

    updateDisplay() {
        this.updateStats();
        this.updateTopThree();
        this.updateParticipantsTable();
        this.updateLastUpdateTime();
    }

    updateStats() {
        document.getElementById('totalCount').textContent = this.participants.length;
    }

    updateTopThree() {
        const top3 = this.participants.slice(0, 3);
        const positions = ['first', 'second', 'third'];
        const names = ['firstName', 'secondName', 'thirdName'];
        const orgs = ['firstOrg', 'secondOrg', 'thirdOrg'];
        const targets = ['firstTarget', 'secondTarget', 'thirdTarget'];

        positions.forEach((pos, index) => {
            const participant = top3[index];
            const nameEl = document.getElementById(names[index]);
            const orgEl = document.getElementById(orgs[index]);
            const targetEl = document.getElementById(targets[index]);

            if (participant) {
                nameEl.textContent = participant.name;
                orgEl.textContent = participant.organization;
                targetEl.textContent = this.formatTarget(participant.target);

                // 添加动画
                this.animateElement(nameEl.parentElement);
            } else {
                nameEl.textContent = '--';
                orgEl.textContent = '--';
                targetEl.textContent = '--';
            }
        });
    }

    updateParticipantsTable() {
        const tbody = document.getElementById('participantsTableBody');

        if (this.participants.length === 0) {
            tbody.innerHTML = `
                <tr class="empty-state">
                    <td colspan="5" class="empty-message">
                        暂无参与者数据，等待用户提交...
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.participants.map((participant, index) => `
            <tr class="${index < 3 ? 'highlight' : ''}" data-id="${participant.id}">
                <td>
                    ${index === 0 ? '👑' : index === 1 ? '🥈' : index === 2 ? '🥉' : index + 1}
                </td>
                <td>${this.escapeHtml(participant.name)}</td>
                <td>${this.escapeHtml(participant.organization)}</td>
                <td><strong>${this.formatTarget(participant.target)}</strong></td>
                <td>${this.formatTime(participant.timestamp)}</td>
            </tr>
        `).join('');

        // 添加行点击事件
        tbody.querySelectorAll('tr[data-id]').forEach(row => {
            row.addEventListener('click', () => {
                const id = parseInt(row.dataset.id);
                this.highlightRow(id);
            });
        });
    }

    highlightTop3() {
        const rows = document.querySelectorAll('.participants-table tbody tr[data-id]');
        rows.forEach((row, index) => {
            if (index < 3) {
                row.classList.add('highlight');
                setTimeout(() => {
                    row.classList.remove('highlight');
                }, 3000);
            }
        });
    }

    highlightRow(id) {
        // 清除之前的高亮
        document.querySelectorAll('.participants-table tbody tr').forEach(row => {
            row.classList.remove('highlight');
        });

        // 高亮当前行
        const targetRow = document.querySelector(`tr[data-id="${id}"]`);
        if (targetRow) {
            targetRow.classList.add('highlight');
            targetRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }

    animateElement(element) {
        element.style.animation = 'none';
        element.offsetHeight; // 触发重绘
        element.style.animation = 'slideIn 0.5s ease-out';
    }

    updateLastUpdateTime() {
        const now = new Date();
        document.getElementById('lastUpdate').textContent = this.formatTime(now.getTime());
    }

    updateConnectionStatus(status) {
        const statusEl = document.getElementById('connectionStatus');
        const statusText = {
            connected: '🟢 连接状态: 已连接',
            connecting: '🟡 连接状态: 连接中...',
            disconnected: '🔴 连接状态: 断开'
        };

        statusEl.textContent = statusText[status] || statusText.disconnected;
        statusEl.className = status;
    }

    startServerTime() {
        const updateServerTime = () => {
            const now = new Date();
            document.getElementById('serverTime').textContent =
                `服务器时间: ${now.toLocaleTimeString('zh-CN')}`;
        };

        updateServerTime();
        setInterval(updateServerTime, 1000);
    }

    startHeartbeat() {
        this.heartbeatInterval = setInterval(() => {
            if (this.ws && this.ws.readyState === WebSocket.OPEN) {
                this.ws.send(JSON.stringify({ type: 'heartbeat' }));
            }
        }, 30000);
    }

    stopHeartbeat() {
        if (this.heartbeatInterval) {
            clearInterval(this.heartbeatInterval);
            this.heartbeatInterval = null;
        }
    }

    scheduleReconnect() {
        this.reconnectAttempts++;

        if (this.reconnectAttempts <= this.maxReconnectAttempts) {
            const delay = this.reconnectDelay * Math.pow(2, this.reconnectAttempts - 1);
            console.log(`将在 ${delay}ms 后重试连接 (${this.reconnectAttempts}/${this.maxReconnectAttempts})`);

            setTimeout(() => {
                this.setupWebSocket();
            }, delay);
        }
    }

    manualRefresh() {
        this.showNotification('正在刷新数据...', 'info');

        if (this.ws && this.ws.readyState === WebSocket.OPEN) {
            this.ws.send(JSON.stringify({ type: 'refresh' }));
        } else {
            this.setupWebSocket();
        }
    }

    showNotification(message, type = 'info') {
        const notification = document.getElementById('notification');
        if (!notification) return;

        notification.textContent = message;
        notification.className = `notification ${type}`;
        notification.classList.add('show');

        setTimeout(() => {
            notification.classList.remove('show');
        }, 5000);
    }

    formatTarget(target) {
        return `¥${Number(target).toLocaleString('zh-CN', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        })}`;
    }

    formatTime(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleTimeString('zh-CN', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    bindEvents() {
        // 页面可见性变化时检查连接
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden && (!this.ws || this.ws.readyState !== WebSocket.OPEN)) {
                this.setupWebSocket();
            }
        });

        // 网络状态变化
        window.addEventListener('online', () => {
            this.showNotification('网络已连接', 'success');
            if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
                this.setupWebSocket();
            }
        });

        window.addEventListener('offline', () => {
            this.showNotification('网络已断开', 'error');
            this.updateConnectionStatus('disconnected');
        });

        // 全局刷新按钮
        const refreshBtn = document.querySelector('.refresh-btn');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => {
                this.manualRefresh();
            });
        }

        // 键盘快捷键
        document.addEventListener('keydown', (event) => {
            if (event.key === 'F5' || (event.ctrlKey && event.key === 'r')) {
                event.preventDefault();
                this.manualRefresh();
            }
        });
    }
}

// 全局函数
function manualRefresh() {
    if (window.displayManager) {
        window.displayManager.manualRefresh();
    }
}

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', () => {
    window.displayManager = new DisplayManager();

    // 添加页面加载动画
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 0.5s ease';
        document.body.style.opacity = '1';
    }, 100);
});

// 错误处理
window.addEventListener('error', (event) => {
    console.error('页面错误:', event.error);
});

window.addEventListener('unhandledrejection', (event) => {
    console.error('未处理的Promise拒绝:', event.reason);
});