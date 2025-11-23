class SubmitForm {
    constructor() {
        this.currentStep = 1;
        this.formData = {};
        this.isSubmitting = false;

        this.init();
    }

    init() {
        this.bindEvents();
        this.loadStats();
        this.updateProgressIndicator();
    }

    bindEvents() {
        // 表单提交
        const submitForm = document.getElementById('submitForm');
        if (submitForm) {
            submitForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.handleSubmit();
            });
        }

        // 事件委托处理按钮点击
        const self = this; // 保存this引用
        document.body.addEventListener('click', (e) => {
            const action = e.target.getAttribute('data-action');
            const target = e.target.getAttribute('data-target');

            // 处理action事件
            switch (action) {
                case 'next-step':
                    e.preventDefault();
                    self.nextStep();
                    break;
                case 'prev-step':
                    e.preventDefault();
                    self.prevStep();
                    break;
                case 'reset-form':
                    e.preventDefault();
                    self.reset();
                    break;
            }

        });

        // 输入框实时验证
        const inputs = submitForm.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', () => {
                this.validateField(input);
            });

            input.addEventListener('blur', () => {
                this.validateField(input);
            });
        });

        // 复选框状态变化
        const confirmCheckbox = document.getElementById('confirmCheckbox');
        if (confirmCheckbox) {
            confirmCheckbox.addEventListener('change', () => {
                this.updateSubmitButton();
            });
        }

        // 键盘事件
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.handleEnterKey();
            }
        });
    }

    validateField(input) {
        const fieldName = input.name;
        const value = input.value.trim();
        const errorElement = document.getElementById(`${fieldName}Error`);

        let errorMessage = '';

        switch (fieldName) {
            case 'organization':
                if (!value) {
                    errorMessage = '机构名称不能为空';
                } else if (value.length > 50) {
                    errorMessage = '机构名称不能超过50个字符';
                }
                break;

            case 'name':
                if (!value) {
                    errorMessage = '姓名不能为空';
                } else if (value.length > 20) {
                    errorMessage = '姓名不能超过20个字符';
                }
                break;

            case 'target':
                const numValue = parseFloat(value);
                if (!value || isNaN(numValue)) {
                    errorMessage = '目标金额必须是数字';
                } else if (numValue <= 0) {
                    errorMessage = '目标金额必须大于0';
                } else if (numValue > 999999.99) {
                    errorMessage = '目标金额不能超过999,999.99万元';
                }
                break;
        }

        if (errorElement) {
            if (errorMessage) {
                errorElement.textContent = errorMessage;
                errorElement.classList.add('show');
                input.style.borderColor = '#dc3545';
                return false;
            } else {
                errorElement.textContent = '';
                errorElement.classList.remove('show');
                input.style.borderColor = '#e1e5e9';
                return true;
            }
        }

        return !errorMessage;
    }

    validateCurrentStep() {
        const currentFormStep = document.querySelector(`.form-step[data-step="${this.currentStep}"]`);
        const inputs = currentFormStep.querySelectorAll('input[required]');

        let isValid = true;
        inputs.forEach(input => {
            if (!this.validateField(input)) {
                isValid = false;
            }
        });

        return isValid;
    }

    updateProgressIndicator() {
        const steps = document.querySelectorAll('.step');
        const stepLines = document.querySelectorAll('.step-line');

        steps.forEach((step, index) => {
            const stepNumber = index + 1;
            step.classList.remove('active', 'completed');

            if (stepNumber === this.currentStep) {
                step.classList.add('active');
            } else if (stepNumber < this.currentStep) {
                step.classList.add('completed');
            }
        });

        stepLines.forEach((line, index) => {
            line.classList.remove('completed');
            if (index + 1 < this.currentStep) {
                line.classList.add('completed');
            }
        });
    }

    showStep(stepNumber) {
        // 隐藏所有步骤
        document.querySelectorAll('.form-step').forEach(step => {
            step.classList.remove('active');
        });

        // 显示目标步骤
        const targetStep = document.querySelector(`.form-step[data-step="${stepNumber}"]`);
        if (targetStep) {
            targetStep.classList.add('active');

            // 如果是第3步，更新确认信息
            if (stepNumber === 3) {
                this.updateSummary();
            }
        }

        this.currentStep = stepNumber;
        this.updateProgressIndicator();

        // 滚动到顶部
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    updateSummary() {
        const org = document.getElementById('organization').value.trim();
        const name = document.getElementById('name').value.trim();
        const target = parseFloat(document.getElementById('target').value);

        document.getElementById('summaryOrg').textContent = org || '--';
        document.getElementById('summaryName').textContent = name || '--';
        document.getElementById('summaryTarget').textContent = target ? this.formatTarget(target) : '--';
    }

    nextStep() {
        if (this.validateCurrentStep()) {
            if (this.currentStep < 3) {
                this.showStep(this.currentStep + 1);
            }
        } else {
            this.showNotification('请检查并填写所有必填项', 'error');
        }
    }

    prevStep() {
        if (this.currentStep > 1) {
            this.showStep(this.currentStep - 1);
        }
    }

    handleEnterKey() {
        const activeElement = document.activeElement;
        if (activeElement && activeElement.type === 'text') {
            return; // 让输入框正常使用Enter
        }

        if (this.currentStep < 3) {
            this.nextStep();
        } else {
            this.handleSubmit();
        }
    }

    updateSubmitButton() {
        const confirmCheckbox = document.getElementById('confirmCheckbox');
        const submitBtn = document.getElementById('submitBtn');

        if (submitBtn && confirmCheckbox) {
            submitBtn.disabled = !confirmCheckbox.checked;
        }
    }

    async handleSubmit() {
        if (this.isSubmitting) {
            return;
        }

        // 验证所有步骤
        if (!this.validateAllSteps()) {
            this.showNotification('请检查并填写所有必填项', 'error');
            return;
        }

        // 检查确认复选框
        const confirmCheckbox = document.getElementById('confirmCheckbox');
        if (!confirmCheckbox || !confirmCheckbox.checked) {
            this.showNotification('请确认信息准确无误后再提交', 'warning');
            return;
        }

        this.isSubmitting = true;
        this.showLoading(true);

        try {
            // 收集表单数据
            this.formData = {
                organization: document.getElementById('organization').value.trim(),
                name: document.getElementById('name').value.trim(),
                target: parseFloat(document.getElementById('target').value)
            };

            const response = await fetch('/api/participant', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(this.formData)
            });

            const result = await response.json();

            if (result.success) {
                if (result.data.isDuplicate) {
                    // 检测到重复人员，显示确认对话框
                    this.showDuplicateConfirm(result.data.existingPerson);
                } else {
                    // 正常提交成功
                    this.showSubmitSuccess();
                    this.loadStats(); // 更新统计
                }
            } else {
                throw new Error(result.message || '提交失败');
            }
        } catch (error) {
            console.error('提交失败:', error);
            this.showNotification(error.message || '网络错误，请稍后重试', 'error');
        } finally {
            this.isSubmitting = false;
            this.showLoading(false);
        }
    }

    validateAllSteps() {
        const inputs = document.querySelectorAll('#submitForm input[required]');
        let isValid = true;

        inputs.forEach(input => {
            if (!this.validateField(input)) {
                isValid = false;
            }
        });

        return isValid;
    }

    showSubmitSuccess() {
        const formContainer = document.querySelector('.form-container');
        const form = document.getElementById('submitForm');
        const statusDiv = document.getElementById('submitStatus');

        if (form) form.style.display = 'none';
        if (statusDiv) {
            statusDiv.style.display = 'block';
            statusDiv.innerHTML = `
                <div class="status-icon">✅</div>
                <h3>提交成功！</h3>
                <p>您的信息已成功提交，请在现场大屏查看排行榜。</p>
                <p><strong>${this.formData.name}</strong>(${this.formData.organization}) - 目标: ${this.formatTarget(this.formData.target)}</p>
            `;
        }

        this.showNotification('🎉 提交成功！', 'success');
    }

    async loadStats() {
        try {
            const response = await fetch('/api/participants');
            const result = await response.json();

            if (result.success && result.data) {
                const countElement = document.getElementById('participantCount');
                if (countElement) {
                    countElement.textContent = `当前参与人数：${result.data.total}人`;
                }
            }
        } catch (error) {
            console.error('加载统计失败:', error);
            const countElement = document.getElementById('participantCount');
            if (countElement) {
                countElement.textContent = '当前参与人数：加载失败';
            }
        }
    }

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

    formatTarget(target) {
        return `¥${Number(target).toLocaleString('zh-CN', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        })}万元`;
    }

    // 重复确认相关函数
    showDuplicateConfirm(existingPerson) {
        console.log('显示重复确认对话框', existingPerson);

        const modal = document.getElementById('duplicateConfirmModal');
        const orgElement = document.getElementById('duplicateOrg');
        const nameElement = document.getElementById('duplicateName');
        const currentAmountElement = document.getElementById('currentAmount');
        const newAmountElement = document.getElementById('newAmount');

        if (!modal || !orgElement || !nameElement || !currentAmountElement || !newAmountElement) {
            console.error('重复确认对话框元素未找到');
            return;
        }

        // 填充数据
        orgElement.textContent = existingPerson.organization;
        nameElement.textContent = existingPerson.name;
        currentAmountElement.textContent = this.formatTarget(existingPerson.currentTarget);
        newAmountElement.textContent = this.formatTarget(existingPerson.newTarget);

        // 显示对话框
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden'; // 防止背景滚动

        // 保存重复人员信息供后续使用
        this.duplicatePersonId = existingPerson.id;
        this.duplicateNewTarget = existingPerson.newTarget;

        console.log('已保存重复信息 - ID:', this.duplicatePersonId, '新目标:', this.duplicateNewTarget);
    }

    hideDuplicateConfirm() {
        const modal = document.getElementById('duplicateConfirmModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = ''; // 恢复滚动
        }

        // 清理重复人员信息
        this.duplicatePersonId = null;
        this.duplicateNewTarget = null;
    }

    async confirmOverwrite() {
        console.log('确认覆盖函数被调用');
        console.log('重复人员ID:', this.duplicatePersonId);
        console.log('新目标金额:', this.duplicateNewTarget);

        if (!this.duplicatePersonId || !this.duplicateNewTarget) {
            console.error('重复确认信息丢失');
            this.showNotification('重复确认信息丢失，请重新提交', 'error');
            this.hideDuplicateConfirm();
            return;
        }

        this.showLoading(true);
        // this.hideDuplicateConfirm();

        try {
            const requestData = {
                personId: this.duplicatePersonId,
                newTarget: this.duplicateNewTarget
            };
            console.log('发送覆盖请求数据:', requestData);

            const response = await fetch('/api/participant/confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(requestData)
            });

            console.log('覆盖响应状态:', response.status);
            const result = await response.json();
            console.log('覆盖响应结果:', result);

            if (result.success) {
                // 更新formData用于显示成功信息
                this.formData = {
                    organization: result.data.participant.organization,
                    name: result.data.participant.name,
                    target: result.data.participant.target
                };
                this.showSubmitSuccess();
                this.loadStats(); // 更新统计
                this.showNotification('金额覆盖成功！', 'success');
                this.hideDuplicateConfirm();
            } else {
                console.error('覆盖失败 - 服务器返回错误:', result);
                throw new Error(result.message || '覆盖失败');
            }
        } catch (error) {
            console.error('覆盖失败:', error);
            this.showNotification(error.message || '网络错误，请稍后重试', 'error');
        } finally {
            this.isSubmitting = false;
            this.showLoading(false);
        }
    }

    reset() {
        this.currentStep = 1;
        this.formData = {};
        this.isSubmitting = false;

        // 重置表单
        const submitForm = document.getElementById('submitForm');
        if (submitForm) {
            submitForm.reset();
        }

        // 重置错误状态
        document.querySelectorAll('.error-message').forEach(error => {
            error.textContent = '';
            error.classList.remove('show');
        });

        document.querySelectorAll('input').forEach(input => {
            input.style.borderColor = '#e1e5e9';
        });

        // 显示第一个步骤
        this.showStep(1);

        // 切换显示
        const formContainer = document.querySelector('.form-container');
        const form = document.getElementById('submitForm');
        const statusDiv = document.getElementById('submitStatus');

        if (statusDiv) statusDiv.style.display = 'none';
        if (form) form.style.display = 'block';

        // 重新加载统计
        this.loadStats();
    }
}

