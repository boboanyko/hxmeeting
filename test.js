// 简单的系统测试脚本
const http = require('http');

const options = {
    hostname: 'localhost',
    port: process.env.PORT || 3000,
    path: '/api/stats',
    method: 'GET',
    timeout: 5000
};

console.log('正在测试系统健康状态...');

const req = http.request(options, (res) => {
    console.log(`响应状态: ${res.statusCode}`);

    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });

    res.on('end', () => {
        try {
            const result = JSON.parse(data);
            if (result.success) {
                console.log('✅ 系统运行正常');
                console.log(`📊 参与人数: ${result.data.total}`);
                console.log(`📡 WebSocket连接: ${result.data.wsConnections}`);
                console.log(`💾 内存使用: ${Math.round(result.data.memoryUsage.heapUsed / 1024 / 1024)}MB`);
            } else {
                console.log('❌ API响应异常:', result.message);
            }
        } catch (error) {
            console.log('❌ 响应解析失败:', error.message);
        }
        process.exit(res.statusCode === 200 ? 0 : 1);
    });
});

req.on('error', (error) => {
    console.log('❌ 连接失败:', error.message);
    process.exit(1);
});

req.on('timeout', () => {
    console.log('❌ 请求超时');
    req.destroy();
    process.exit(1);
});

req.end();