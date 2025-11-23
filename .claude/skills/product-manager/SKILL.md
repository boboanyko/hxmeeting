---
name: product-manager
description: 当用户需要将想法、会议记录或零散需求整理成规范的产品需求文档时使用。该技能能够分析模糊需求，设计系统架构，生成标准化产品规格，为后续开发提供清晰指导。
---

# Product Manager Skill

## Purpose

This skill specializes in transforming vague user requirements and ideas into structured, actionable product specifications. It analyzes business needs, designs system architectures, and generates comprehensive product requirements documents (PRDs) that provide clear guidance for subsequent development work.

## When to Use This Skill

Use this skill when:
- Users provide abstract ideas or business problems that need technical translation
- Meeting notes or brainstorming sessions require structured analysis
- Business requirements need to be converted into technical specifications
- Stakeholders need standardized documentation for development teams
- Technology stack decisions and architecture patterns need evaluation

## How to Use This Skill

### Step 1: Requirements Analysis
1. **Extract Key Information** from user input using the requirement analysis framework in `references/requirement_template.md`
2. **Identify Core Problem** the user is trying to solve
3. **Clarify Business Objectives** and success criteria
4. **Document Constraints** and limitations

### Step 2: System Design
1. **Architectural Planning** using patterns from `references/architecture_patterns.md`
2. **Feature Breakdown** into functional and non-functional requirements
3. **Technology Stack Selection** guided by `references/technology_stack.md`
4. **User Experience Flow** design

### Step 3: Documentation Generation
1. **Create PRD** using the template in `references/prd_template.md`
2. **Generate Technical Specifications** for development teams
3. **Include Visual Diagrams** from `assets/diagrams/` when helpful
4. **Provide Implementation Roadmap** with milestones

### Step 4: Validation and Refinement
1. **Review Generated Documents** for completeness and clarity
2. **Validate Technical Feasibility** of proposed solutions
3. **Identify Risk Areas** and mitigation strategies
4. **Suggest Next Steps** for development handoff

## Bundled Resources Usage

### Scripts

- **`scripts/requirement_analyzer.py`** - Execute to systematically analyze user requirements using standard frameworks
- **`scripts/prd_generator.py`** - Run to generate standardized PRD documents from analyzed requirements

### References

- **`references/requirement_template.md`** - Load when conducting requirement analysis to ensure comprehensive coverage
- **`references/prd_template.md`** - Reference for generating structured product requirements documents
- **`references/architecture_patterns.md`** - Consult when designing system architecture and selecting appropriate patterns
- **`references/technology_stack.md`** - Use when evaluating and recommending technology choices

### Assets

- **`assets/diagrams/`** - Utilize architecture diagram templates for visual system representation
- **`assets/templates/`** - Apply document templates for consistent formatting and structure

## Output Format

Generate outputs in the following structure:

1. **Executive Summary** - High-level overview and business value
2. **Requirements Analysis** - Detailed breakdown of user needs
3. **System Architecture** - Technical design and component relationships
4. **Feature Specifications** - Detailed feature descriptions and acceptance criteria
5. **Implementation Plan** - Timeline, resources, and next steps
6. **Risk Assessment** - Potential challenges and mitigation strategies

## Quality Criteria

Ensure all outputs meet these standards:
- **Clarity** - Technical specifications are unambiguous and actionable
- **Completeness** - All aspects of requirements are addressed
- **Feasibility** - Proposed solutions are technically achievable
- **Alignment** - Solutions directly address user business objectives
- **Maintainability** - Architecture supports future growth and changes