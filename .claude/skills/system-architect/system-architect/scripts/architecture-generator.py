#!/usr/bin/env python3
"""
架构图生成器
用于生成标准化的系统架构图和部署图
"""

import json
import yaml
from typing import Dict, List, Any
from dataclasses import dataclass
from enum import Enum

class ArchitectureType(Enum):
    LAYERED = "layered"
    MICROSERVICE = "microservice"
    EVENT_DRIVEN = "event_driven"
    SERVERLESS = "serverless"

class DiagramType(Enum):
    CONTEXT = "context"
    CONTAINER = "container"
    COMPONENT = "component"
    DEPLOYMENT = "deployment"

@dataclass
class Component:
    name: str
    type: str
    technology: str
    description: str
    interfaces: List[str] = None

@dataclass
class Container:
    name: str
    type: str
    technology: str
    description: str
    components: List[Component] = None

@dataclass
class System:
    name: str
    description: str
    architecture_type: ArchitectureType
    containers: List[Container] = None
    external_systems: List[str] = None

class ArchitectureDiagramGenerator:
    def __init__(self):
        self.system = None

    def generate_mermaid_context_diagram(self, system: System) -> str:
        """生成系统上下文图 (Mermaid格式)"""
        mermaid_code = []
        mermaid_code.append("graph TB")
        mermaid_code.append(f"    User([用户]) --> {system.name}")
        mermaid_code.append(f"    subgraph {system.name}[{system.name}]")
        mermaid_code.append(f"        description[\"{system.description}\"]")
        mermaid_code.append("    end")

        if system.external_systems:
            for ext_system in system.external_systems:
                mermaid_code.append(f"    {system.name} --> {ext_system}")

        return "\n".join(mermaid_code)

    def generate_mermaid_container_diagram(self, system: System) -> str:
        """生成容器架构图 (Mermaid格式)"""
        mermaid_code = []
        mermaid_code.append("graph TB")

        for container in system.containers or []:
            container_id = container.name.replace(" ", "_")
            mermaid_code.append(f"    subgraph {container_id}[{container.name}]")
            mermaid_code.append(f"        description[\"{container.description}<br/>{container.technology}\"]")

            if container.components:
                for component in container.components:
                    comp_id = component.name.replace(" ", "_")
                    mermaid_code.append(f"        {comp_id}[{component.name}]")
                    mermaid_code.append(f"        {comp_id} --> description")

            mermaid_code.append("    end")

        return "\n".join(mermaid_code)

    def generate_mermaid_deployment_diagram(self, system: System) -> str:
        """生成部署架构图 (Mermaid格式)"""
        mermaid_code = []
        mermaid_code.append("graph TB")
        mermaid_code.append("    subgraph 用户端")
        mermaid_code.append("        Browser[浏览器]")
        mermaid_code.append("        Mobile[移动设备]")
        mermaid_code.append("    end")

        mermaid_code.append("    subgraph 负载均衡层")
        mermaid_code.append("        LB[Nginx负载均衡]")
        mermaid_code.append("    end")

        mermaid_code.append("    subgraph 应用层")
        for i, container in enumerate(system.containers or []):
            container_id = f"App{i+1}"
            mermaid_code.append(f"        {container_id}[{container.name}]")

        mermaid_code.append("    end")

        mermaid_code.append("    subgraph 数据层")
        mermaid_code.append("        DB[(主数据库)]")
        mermaid_code.append("        Cache[(缓存Redis)]")
        mermaid_code.append("        MQ[消息队列]")
        mermaid_code.append("    end")

        # 连接关系
        mermaid_code.append("    Browser --> LB")
        mermaid_code.append("    Mobile --> LB")
        mermaid_code.append("    LB --> App1")

        for i, container in enumerate(system.containers or []):
            if i > 0:
                mermaid_code.append(f"    LB --> App{i+1}")
            mermaid_code.append(f"    App{i+1} --> DB")
            mermaid_code.append(f"    App{i+1} --> Cache")
            if "async" in container.description.lower():
                mermaid_code.append(f"    App{i+1} --> MQ")

        return "\n".join(mermaid_code)

    def generate_plantuml_diagram(self, system: System, diagram_type: DiagramType) -> str:
        """生成PlantUML格式的架构图"""
        plantuml_code = []
        plantuml_code.append("@startuml")
        plantuml_code.append("!theme plain")
        plantuml_code.append("skinparam monochrome true")
        plantuml_code.append("skinparam shadowing false")

        if diagram_type == DiagramType.CONTEXT:
            plantuml_code.append("actor User as 用户")
            plantuml_code.append(f"rectangle {system.name} {{")
            plantuml_code.append(f"  {system.description}")
            plantuml_code.append("}")

            if system.external_systems:
                for ext_system in system.external_systems:
                    plantuml_code.append(f"database \"{ext_system}\" as {ext_system.replace(' ', '_')}")
                    plantuml_code.append(f"用户 --> {system.name}")
                    plantuml_code.append(f"{system.name} --> {ext_system.replace(' ', '_')}")

        plantuml_code.append("@enduml")
        return "\n".join(plantuml_code)

    def generate_architecture_documentation(self, system: System) -> Dict[str, str]:
        """生成完整的架构文档"""
        docs = {}

        # 生成各种图表
        docs['context_mermaid'] = self.generate_mermaid_context_diagram(system)
        docs['container_mermaid'] = self.generate_mermaid_container_diagram(system)
        docs['deployment_mermaid'] = self.generate_mermaid_deployment_diagram(system)
        docs['context_plantuml'] = self.generate_plantuml_diagram(system, DiagramType.CONTEXT)

        # 生成架构说明
        docs['overview'] = self._generate_architecture_overview(system)
        docs['containers'] = self._generate_container_descriptions(system)
        docs['decisions'] = self._generate_architecture_decisions(system)

        return docs

    def _generate_architecture_overview(self, system: System) -> str:
        """生成架构概述"""
        overview = f"""
# {system.name} 架构概述

## 系统描述
{system.description}

## 架构类型
{system.architecture_type.value}

## 整体架构原则
- 简单性原则：保持架构简洁明了
- 模块化原则：高内聚，低耦合
- 可扩展性原则：支持水平和垂直扩展
- 可维护性原则：便于理解和修改

## 关键特性
- 高可用性：支持故障转移和恢复
- 高性能：优化响应时间和吞吐量
- 安全性：多层次安全防护
- 可观测性：完整的监控和日志体系
"""
        return overview

    def _generate_container_descriptions(self, system: System) -> str:
        """生成容器描述"""
        descriptions = ["## 容器组件\n"]

        for container in system.containers or []:
            descriptions.append(f"### {container.name}")
            descriptions.append(f"- **类型**: {container.type}")
            descriptions.append(f"- **技术栈**: {container.technology}")
            descriptions.append(f"- **描述**: {container.description}")

            if container.components:
                descriptions.append("\n**组件列表**:")
                for component in container.components:
                    descriptions.append(f"- {component.name}: {component.description}")

            descriptions.append("")

        return "\n".join(descriptions)

    def _generate_architecture_decisions(self, system: System) -> str:
        """生成架构决策"""
        decisions = [
            "## 架构决策记录 (ADR)\n",
            "### ADR-001: 选择微服务架构",
            "**状态**: 已接受",
            "**背景**: 系统需要支持独立部署和扩展",
            "**决策**: 采用微服务架构模式",
            "**后果**: 增加了系统复杂性，但提高了灵活性和可扩展性\n",

            "### ADR-002: 技术栈选择",
            "**状态**: 已接受",
            "**背景**: 平衡性能、开发效率和团队技能",
            "**决策**: 选择主流成熟的技术栈",
            "**后果**: 学习成本较低，生态系统丰富\n"
        ]

        return "\n".join(decisions)

