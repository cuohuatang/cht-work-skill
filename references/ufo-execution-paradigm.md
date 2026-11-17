# UFO² / UFO³ 执行编排范式细则（V0.05 嫁接，流程第四步）

配套主 `SKILL.md` 的「第四步 · 执行编排」。解决一个此前一直缺的问题：**前三步都在做决策（优化提示词、检索技能、选路线），却没有规范「怎么把活可靠地干完」**。这一层借鉴微软 UFO 系列的桌面 Agent 编排范式，只取方法论，不引入其运行时。

## 0. 来源（链接一字不改）

- GitHub 仓库：<https://github.com/microsoft/UFO>
- UFO² 官方文档：<https://microsoft.github.io/UFO/ufo2/overview/>

> 仓库为 MIT 许可，约 10.2k stars（2026-11 查询）。当前主分支名为「UFO³: Weaving the Digital Agent Galaxy」，UFO² 处于 LTS（长期支持）状态。本文件是**范式笔记**，不是 UFO 的安装或部署指南。

## 1. 三代演进（官方 README 时间线）

| 版本 | 时间 | 定位 | 任务模型 |
| --- | --- | --- | --- |
| UFO | 2024-02 | Windows GUI Agent（UI-Focused） | 单 Agent，截图 + 模拟输入 |
| **UFO²** | 2025-04 | **Desktop AgentOS**，深度集成 Windows OS | 两层 Agent 层级，顺序 ReAct 循环 |
| **UFO³ Galaxy** | 2025-11 | 多设备编排框架 | 声明式 DAG（Task Constellation），并行异步 |

UFO³ = Galaxy（多设备编排）+ UFO²（设备 Agent）。UFO² 既可独立做单机 Windows 自动化，也可作为 Galaxy 的 Windows 设备代理。本技能只借鉴与「单 Agent 编排自己的子任务」相关的部分（UFO² 为主，UFO³ 的 DAG 思想作复合任务扩展）。

## 2. UFO² 核心架构

### 2.1 两层 Agent 层级（Two-Tier Agent Hierarchy）

| 角色 | 定位 | 负责 | 关键能力 |
| --- | --- | --- | --- |
| **HostAgent** | Desktop Orchestrator | **WHAT**（用哪个应用）、**WHEN**（任务排序） | 任务分解、应用选择、跨应用协调、AppAgent 生命周期管理；7 态 FSM |
| **AppAgent** | Application Executor | **HOW**（UI/API 交互）、**WHERE**（控件定位） | UI 元素交互、混合 GUI–API 执行、应用内自动化、结果回报；6 态 FSM |

配套机制：**Blackboard** 做 Agent 间解耦通信（黑板共享上下文）、**State Machine** 保证确定性执行流与错误恢复。

### 2.2 五大创新（Key Innovations）

1. **Deep OS Integration**：Windows UIA（无障碍树）、Win32、WinCOM；混合检测把 UIA 元数据与视觉 grounding（OmniParser）融合，兼顾标准控件与自定义控件。
2. **Unified GUI–API Action Layer**：原生 API 优先（Excel `xlwings`、Outlook `win32com`、PowerPoint `python-pptx`），GUI 点击 / 输入 / 选择 / 滚动作兜底；命令通过 MCP servers 分发。
3. **Continuous Knowledge Substrate**：不重训模型，从三类源持续学习——帮助文档 / API 参考（RAG 向量检索）、实时检索（Bing，动态查询扩展）、执行历史（成功 / 失败动作序列，经验回放与模式挖掘）。
4. **Speculative Multi-Action Execution**：一次 LLM 调用预测 N 个动作，用轻量控件状态校验后批量执行；官方称减少 **51% LLM 调用**（例：填 10 个字段从 10 次调用 ~30s 降到 1 次预测 ~8s）。
5. **Picture-in-Picture Desktop**：嵌套虚拟桌面并行自动化，用户与 Agent 不争抢鼠标键盘，零干扰。

### 2.3 四阶段处理流水线（HostAgent 与 AppAgent 各自执行）