// 全局函数已通过事件委托处理，无需定义全局函数

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', () => {
    // create instance first
    const app = new SubmitForm();
    window.submitForm = app;

    // page load animation (preserve existing behavior)
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 300ms';
        document.body.style.opacity = '1';
    }, 20);

    // Delegated click handlers that call methods on the instance (no 'self' usage)
    document.body.addEventListener('click', (e) => {
        const btn = e.target.closest('.preset-btn');
        if (btn) {
            // preset amount button
            const amount = btn.getAttribute('data-target');
            if (amount) app.setTarget(amount);
            return;
        }

        const actionEl = e.target.closest('[data-action]');
        if (actionEl) {
            e.preventDefault(); // 阻止任何默认行为
            e.stopPropagation(); // 阻止事件冒泡

            const action = actionEl.getAttribute('data-action');
            console.log('点击事件 - action:', action);
            if (action === 'next-step') return app.nextStep();
            if (action === 'prev-step') return app.prevStep();
            if (action === 'reset-form') return app.resetForm();
            if (action === 'close-duplicate-modal') return app.hideDuplicateConfirm();
            if (action === 'confirm-overwrite') {
                console.log('触发确认覆盖操作');
                return app.confirmOverwrite();
            }
        }
    });

    // other initialization that used to run after creation
    // e.g. load stats, bind form submit inside class, etc.
    if (typeof app.init === 'function') app.init();
});

// 错误处理
window.addEventListener('error', (event) => {
    console.error('页面错误:', event.error);
    console.error('错误堆栈:', event.error.stack);
});

window.addEventListener('unhandledrejection', (event) => {
    console.error('未处理的Promise拒绝:', event.reason);
});

// 页面离开提醒
// 页面离开提醒
window.addEventListener('beforeunload', (e) => {
    const form = document.getElementById('submitForm');
    if (form && form.checkValidity() && !form.reportValidity()) {
        e.preventDefault();
        e.returnValue = '您有未提交的信息，确定要离开吗？';
    }
});