def create_sample_system() -> System:
    """创建示例系统"""
    # 创建组件
    web_components = [
        Component("前端界面", "Web UI", "React", "用户交互界面"),
        Component("API网关", "Gateway", "Spring Gateway", "统一入口和路由")
    ]

    auth_components = [
        Component("认证服务", "Auth Service", "Spring Boot", "用户认证和授权"),
        Component("JWT工具", "JWT Utils", "Java JWT", "Token生成和验证")
    ]

    business_components = [
        Component("业务服务", "Business Service", "Spring Boot", "核心业务逻辑"),
        Component("数据访问", "Data Access", "MyBatis", "数据库操作")
    ]

    # 创建容器
    containers = [
        Container("Web前端", "前端应用", "React + Nginx", "用户界面层", web_components),
        Container("认证服务", "微服务", "Spring Boot + Docker", "用户认证模块", auth_components),
        Container("业务服务", "微服务", "Spring Boot + Docker", "核心业务处理", business_components)
    ]

    # 创建系统
    system = System(
        name="示例系统",
        description="基于微服务架构的示例应用系统",
        architecture_type=ArchitectureType.MICROSERVICE,
        containers=containers,
        external_systems=["数据库", "缓存系统", "消息队列"]
    )

    return system

def main():
    """主函数 - 示例用法"""
    generator = ArchitectureDiagramGenerator()

    # 创建示例系统
    system = create_sample_system()

    # 生成架构文档
    docs = generator.generate_architecture_documentation(system)

    # 输出结果
    print("=== 架构图生成完成 ===")
    print("\n1. 系统上下文图 (Mermaid):")
    print(docs['context_mermaid'])

    print("\n2. 容器架构图 (Mermaid):")
    print(docs['container_mermaid'])

    print("\n3. 部署架构图 (Mermaid):")
    print(docs['deployment_mermaid'])

    print("\n4. 架构概述:")
    print(docs['overview'])

    print("\n5. 容器描述:")
    print(docs['containers'])

    print("\n6. 架构决策:")
    print(docs['decisions'])

if __name__ == "__main__":
    main()