| 阶段 | 目的 | HostAgent | AppAgent |
| --- | --- | --- | --- |
| 1. Data Collection | 采集环境状态 | 桌面截图、应用列表 | 应用截图、UI 树、控件标注 |
| 2. LLM Interaction | 决策下一步 | 选应用、规划子任务 | 选控件、规划动作序列 |
| 3. Action Execution | 执行命令 | 启动应用、创建 AppAgent | 执行 GUI/API 动作 |
| 4. Memory Update | 记录执行 | 保存编排步骤 | 保存交互步骤、更新黑板 |

### 2.4 命令系统（MCP Server 分发）

HostAgent：`capture_desktop_screenshot`、`get_desktop_app_info`、`get_app_window`、`launch_application`、`close_application`
AppAgent：`capture_screenshot`、`annotate_screenshot`、`get_control_info`、`get_ui_tree`、`click`、`set_edit_text`、`select_control_by_index`

## 3. UFO³ Galaxy 的 DAG 编排（复合任务才用）

五大设计原则：① 声明式分解为动态 DAG（TaskStar 节点 + TaskStarLine 依赖 + TaskConstellation）；② 结果驱动的图演化（运行时按需改写）；③ 异构 / 异步 / 安全编排（能力匹配设备、异步调度、安全锁、一致性保证）；④ 统一 AIP 协议（WebSocket，容错与自动重连）；⑤ 模板化 MCP 设备代理。

配套：ConstellationAgent（分解与规划）+ TaskOrchestrator（执行引擎）、Observer System（进度 / 指标 / 可视化）、Trajectory Report 与 Result JSON。

## 4. 转译表：UFO 概念 → 本技能可执行规则

**这是嫁接的核心。** 左列是 UFO 原文概念，右列是本技能真正要做的事；不要把左列的 Windows 专用技术照搬到右列。

| UFO 概念 | 本技能落地规则（V0.05 第四步） | 可观测验收 |
| --- | --- | --- |
| HostAgent（WHAT/WHEN） | 主 `SKILL.md` 作编排层：优化 → 检索 → 选路线 → 拆子任务；只决定「做什么、用哪个能力」，不亲自逐页排版 | 主文件不含具体页面 HTML 生成代码 |
| AppAgent（HOW/WHERE） | 子技能 / `scripts/` / 命令行作执行层：一次只做一个明确子任务，做完回报结果，不擅自改路线 | 每个子任务有明确输入输出 |
| Blackboard（解耦共享上下文） | 第一步产出的**高阶顶配版提示词 = 全流程唯一共享上下文**，各步挂在它上面，不重复口述需求 | 各步骤引用同一份优化结果 |
| 混合 GUI–API（原生优先） | 脚本 / API / 命令行确定性完成优先：`scripts/*.py`、`*.mjs`、`git`、`curl`；界面点击只在无接口时兜底 | 执行记录里无「因为没有接口所以点界面」之外的 GUI 操作 |
| 推测式多动作（批量） | 无依赖的工具调用**并行发出**；批量前做轻量状态校验（文件存在、上一步成功），失效退回逐步执行 | 独立调用成对并发，串行调用有依赖说明 |
| 持续知识底座（三源） | 子技能 `SKILL.md`/`references/` = 帮助文档；find-skills / 官方文档抓取 = 实时检索；**版本历史 + 历次留痕 = 执行历史** | 每轮踩坑回写细则，版本历史有新增行 |
| 四阶段流水线 | 采集（读现状）→ 决策（前三步）→ 执行（本步）→ 记忆更新（留痕回写） | 交付说明含四段留痕 |
| 状态机 + 错误恢复 | 阈值表、禁止优化清单、路线表、许可约束为固定状态转移；失败回到上一确定状态重试 | 无「静默跳过 / 假装成功」 |
| Picture-in-Picture | 后台执行不占用用户当前界面；产物落 `/workspace`，临时文件落沙箱 artifact 目录 | 交付物路径正确 |
| UFO³ DAG（TaskStar） | 复合任务拆成有依赖节点：无依赖并行、有依赖按序；某节点结果变化只重算受影响分支 | 复合任务有节点划分与依赖说明 |
| Observer / Trajectory | 交付话术模板的四条留痕 + 版本历史 + 敏感信息扫描结果 | 交付说明可复核 |

