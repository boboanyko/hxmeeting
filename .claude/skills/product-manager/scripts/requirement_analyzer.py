#!/usr/bin/env python3
"""
需求分析脚本
用于系统化分析用户需求，提取关键信息并生成结构化分析报告
"""

import re
import json
from typing import Dict, List, Any
from datetime import datetime

class RequirementAnalyzer:
    def __init__(self):
        self.analysis_framework = {
            "background_info": ["项目背景", "业务现状", "市场环境", "关键干系人"],
            "problem_definition": ["核心问题", "问题严重性", "当前解决方案", "改进机会"],
            "target_users": ["主要用户群体", "用户特征", "使用场景", "用户痛点"],
            "functional_requirements": ["核心功能", "扩展功能"],
            "non_functional_requirements": ["性能要求", "安全性要求", "可用性要求", "兼容性要求"],
            "constraints": ["技术约束", "预算约束", "时间约束", "资源约束"],
            "success_metrics": ["业务指标", "技术指标", "用户满意度", "运营指标"],
            "risk_assessment": ["技术风险", "市场风险", "资源风险", "合规风险"]
        }

    def extract_keywords(self, text: str) -> List[str]:
        """提取文本中的关键词"""
        # 简单的关键词提取逻辑
        keywords = []

        # 常见的关键词模式
        patterns = [
            r'(用户|客户|顾客)',
            r'(系统|平台|应用)',
            r'(功能|特性|模块)',
            r'(数据|信息|内容)',
            r'(安全|稳定|可靠)',
            r'(快速|高效|便捷'),
            r'(管理|处理|分析)',
            r'(设计|开发|实现)',
            r'(测试|部署|运维)',
            r'(成本|预算|时间)'
        ]

        for pattern in patterns:
            matches = re.findall(pattern, text)
            keywords.extend(matches)

        return list(set(keywords))

    def identify_user_type(self, text: str) -> str:
        """识别用户类型"""
        user_indicators = {
            "企业用户": ["企业", "公司", "组织", "团队", "员工"],
            "个人用户": ["个人", "用户", "消费者", "客户"],
            "开发者": ["开发者", "程序员", "技术", "API", "接口"],
            "管理员": ["管理员", "运营", "维护", "配置", "管理"]
        }

        for user_type, indicators in user_indicators.items():
            if any(indicator in text for indicator in indicators):
                return user_type

        return "未明确"

    def extract_features(self, text: str) -> List[Dict[str, str]]:
        """提取功能需求"""
        features = []

        # 功能描述模式
        feature_patterns = [
            r'(?:需要|想要|希望|应该)\s*([^\n，。！？]+)',
            r'(?:支持|提供|实现)\s*([^\n，。！？]+)',
            r'(?:功能|特性|模块)[：:]\s*([^\n，。！？]+)'
        ]

        for pattern in feature_patterns:
            matches = re.findall(pattern, text)
            for match in matches:
                if len(match.strip()) > 5:  # 过滤过短的描述
                    features.append({
                        "description": match.strip(),
                        "type": "functional",
                        "priority": "medium"
                    })

        return features

    def assess_complexity(self, text: str, features: List[Dict]) -> str:
        """评估项目复杂度"""
        complexity_score = 0

        # 基于功能数量
        complexity_score += len(features) * 10

        # 基于关键词
        complexity_keywords = {
            "高": ["集成", "实时", "大数据", "AI", "机器学习", "分布式", "微服务"],
            "中": ["管理系统", "数据分析", "报表", "API", "数据库"],
            "低": ["展示", "查询", "表单", "简单", "基础"]
        }

        for level, keywords in complexity_keywords.items():
            if any(keyword in text for keyword in keywords):
                if level == "高":
                    complexity_score += 30
                elif level == "中":
                    complexity_score += 20
                else:
                    complexity_score += 10

        if complexity_score >= 80:
            return "高"
        elif complexity_score >= 40:
            return "中"
        else:
            return "低"

    def suggest_architecture(self, complexity: str, user_type: str, features: List[Dict]) -> str:
        """建议技术架构"""
        if complexity == "高":
            return "微服务架构"
        elif complexity == "中":
            return "分层架构"
        else:
            return "单体架构"

    def analyze(self, requirement_text: str) -> Dict[str, Any]:
        """分析需求文本"""
        # 提取基本信息
        keywords = self.extract_keywords(requirement_text)
        user_type = self.identify_user_type(requirement_text)
        features = self.extract_features(requirement_text)
        complexity = self.assess_complexity(requirement_text, features)
        suggested_architecture = self.suggest_architecture(complexity, user_type, features)

        # 生成分析报告
        analysis_report = {
            "timestamp": datetime.now().isoformat(),
            "requirement_summary": {
                "original_text": requirement_text[:500] + "..." if len(requirement_text) > 500 else requirement_text,
                "keywords": keywords,
                "user_type": user_type,
                "complexity_level": complexity
            },
            "extracted_features": features,
            "technical_suggestions": {
                "recommended_architecture": suggested_architecture,
                "estimated_development_time": self._estimate_time(complexity, len(features)),
                "team_size_recommendation": self._suggest_team_size(complexity),
                "key_technical_considerations": self._get_technical_considerations(complexity, features)
            },
            "next_steps": [
                "1. 详细调研用户需求和使用场景",
                "2. 制定详细的产品规格文档",
                "3. 进行技术选型和架构设计",
                "4. 制定开发计划和里程碑",
                "5. 准备必要的开发资源和环境"
            ]
        }

        return analysis_report

    def _estimate_time(self, complexity: str, feature_count: int) -> str:
        """估算开发时间"""
        base_time = {
            "低": "2-4周",
            "中": "1-3个月",
            "高": "3-6个月"
        }

        # 根据功能数量调整
        if feature_count > 10:
            base_time = {
                "低": "4-6周",
                "中": "2-4个月",
                "高": "4-8个月"
            }

        return base_time.get(complexity, "待评估")

    def _suggest_team_size(self, complexity: str) -> str:
        """建议团队规模"""
        team_size = {
            "低": "2-4人",
            "中": "4-8人",
            "高": "8-15人"
        }
        return team_size.get(complexity, "待评估")

    def _get_technical_considerations(self, complexity: str, features: List[Dict]) -> List[str]:
        """获取技术考虑事项"""
        considerations = []

        if complexity == "高":
            considerations.extend([
                "需要考虑系统的可扩展性和高可用性",
                "建议采用微服务架构",
                "需要完善的监控和日志系统",
                "考虑使用容器化部署"
            ])
        elif complexity == "中":
            considerations.extend([
                "建议采用分层架构设计",
                "需要考虑数据库设计优化",
                "建议建立完善的测试体系"
            ])
        else:
            considerations.extend([
                "可以采用单体架构快速开发",
                "重点关注用户体验",
                "确保代码质量和可维护性"
            ])

        # 基于功能类型的考虑
        feature_descriptions = [f["description"] for f in features]
        if any("数据" in desc for desc in feature_descriptions):
            considerations.append("需要重点关注数据处理和存储方案")

        if any("安全" in desc for desc in feature_descriptions):
            considerations.append("需要实施完善的安全措施")

        if any("实时" in desc for desc in feature_descriptions):
            considerations.append("需要考虑实时数据同步和处理方案")

        return considerations

def main():
    """主函数 - 命令行工具"""
    import sys

    if len(sys.argv) != 2:
        print("用法: python requirement_analyzer.py '<需求文本>'")
        sys.exit(1)

    requirement_text = sys.argv[1]
    analyzer = RequirementAnalyzer()
    analysis = analyzer.analyze(requirement_text)

    # 输出分析结果
    print("=== 需求分析报告 ===")
    print(json.dumps(analysis, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()