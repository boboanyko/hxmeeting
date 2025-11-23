class AdminPanel {
    constructor() {
        this.participants = [];
        this.stats = {};
        this.logs = [];
        this.refreshInterval = null;

        this.init();
    }

    init() {
        this.bindEvents();
        this.startAutoRefresh();
        this.loadInitialData();
        this.startClock();
    }

    bindEvents() {
        // 页面关闭时清理定时器
        window.addEventListener('beforeunload', () => {
            this.stopAutoRefresh();
        });

        // 事件委托处理按钮点击
        document.body.addEventListener('click', (e) => {
            const action = e.target.getAttribute('data-action');

            // 处理action事件
            switch (action) {
                case 'clear-all-data':
                    e.preventDefault();
                    this.clearAllData();
                    break;
                case 'export-data':
                    e.preventDefault();
                    this.exportData();
                    break;
                case 'refresh-stats':
                    e.preventDefault();
                    this.refreshStats();
                    break;
                case 'show-participants':
                    e.preventDefault();
                    this.showParticipants();
                    break;
                case 'hide-participants':
                    e.preventDefault();
                    this.hideParticipants();
                    break;
                case 'clear-logs':
                    e.preventDefault();
                    this.clearLogs();
                    break;
                case 'close-modal':
                    e.preventDefault();
                    this.closeModal();
                    break;
            }
        });

        // 键盘快捷键
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey || e.metaKey) {
                switch (e.key) {
                    case 'r':
                        e.preventDefault();
                        this.refreshStats();
                        break;
                    case 'e':
                        e.preventDefault();
                        this.exportData();
                        break;
                }
            }

            // ESC键关闭模态框和参与者列表
            if (e.key === 'Escape') {
                this.closeModal();
                this.hideParticipants();
            }
        });
    }

    startAutoRefresh() {
        this.refreshInterval = setInterval(() => {
            this.loadStats();
        }, 30000); // 每30秒刷新一次
    }

    stopAutoRefresh() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
            this.refreshInterval = null;
        }
    }

    async loadInitialData() {
        await Promise.all([
            this.loadStats(),
            this.loadParticipants(),
            this.addLog('info', '管理面板初始化完成')
        ]);
    }

    async loadStats() {
        try {
            const response = await fetch('/api/stats');
            const result = await response.json();

            if (result.success) {
                this.stats = result.data;
                this.updateStatsDisplay();
                this.updateServerStatus(true);
                this.addLog('info', '统计数据更新成功');
            } else {
                throw new Error(result.message || '获取统计失败');
            }
        } catch (error) {
            console.error('加载统计数据失败:', error);
            this.updateServerStatus(false);
            this.addLog('error', `统计数据加载失败: ${error.message}`);
        }
    }

    async loadParticipants() {
        try {
            const response = await fetch('/api/participants');
            const result = await response.json();

            if (result.success) {
                this.participants = result.data.participants || [];
                this.updateParticipantsTable();
            } else {
                throw new Error(result.message || '获取参与者列表失败');
            }
        } catch (error) {
            console.error('加载参与者列表失败:', error);
            this.addLog('error', `参与者列表加载失败: ${error.message}`);
        }
    }

    updateStatsDisplay() {
        // 更新参与人数
        const participantCount = document.getElementById('participantCount');
        if (participantCount) {
            participantCount.textContent = this.stats.total || 0;
        }

        // 更新WebSocket连接数
        const wsConnections = document.getElementById('wsConnections');
        if (wsConnections) {
            wsConnections.textContent = this.stats.wsConnections || 0;
        }

        // 更新内存使用
        const memoryUsage = document.getElementById('memoryUsage');
        if (memoryUsage && this.stats.memoryUsage) {
            const memoryMB = Math.round(this.stats.memoryUsage.heapUsed / 1024 / 1024);
            const totalMB = Math.round(this.stats.memoryUsage.heapTotal / 1024 / 1024);
            memoryUsage.textContent = `${memoryMB}MB`;
            memoryUsage.title = `总计: ${totalMB}MB`;
        }

        // 更新运行时间
        const uptime = document.getElementById('uptime');
        if (uptime && this.stats.uptime) {
            uptime.textContent = this.formatUptime(this.stats.uptime);
        }
    }

    updateServerStatus(isOnline) {
        const statusIndicator = document.getElementById('serverStatus');
        const statusDot = statusIndicator?.querySelector('.status-dot');
        const statusText = statusIndicator?.querySelector('.status-text');

        if (!statusIndicator) return;

        if (isOnline) {
            statusDot?.classList.add('online');
            statusDot?.classList.remove('offline');
            statusText.textContent = '在线';
        } else {
            statusDot?.classList.remove('online');
            statusDot?.classList.add('offline');
            statusText.textContent = '离线';
        }
    }

    updateParticipantsTable() {
        const tbody = document.getElementById('participantsTableBody');
        if (!tbody) return;

        if (this.participants.length === 0) {
            tbody.innerHTML = `
                <tr class="empty">
                    <td colspan="5">暂无参与者数据</td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.participants.map((participant, index) => `
            <tr>
                <td>${this.getRankIcon(index + 1)} ${index + 1}</td>
                <td>${this.escapeHtml(participant.name)}</td>
                <td>${this.escapeHtml(participant.organization)}</td>
                <td><strong>${this.formatTarget(participant.target)}</strong></td>
                <td>${this.formatTime(participant.timestamp)}</td>
            </tr>
        `).join('');
    }

    getRankIcon(rank) {
        switch (rank) {
            case 1: return '👑';
            case 2: return '🥈';
            case 3: return '🥉';
            default: return '';
        }
    }

    formatTarget(target) {
        return `¥${Number(target).toLocaleString('zh-CN', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        })}`;
    }

    formatTime(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    }

    formatUptime(seconds) {
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const secs = Math.floor(seconds % 60);

        if (hours > 24) {
            const days = Math.floor(hours / 24);
            const remainingHours = hours % 24;
            return `${days}天${remainingHours}时${minutes}分`;
        }

        return `${hours}时${minutes}分${secs}秒`;
    }

    // 管理操作方法
    async refreshStats() {
        this.showLoading(true);
        await this.loadInitialData();
        this.showLoading(false);
        this.showNotification('数据刷新成功', 'success');
    }

    async clearAllData() {
        const confirmed = await this.showConfirmModal(
            '清空所有数据',
            '确定要清空所有参与者数据吗？此操作不可恢复！'
        );

        if (!confirmed) return;

        this.showLoading(true);

        try {
            const response = await fetch('/api/participants', {
                method: 'DELETE'
            });

            const result = await response.json();

            if (result.success) {
                await this.loadInitialData();
                this.showNotification(`成功清空 ${result.data.clearedCount} 条数据`, 'success');
                this.addLog('warn', `管理员清空了 ${result.data.clearedCount} 条参与者数据`);
            } else {
                throw new Error(result.message || '清空失败');
            }
        } catch (error) {
            console.error('清空数据失败:', error);
            this.showNotification(`清空失败: ${error.message}`, 'error');
            this.addLog('error', `清空数据失败: ${error.message}`);
        } finally {
            this.showLoading(false);
        }
    }

    exportData() {
        if (this.participants.length === 0) {
            this.showNotification('暂无数据可导出', 'warning');
            return;
        }

        // 创建CSV内容
        const headers = ['排名', '姓名', '机构', '目标金额', '提交时间'];
        const rows = this.participants.map((p, index) => [
            index + 1,
            p.name,
            p.organization,
            p.target,
            this.formatTime(p.timestamp)
        ]);

        let csvContent = '\ufeff' + headers.join(',') + '\n';
        rows.forEach(row => {
            csvContent += row.map(cell => `"${cell}"`).join(',') + '\n';
        });

        // 创建下载链接
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const url = URL.createObjectURL(blob);

        link.setAttribute('href', url);
        link.setAttribute('download', `参与者数据_${new Date().toISOString().slice(0, 10)}.csv`);
        link.style.visibility = 'hidden';

        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        this.showNotification(`成功导出 ${this.participants.length} 条数据`, 'success');
        this.addLog('info', `管理员导出了 ${this.participants.length} 条参与者数据`);
    }

    showParticipants() {
        const section = document.getElementById('participantsSection');
        if (section) {
            section.style.display = 'block';
            section.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    hideParticipants() {
        const section = document.getElementById('participantsSection');
        if (section) {
            section.style.display = 'none';
        }
    }

    // 日志管理
    addLog(level, message) {
        const timestamp = new Date().toISOString().slice(0, 19).replace('T', ' ');
        const logEntry = { timestamp, level, message };

        this.logs.unshift(logEntry);
        if (this.logs.length > 100) {
            this.logs = this.logs.slice(0, 100);
        }

        this.updateLogsDisplay();
    }

    updateLogsDisplay() {
        const logsContent = document.getElementById('logsContent');
        if (!logsContent) return;

        const currentFilter = document.getElementById('logLevel')?.value || 'all';
        const filteredLogs = currentFilter === 'all'
            ? this.logs
            : this.logs.filter(log => log.level === currentFilter);

        logsContent.innerHTML = filteredLogs.map(log => `
            <div class="log-entry ${log.level}">
                <span class="timestamp">${log.timestamp}</span>
                <span class="level">${log.level.toUpperCase()}</span>
                <span class="message">${this.escapeHtml(log.message)}</span>
            </div>
        `).join('');
    }

    clearLogs() {
        this.logs = [];
        this.updateLogsDisplay();
        this.showNotification('日志已清空', 'success');
    }

    filterLogs() {
        this.updateLogsDisplay();
    }

    // UI辅助方法
    showLoading(show) {
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay) {
            if (show) {
                loadingOverlay.classList.add('show');
            } else {
                loadingOverlay.classList.remove('show');
            }
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

    async showConfirmModal(title, message) {
        return new Promise((resolve) => {
            const modal = document.getElementById('modalOverlay');
            const modalTitle = document.getElementById('modalTitle');
            const modalMessage = document.getElementById('modalMessage');
            const confirmBtn = document.getElementById('modalConfirm');

            modalTitle.textContent = title;
            modalMessage.textContent = message;

            modal.classList.add('show');

            const handleConfirm = () => {
                modal.classList.remove('show');
                confirmBtn.removeEventListener('click', handleConfirm);
                resolve(true);
            };

            const handleCancel = () => {
                modal.classList.remove('show');
                confirmBtn.removeEventListener('click', handleConfirm);
                resolve(false);
            };

            confirmBtn.addEventListener('click', handleConfirm);
            document.querySelector('.modal-btn.cancel').addEventListener('click', handleCancel);
        });
    }

    startClock() {
        const updateTime = () => {
            const timeElement = document.getElementById('currentTime');
            if (timeElement) {
                timeElement.textContent = new Date().toLocaleString('zh-CN');
            }
        };

        updateTime();
        setInterval(updateTime, 1000);
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// 全局函数已通过事件委托处理，无需定义全局函数

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', () => {
    window.adminPanel = new AdminPanel();

    // 页面加载动画
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 0.5s ease';
        document.body.style.opacity = '1';
    }, 100);
});

// 错误处理
window.addEventListener('error', (event) => {
    console.error('页面错误:', event.error);
    if (window.adminPanel) {
        window.adminPanel.addLog('error', `页面错误: ${event.error.message}`);
    }
});

window.addEventListener('unhandledrejection', (event) => {
    console.error('未处理的Promise拒绝:', event.reason);
    if (window.adminPanel) {
        window.adminPanel.addLog('error', `Promise错误: ${event.reason}`);
    }
});

// ESC键关闭模态框
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        closeModal();
        hideParticipants();
    }
});