### 适用范围（防止过度编排）

| 任务形态 | 编排强度 |
| --- | --- |
| 单一交付物、一步能做完（翻译、改色、生成一页、纯问答） | **直接执行**，不拆任务图、不并行 |
| 复合任务：多交付物 / 跨工具（生成 + 校验 + 推送 + 安装）/ 有依赖顺序 | **启用**任务图与六条原则 |

> 这条适用范围本身来自 V0.04 的「范围过宽」漏洞规避：不是所有任务都值得上重型编排。

## 5. 诚实边界（不可越界）

- **不集成 UFO 运行时**：不安装、不调用、不复制 UFO / UFO² / UFO³ 的任何代码、配置或依赖。
- **不引入 Windows 专用技术**：UIA、Win32、WinCOM、OmniParser、OmniParser 视觉 grounding、Win32 消息循环、MCP server 集群、AIP 协议、PiP 远程桌面，全部不在本技能能力范围内。本技能运行在任意平台的 Agent 上，产物是 HTML。
- **技术栈无交集**：UFO 是 Windows 桌面自动化框架；本技能是网页演示文稿工作流。嫁接的是「拆任务、排顺序、选执行手段、失败恢复、沉淀经验」这套平台无关的章法。
- **不改变交付主体**：两条 PPT 路线仍是唯一交付主体，第四步不动它们的版式规则、配色约束、许可义务。
- **来源标注**：UFO 相关商标归微软所有；本仓库仅作学术与工程范式的来源标注，MIT 许可仅针对 UFO 自身代码，不构成本仓库对其代码的再分发。

## 6. 本轮实跑留痕（V0.05）

**判定**：本条消息「GitHub 仓库：… 官方文档：… 嫁接进去」属**下任务 + 转换 + 迭代升级**的任务型，未命中禁止优化清单 → 执行第一步优化。注意本轮**不属于网页 PPT 路由域**（第三步路由表不适用），按主文件第三步的说明走自主实现路径，并把这条判定写进留痕。

### 精简通用版

```
角色：AI 技能架构师。把微软 UFO²/UFO³ 的桌面 Agent 编排范式（两层分工、混合 GUI–API、持续知识底座、DAG 任务图）转译为 cht-work-skill 的第四步执行编排规则，承接前三步决策；只借鉴方法论不集成代码，新增细则、升版本、推送开源仓库、同步全局技能。
```

### 高阶顶配版

```
# 角色
你是 AI 技能架构师，熟悉 Agent Skill 规范、多 Agent 编排与 Git 协作。

# 上下文
公开仓库 cuohuatang/cht-work-skill 当前为 V0.04，已具备三步决策链：
提示词优化（含禁止优化硬约束）→ find-skills 检索复用 → 网页 PPT 双路线选路。
现引入两个新来源：GitHub microsoft/UFO 与 UFO² 官方文档 overview 页。

# 任务拆解
1. 抓取两个来源，提炼 UFO / UFO² / UFO³ 的架构术语与五大创新，一字不改保留来源链接。
2. 判断与现有技能的契合点：前三步缺「执行章法」，故定位为第四步执行编排层。
3. 建立「UFO 概念 → 本技能可执行规则」转译表，逐条给可观测验收。
4. 写明诚实边界：不集成运行时、不复制代码、不引入 Windows 依赖、不改变 PPT 交付主体。
5. 同步主 SKILL.md、README、两份既有细则的衔接；升 V0.05、提交、推送公开仓库、同步全局技能目录、刷新交付包。

# 约束
- 目录名严格等于 SKILL.md 的 name 字段；含 name 与 description 两个元数据头字段。
- 元提示词原文、用户补充的边界约束原文、V0.04 禁止优化硬清单一字不改保留。
- 不把令牌写入仓库；推送后清除远端地址中的令牌；推送前做敏感信息扫描。
- 两条上游子技能目录内容不得改动。

# 输出规格
V0.05 版本号；新增 references/ufo-execution-paradigm.md；四处以上文件落点；
一条 feat(v0.05) 提交；仓库 public、分支 main；远端文件树可核验。

# 验收清单
主文件含第四步章节且顺序在第一/二/三步之后；转译表含 ≥10 行；
诚实边界含「不集成运行时」；来源链接一字保留；全局 grep 验证技能存在。

# 负面清单
禁止把 UFO 代码复制进仓库、禁止声称支持 Windows UIA/WinCOM、
禁止把 HTML 演示说成 pptx、禁止对禁止优化类输出两版模板、
禁止反问用户补充信息、禁止生成第三版提示词。
```

