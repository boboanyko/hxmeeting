#!/usr/bin/env python3
"""
PRD生成器脚本
基于分析结果自动生成产品需求文档
"""

import json
from datetime import datetime
from typing import Dict, Any, List

class PRDGenerator:
    def __init__(self):
        self.prd_template = {
            "document_info": {
                "version": "1.0",
                "created_date": datetime.now().strftime("%Y-%m-%d"),
                "status": "草稿"
            },
            "project_overview": {},
            "product_specifications": {},
            "technical_specifications": {},
            "project_plan": {},
            "success_metrics": {}
        }

    def generate_executive_summary(self, analysis: Dict[str, Any]) -> str:
        """生成执行摘要"""
        complexity = analysis["requirement_summary"]["complexity_level"]
        user_type = analysis["requirement_summary"]["user_type"]
        feature_count = len(analysis["extracted_features"])

        summary = f"""
## 项目概述

本项目旨在为{user_type}提供一个包含{feature_count}个核心功能的技术解决方案。
根据需求分析，项目复杂度为{complexity}级别，
预计开发周期为{analysis['technical_suggestions']['estimated_development_time']}，
建议团队规模为{analysis['technical_suggestions']['team_size_recommendation']}。

### 核心价值
- 解决用户核心业务需求
- 提供高效可靠的技术解决方案
- 支持未来业务发展和扩展

### 技术架构
推荐采用{analysis['technical_suggestions']['recommended_architecture']}，
确保系统的稳定性、可扩展性和可维护性。
        """
        return summary.strip()

    def generate_feature_specifications(self, features: List[Dict]) -> str:
        """生成功能规格说明"""
        if not features:
            return "暂无具体功能需求，需要进一步调研和分析。"

        feature_spec = "## 产品功能规格\n\n### 核心功能\n\n"

        for i, feature in enumerate(features, 1):
            feature_spec += f"""
#### 功能{i}: {feature['description'][:50]}...

**功能描述**: {feature['description']}

**用户故事**: 作为{feature.get('user_role', '用户')，我希望能{feature['description']}，以便{feature.get('benefit', '提高工作效率')}。

**验收标准**:
- [ ] 功能正常运行，无明显Bug
- [ ] 用户界面友好，操作流畅
- [ ] 数据处理准确，结果一致
- [ ] 性能满足预期要求

**优先级**: {feature.get('priority', '中')}

**预估工作量**: {feature.get('effort', '待评估')}
            """

        return feature_spec

    def generate_technical_specifications(self, analysis: Dict[str, Any]) -> str:
        """生成技术规格说明"""
        architecture = analysis['technical_suggestions']['recommended_architecture']
        considerations = analysis['technical_suggestions']['key_technical_considerations']

        tech_spec = f"""
## 技术规格

### 系统架构
采用{architecture}，确保系统的可扩展性和可维护性。

### 技术栈选择

#### 前端技术栈
- **框架**: React.js / Vue.js (根据项目需求选择)
- **状态管理**: Redux / Vuex / Context API
- **UI组件库**: Ant Design / Element Plus
- **构建工具**: Vite / Webpack

#### 后端技术栈
- **框架**: Spring Boot / Node.js / Python FastAPI
- **数据库**: MySQL / PostgreSQL / MongoDB
- **缓存**: Redis
- **消息队列**: RabbitMQ / Kafka (如需要)

#### 部署和运维
- **容器化**: Docker
- **编排**: Kubernetes (复杂项目) / Docker Compose (简单项目)
- **监控**: Prometheus + Grafana
- **日志**: ELK Stack

### 技术考虑事项
        """

        for i, consideration in enumerate(considerations, 1):
            tech_spec += f"\n{i}. {consideration}"

        tech_spec += """

### 非功能需求

#### 性能要求
- 响应时间: 页面加载 < 3秒，API响应 < 500ms
- 并发支持: 支持1000+并发用户
- 数据处理: 支持百万级数据处理

#### 安全要求
- 用户认证: JWT Token / OAuth2
- 数据加密: HTTPS + 数据库敏感数据加密
- 权限控制: 基于角色的访问控制(RBAC)

#### 可用性要求
- 系统可用性: 99.9%
- 数据备份: 每日自动备份
- 故障恢复: RTO < 4小时, RPO < 1小时
        """

        return tech_spec

    def generate_project_plan(self, analysis: Dict[str, Any]) -> str:
        """生成项目计划"""
        complexity = analysis["requirement_summary"]["complexity_level"]
        estimated_time = analysis['technical_suggestions']['estimated_development_time']

        project_plan = f"""
## 项目计划

### 开发阶段

#### 第一阶段: 需求调研和设计 ({self._get_phase_duration(complexity, 'design')})
- 详细需求分析和用户调研
- 系统架构设计和技术选型
- UI/UX设计和原型制作
- 数据库设计和API设计

#### 第二阶段: 核心功能开发 ({self._get_phase_duration(complexity, 'development')})
- 基础框架搭建
- 核心功能模块开发
- 数据库实现
- API接口开发

#### 第三阶段: 功能完善和集成 ({self._get_phase_duration(complexity, 'integration')})
- 功能完善和优化
- 系统集成和联调
- 性能优化
- 安全加固

#### 第四阶段: 测试和部署 ({self._get_phase_duration(complexity, 'testing')})
- 单元测试和集成测试
- 用户验收测试
- 部署准备和环境配置
- 正式发布和上线

### 里程碑
- **MVP版本**: 核心功能可用
- **Beta版本**: 功能基本完善
- **正式版本**: 功能完整，性能达标
- **运维版本**: 稳定运行，持续优化

### 团队配置
- **项目经理**: 1人，负责项目管理和协调
- **产品经理**: 1人，负责需求管理和产品设计
- **前端开发**: {self._get_dev_count(complexity, 'frontend')}人
- **后端开发**: {self._get_dev_count(complexity, 'backend')}人
- **测试工程师**: {self._get_dev_count(complexity, 'test')}人
- **运维工程师**: {self._get_dev_count(complexity, 'devops')}人

### 风险管控
- **技术风险**: 提前技术验证，设置技术预研阶段
- **进度风险**: 设置缓冲时间，定期进度检查
- **质量风险**: 建立完善的测试体系，代码审查机制
- **资源风险**: 提前资源规划，建立备用资源池
        """

        return project_plan

    def _get_phase_duration(self, complexity: str, phase: str) -> str:
        """获取各阶段的预估时间"""
        durations = {
            "低": {
                "design": "1周",
                "development": "1-2周",
                "integration": "1周",
                "testing": "1周"
            },
            "中": {
                "design": "2-3周",
                "development": "3-6周",
                "integration": "2-3周",
                "testing": "2-3周"
            },
            "高": {
                "design": "3-4周",
                "development": "6-12周",
                "integration": "4-6周",
                "testing": "3-4周"
            }
        }
        return durations.get(complexity, {}).get(phase, "待评估")

    def _get_dev_count(self, complexity: str, role: str) -> int:
        """获取各角色的开发人员数量"""
        counts = {
            "低": {
                "frontend": 1,
                "backend": 1,
                "test": 1,
                "devops": 0.5
            },
            "中": {
                "frontend": 2,
                "backend": 2,
                "test": 1,
                "devops": 1
            },
            "高": {
                "frontend": 3,
                "backend": 3,
                "test": 2,
                "devops": 1
            }
        }
        return counts.get(complexity, {}).get(role, 1)

    def generate_success_metrics(self) -> str:
        """生成成功指标"""
        return """
## 成功指标

### 业务指标
- **用户增长**: 月活跃用户数达到预期目标
- **用户满意度**: 用户满意度评分 > 4.0/5.0
- **业务效率**: 相关业务流程效率提升 > 30%
- **成本节约**: 运营成本降低 > 20%

### 技术指标
- **系统性能**: 平均响应时间 < 500ms
- **系统稳定性**: 系统可用性 > 99.9%
- **代码质量**: 代码覆盖率 > 80%，Bug密度 < 1/KLOC
- **部署效率**: 部署成功率 > 95%，部署时间 < 30分钟

### 用户体验指标
- **易用性**: 新用户上手时间 < 30分钟
- **任务完成率**: 核心任务完成率 > 90%
- **错误率**: 用户操作错误率 < 5%
- **响应性**: 用户反馈响应时间 < 24小时
        """

    def generate_prd(self, analysis: Dict[str, Any]) -> str:
        """生成完整的PRD文档"""
        prd_content = f"""
# 产品需求文档

{self.generate_executive_summary(analysis)}

{self.generate_feature_specifications(analysis['extracted_features'])}

{self.generate_technical_specifications(analysis)}

{self.generate_project_plan(analysis)}

{self.generate_success_metrics()}

## 下一步行动

基于以上分析和规划，建议按以下顺序推进项目：

1. **需求确认**: 与业务方确认需求细节和优先级
2. **技术验证**: 进行关键技术点的原型验证
3. **团队组建**: 按照建议配置组建开发团队
4. **环境准备**: 搭建开发和测试环境
5. **详细设计**: 完成详细的技术设计和UI设计
6. **开发实施**: 按照计划开始开发工作

---

**文档版本**: 1.0
**创建日期**: {datetime.now().strftime("%Y年%m月%d日")}
**更新日期**: {datetime.now().strftime("%Y年%m月%d日")}
        """

        return prd_content

def main():
    """主函数 - 命令行工具"""
    import sys
    import os

    if len(sys.argv) != 2:
        print("用法: python prd_generator.py '<分析结果JSON文件路径>'")
        sys.exit(1)

    analysis_file = sys.argv[1]

    if not os.path.exists(analysis_file):
        print(f"错误: 文件 {analysis_file} 不存在")
        sys.exit(1)

    try:
        with open(analysis_file, 'r', encoding='utf-8') as f:
            analysis = json.load(f)
    except json.JSONDecodeError as e:
        print(f"错误: JSON文件格式不正确 - {e}")
        sys.exit(1)

    generator = PRDGenerator()
    prd_content = generator.generate_prd(analysis)

    # 输出PRD内容到文件
    output_file = f"PRD_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(prd_content)

    print(f"PRD文档已生成: {output_file}")

if __name__ == "__main__":
    main()