### 隐性需求补齐

| 项 | 补齐内容 | 依据 |
| --- | --- | --- |
| 角色设定 | AI 技能架构师 | 用户只说「嫁接进去」 |
| 目标受众 | 使用任意 Agent 的普通用户 | 元提示词「适配所有智能体」 |
| 风格约束 | 不废话、不闲聊、不凑字数 | 元提示词第三条 |
| 输出格式 | 两版提示词 + 结构化排版 + 转译表 | 元提示词第二、三条 |
| 验收标准 | 版本号、文件落点、提交推送、远端核验 | 历次迭代惯例 |
| 边界条件 | 只借鉴方法论、不集成运行时 | 两个来源技术栈与本技能无交集 |
| 范围限定 | 复合任务才上 DAG | V0.04「范围过宽」漏洞规避 |
| 交付格式 | HTML 网页演示，非 pptx | 仓库硬性前提 |

### 已规避的漏洞

- 目标冲突：「适配任何 AI」与「依赖 Windows UIA」冲突 → 诚实边界明确不引入平台专用技术。
- 循环依赖：优化提示词需先有提示词 → 元提示词原文内置。
- 不可验证形容词：「高级」「好用」→ 换成转译表的可观测验收列。
- 重复指令：前三步与第四步职责重叠 → 第四步只管执行编排，决策权仍归前三步。
- 越权假设：假定 UFO 运行时可安装 → 显式写成「不集成运行时」。
- 范围过宽：把所有任务都套进 DAG → 增加「适用范围」两档表。
- 张冠李戴：把 Windows 桌面自动化能力说成本技能能力 → 单列诚实边界章节。

### 第二步检索留痕

| 检索词 | 最高 score | ≥0.90 命中 | 判定 |
| --- | --- | --- | --- |
| 微软 UFO2 Desktop AgentOS HostAgent AppAgent 架构编排 知识沉淀 | 0.050 | 0 | < 0.60，自主实现 |
| UFO2 AgentOS hybrid GUI API task DAG orchestration skill | 0.050 | 0 | < 0.60，自主实现 |

结论：**无高相似现成技能**，按 V0.02 规则自主完成 V0.05 迭代。

### 第四步编排留痕（本轮自身也按新规则执行）

- 采集：并行抓取官方文档正文 + GitHub 仓库结构 + 星标 / 许可（10.2k / MIT）+ 本地仓库状态 + 令牌有效性（HTTP 200）。
- 决策：判定为任务型、非 PPT 路由域、无高相似技能 → 自主实现。
- 执行：文件改写与检索并行发出；主文件与新增细则、README、两份既有细则同批落地。
- 记忆更新：版本历史新增 V0.05 行、本节留痕、交付话术补第四条编排留痕要求。

## 7. V0.06 衔接补充（第五步反馈路由）

第五步「人在回路视觉反馈路由」接在四阶段闭环的**记忆更新之后**：交付成品 → 用户圈选批注 → 工具导出反馈 → Agent 读取 → 必要时回第一步重优化 → 第三步选路线 / 第四步执行修改 → 再交回工具复审。这条回路正是「持续知识底座」的落地——每次审改反馈都回写为版本历史与细则留痕。第五步四工具只做路由与接入说明，不引入任何运行时依赖，与本节「不集成 UFO 运行时」的边界口径一致。详见 `references/visual-feedback-routing.md`。
