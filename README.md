# cht-work-skill

> **当前版本：V0.10** ｜ V0.01 合并两技能 → V0.02 嫁接「先复用后自造」→ V0.03 把「提示词优化」前置为第一步 → V0.04 把「禁止优化」升级为硬约束 → V0.05 嫁接微软 UFO² / UFO³ 执行编排范式作为第四步 → V0.06 嫁接「人在回路视觉反馈工具路由」作为第五步（Pinta / Inspecto / human-review / EditHere）→ V0.07 在第三步加入「低置信度分叉让用户选」→ V0.08 在第四步嫁接 Ponytail 七级代码最小化阶梯 → V0.09 在最上游加入可选「素材工作台」：腾讯 WeKnora 把散落多格式素材整理成可检索、带引用的知识 → **V0.10 把每项能力封装成 12 个中文快捷按钮，随仓库分发、一键安装、支持项目速记，不用记英文 / 不用先打开技能**。

> **形态说明**：本技能**保持 Skill 形态，不改成 MCP**。它是决策 / 编排层，MCP 是工具 / 能力层，两者是上下游；四工具形态不统一，无一要求本技能转型。理由见文末与 `references/visual-feedback-routing.md` 第 6 节。

把两个高星网页 PPT 技能合并成一个入口：**有旧 PPT 就翻新，没旧 PPT 就从零做**。现在还顺手解决另外两个问题：**不会写提示词也能让 AI 干活，但不是所有输入都要优化提示词**；以及**选定方案之后怎么把活可靠地干完**（第四步执行编排）。

## 快捷按钮（V0.10 · 12 个中文 slash commands）

每项能力一个按钮，**敲按钮即触发，不用记英文、不用先手动打开技能**。完整清单、适用边界、安装排错见 `references/quick-commands.md`。

| 类别 | 按钮 | 对应能力 |
| --- | --- | --- |
| 总入口 | `/ppt` · `/改` · `/fix` | 六步全流程 / 统一选择框（含速记）/ 英文保底 |
| 两路线 | `/改旧PPT` · `/从零做` | frontend-slides 翻新 / guizang-ppt-skill 从零做 |
| 前段 | `/理素材` · `/优化提示词` · `/找技能` | WeKnora / 提示词架构师 / find-skills |
| 反馈四工具 | `/改网页` · `/跳源码` · `/改文档` · `/改画面` | Pinta / Inspecto / human-review / EditHere |

**安装**：仓库根目录 `bash scripts/install-commands.sh` → 装到 `~/.codebuddy/commands/` → 会话执行 `/reload-plugins` 生效。

**项目速记**：`/改 报价器按钮改成蓝色`——首次报一次项目路径，之后只说项目名即直达、跳过选择框；记录存 `~/.codebuddy/command-projects.md`（模板 `commands/项目速记-示例.md`）。

**三条铁律**：① 按钮即入口，命令内含技能调用，没有"先打开技能"这一步；② 按钮不拆技能，本体与两个子技能完整保留；③ 中文名不被客户端识别时用 `/fix`。

## 完整流程（第一步就是优化提示词，但先过硬约束）

```
用户消息
   ↓
第零步 · 素材工作台（V0.09，可选）
   素材散落多格式（PDF/Word/网页/飞书/Notion）→ 可选 WeKnora 整理成可检索、带引用的知识
   单一素材直接用路线脚本，不部署 / 不内置 / 不要求安装
   ↓
执行前判定 · 禁止优化清单（硬约束）
   命中 → 禁止优化、禁止输出两版模板、禁止检索 → 直接回应 / 直接执行【结束】
   未命中且属任务型 ↓
第一步 · 提示词优化
   元提示词 → 精简通用版 + 高阶顶配版
   补齐隐性需求 ｜ 结构化排版 ｜ 适配所有智能体 ｜ 规避逻辑漏洞
   ↓ 优化后的提示词 = 后续步骤唯一输入
第二步 · 技能检索（find-skills）
   最高 score ≥ 0.90 直接复用 ｜ 0.60~0.90 列候选 ｜ < 0.60 自主实现
   ↓
第三步 · 选路线
   有旧 PPT → frontend-slides ｜ 无 → guizang-ppt-skill ｜ 要 .pptx → 停下说明冲突
   低置信度/两路都行/用户拿不准 → 分叉 2~3 个选项让用户选
     （每个选项强制写「选它会得到什么」+ 标推荐项，不选就走推荐）
   ↓
第四步 · 执行编排（V0.05 UFO²/UFO³ + V0.08 Ponytail）
   UFO：两层分工 ｜ 脚本/API 优先、界面兜底 ｜ 批量并行 ｜ 复合任务 DAG
   Ponytail 七级代码阶梯：要不要存在 → 代码库 → 标准库 → 平台原生 → 现有依赖 → 一行 → 才写最小实现
   （校验/安全/可访问性不砍 ｜ 与第二步技能复用构成两级防重造轮子）
   ↓ 四阶段闭环：采集 → 决策 → 执行 → 记忆更新（留痕回写）
第五步 · 人在回路视觉反馈路由（V0.06，可选）
   前端源码 → Pinta ｜ 进阶跳行/时间线 → Inspecto
   网页/PPT/Word/图片文档 → human-review ｜ 一切画面 → EditHere
```

前三步解决「做什么、用什么、走哪条」，第四步解决「怎么把它可靠地干完、干完怎么沉淀」，第五步解决「做完后怎么让人圈一下就能改」。

## V0.07 新增：第三步中间分叉（低置信度让用户选）

**一句话原则：分叉是给模糊地带的选项，不是给用户的问卷。** 判定明确就直达，只有真模糊才弹选项。

| 触发分叉（满足任一） | 不分叉（保持直达） |
| --- | --- |
| 两条路线都站得住（有旧稿却想换风格 / 无稿但有参考素材） | 判定明确（旧稿翻新 / 纯从零 / 已有 HTML 要改 / 要 .pptx） |
| 需求描述模糊、置信度低 | 命中禁止优化清单（延续性修改 / 已点名技能或文件等） |
| 用户明说「给我几个方向 / 我拿不准」 | 单一明确交付物 |
| 跨类型需求（网页 PPT + 配套文档） | — |

**每个分叉选项必填四字段**：选项名 ｜ **选它会得到什么（产出物 / 风格 / 适合谁，禁写「更高级」这类形容词）** ｜ 推荐标记（附一句为什么）｜ 兜底（用户不选就走推荐项，绝不停下等）。分叉不改变禁止优化判定：延续性修改即使分叉定位「这里」，也不生成两版提示词。完整规范、标准输出骨架与实跑留痕见 `references/decision-fork.md`。

> V0.07 实测留痕：本条为延续性修改 + 点名对象，命中禁止优化硬约束，且属自迭代工程任务（不在网页 PPT 路由域）→ 未生成两版提示词、未走技能检索、本轮自身不触发分叉，直接落地文件；无高相似现成技能可复用。

## V0.09 新增：第零步素材工作台（可选，嫁接 WeKnora）

来源 <https://github.com/Tencent/WeKnora>（腾讯微信团队开源，约 3.8 万星；截图流传的「2.6 万」是旧数据）。它把原始文档变成「可查询 RAG + 自主 Agent + 自维护 Wiki」，本技能只在**素材散落多格式**时把它当可选上游工作台，与两条 PPT 路线正交，不新增路线。

**启用**：多格式混合（PDF / 扫描件 OCR / Office / 网页 / 图片）/ 散落多平台（飞书 / Notion / 语雀 / Confluence 等）/ 要先理大纲找依据 / 要带引用核实数据 / 素材量大。**不启用**：单一旧 PPTX、一份文章、明确主题（路线脚本更快）、纯判断问答、命中禁止优化清单。

能力：多格式解析 + 混合检索（向量 + BM25 + Rerank + 可选知识图谱）+ 带引用回答 + 切片可编辑/diff/回滚 + 自动 Wiki + 内置 MCP Server。**边界**：不部署、不内置运行时、不要求用户安装（Go+Vue+docreader+PG/ES/Redis 重型系统，Lite 才是单二进制）；有实例才用，没有走本地脚本，不阻塞主流程。

> ⚠️ **许可口径**：官方 LICENSE 原文「主体 MIT，列出的第三方组件保留各自许可」，GitHub API 因此标记 `NOASSERTION`——别说成纯 MIT。星数以 GitHub API 实测约 3.8 万为准。细节见 `references/weknora-knowledge-workbench.md`。

> V0.09 实测留痕：本条属任务型（下任务 + 嫁接 + 迭代升级），未命中禁止清单，**不属于网页 PPT 路由域**；两组检索最高 score 均 0.050（< 0.60），无高相似现成技能，故自主实现。

## V0.08 新增：第四步代码最小化阶梯（嫁接 Ponytail）

来源 <https://github.com/DietrichGebert/ponytail>（MIT，约 19.4 万星，本质是一份 prompt skill）。UFO 管「怎么把活组织完」，Ponytail 管「写代码时怎么不重复造轮子、不过度工程」。它和第二步 find-skills 是同一精神的两个层次：**第二步复用现成技能（技能层），Ponytail 复用代码库 / 标准库 / 平台原生 / 现有依赖（代码层）**。

**七级阶梯（写 / 改 HTML·CSS·JS 前逐级判断，命中即停）**：① 需要存在吗（不需要→不写）→ ② 代码库有吗（复用）→ ③ 标准库能吗 → ④ 平台原生能吗 → ⑤ 已装依赖有吗 → ⑥ 能一行吗 → ⑦ 才写最小实现 + 小测试。**不可砍**：校验 / 数据安全 / 错误处理 / 可访问性；带分支·循环·金额·安全的逻辑留一个小测试，交付结尾说明跳过与风险。默认取 `full` 精神，不要求用户装插件、不引入命令系统（会破坏「不挑 Agent」）。

> ⚠️ **数据口径纠正**：官方 v5 基准为**代码 -53% / Token -45% / 成本 -26% / 时间 -27%，风险逻辑带测试率 98%（无 skill 68%）**。网传「Token 降 94%」是把个别重造轮子任务的**代码量峰值降幅**误当成 Token 平均降幅，务必别这样转述。只借鉴方法论，未复制代码 / 未引入钩子命令；细节见 `references/ponytail-minimal-code.md`。

> V0.08 实测留痕：本条属任务型（下任务 + 嫁接 + 迭代升级），未命中禁止清单，**不属于网页 PPT 路由域**；两组检索最高 score 均 0.050（< 0.60），无高相似现成技能，故自主实现。

## V0.06 新增：第五步人在回路视觉反馈路由

**只在用户要审改 / 走查 / 圈选反馈时启用**，不装下列工具不影响 PPT 主流程。

| 改什么 | 用什么 | 形态与要点 |
| --- | --- | --- |
| 前端源码 / 网页 UI（点选 + 写人话 + Agent 改源码） | **Pinta（主力）** | Chrome 扩展 + `pinta-companion`（127.0.0.1:7878）+ MCP；`Alt+S` 圈选 → 批注 → Send to agent；零框架侵入、localhost 私有、不挑 Agent |
| 前端 + 跳源码行 / 任务时间线 / 自定义工作流 | **Inspecto（进阶补位）** | `Alt+点击` 跳行、session 时间线（领取/处理/完成/忽略）、`prompts.json` 自定义按钮；只在需要这三项时才上 |
| 网页 / PPT / Word / 图片文档逐段审改 | **human-review** | MIT Skill；`npx -y human-review <file|localhost>` 浏览器直接改字圈选，一次 Send 回传；Markdown 改动由 Agent 应用回源文件 |
| 一切画面（截图 / AI 生图 / 视频 / 游戏 HUD / 桌面 UI） | **EditHere** | MIT 桌面应用 + companion skill；原图保留，编号批注 + 坐标 + 布局变化进 JSON；不绑模型不绑 DOM |

**三条硬规则**：

1. **文档类不走 Pinta / Inspecto** —— 它俩只处理前端 DOM / 组件；PPT / Word / Markdown / 图片一律走 human-review 或 EditHere。
2. **Pinta 不是 GTK 画图软件** —— 此处指网页批注工具（`pinta-companion` / `pinta-mcp`），不是 `PintaProject/Pinta`。
3. **主力 / 进阶分明** —— 默认 Pinta，只有明确要跳源码行 / 时间线 / 自定义工作流才升级 Inspecto。

> **MCP 判定**：原 cht-work-skill **不改成 MCP**。它是决策 / 编排层（六步工作流），MCP 是工具 / 能力层，二者上下游而非替代；Pinta/Inspecto 自带 MCP server、human-review 本身是 Skill、EditHere 是桌面应用，四者形态不统一，无一要求调用方转型；改成 MCP 还会丢掉「不挑 Agent」的跨智能体适配。路由表完整接入命令、闭环方式、MCP 判定四条依据见 `references/visual-feedback-routing.md`。

> V0.06 实测留痕：本条属任务型（下任务 + 转换 + 迭代升级），未命中禁止清单，且**不属于网页 PPT 路由域**；两组检索最高 score 均 0.050（< 0.60），无高相似现成技能，故自主完成迭代。

## V0.05 新增：第四步执行编排（嫁接微软 UFO 系列）

来源（链接一字不改）：

- GitHub 仓库：<https://github.com/microsoft/UFO>（MIT，约 10.2k stars）
- UFO² 官方文档：<https://microsoft.github.io/UFO/ufo2/overview/>

UFO 三代：UFO（2024-02，Windows GUI Agent）→ **UFO²**（2025-04，Desktop AgentOS，LTS）→ **UFO³ Galaxy**（2025-11，多设备 DAG 编排）。UFO² 的核心是两层 Agent 层级 + 五大创新；UFO³ 把顺序 ReAct 换成声明式 DAG（TaskStar / TaskConstellation）。

| UFO 概念 | 转译成本技能的规则 |
| --- | --- |
| HostAgent（WHAT/WHEN） | 主 `SKILL.md` 作编排层：优化 → 检索 → 选路线 → 拆子任务，不亲自逐页排版 |
| AppAgent（HOW/WHERE） | 子技能 / `scripts/` / 命令行作执行层：一次只做一个明确子任务，做完回报 |
| Blackboard（共享上下文） | 第一步的高阶顶配版提示词 = 全流程唯一共享上下文 |
| 混合 GUI–API（原生 API 优先） | `scripts/*.py`、`*.mjs`、`git`、`curl` 优先；界面点击只在无接口时兜底 |
| 推测式多动作（官方称减少 51% LLM 调用） | 无依赖调用并行发出；批量前做轻量状态校验，失效退回逐步执行 |
| 持续知识底座（帮助文档 / 实时检索 / 执行历史） | 子技能 `references/` + find-skills 与官方文档 + **版本历史与历次留痕** |
| 四阶段流水线 | 采集 → 决策（前三步）→ 执行（本步）→ 记忆更新（留痕回写） |
| UFO³ DAG（TaskStar） | 复合任务拆有依赖节点：无依赖并行、有依赖按序；结果变化只重算受影响分支 |
| 状态机 + 错误恢复 | 失败回到上一个确定状态重试，不静默跳过、不假装成功 |

**不是所有任务都上重型编排**：单一交付物、一步能做完（翻译、改色、生成一页、纯问答）直接执行；只有多交付物 / 跨工具 / 有依赖顺序的复合任务才启用任务图与并行编排。

> ⚠️ **诚实边界**：只借鉴架构范式与工程原则，**不集成 UFO 运行时、不复制其代码、不引入 Windows / UIA / Win32 / WinCOM / OmniParser / MCP server 依赖**。UFO 是 Windows 桌面自动化框架，本技能是网页演示文稿工作流，技术栈无交集；两条 PPT 路线仍是唯一交付主体。完整转译表、术语对照、适用范围与本轮实跑留痕见 `references/ufo-execution-paradigm.md`。

> V0.05 实测留痕：本条消息属任务型（下任务 + 转换 + 迭代升级），未命中禁止清单，且**不属于网页 PPT 路由域**（第三步路由表不适用，按主文件说明走自主实现）；执行第一步优化成两版；两组检索最高 score 均为 0.050（< 0.60），判定无高相似现成技能，故自主完成 V0.05 迭代。

## V0.04：禁止优化清单（硬约束）

**不是所有输入都要优化提示词，有些是禁止优化的。** 命中任一项，禁止输出「精简通用版 / 高阶顶配版」等任何优化产物，直接干活。

| 禁止优化类 | 例子 |
| --- | --- |
| 寒暄致谢、闲聊、情绪表达 | 「早上好」「谢谢」 |
| 纯事实问答 / 翻译 / 摘要 | 「AGPL 和 MIT 差在哪」「把这段文字缩成 200 字」 |
| 延续性修改 | 「继续」「换成蓝色」「再补一页」 |
| **用户已点名技能或文件** | 「用 cht-work-skill 做」「按这个 README 改」 |
| 只要判断，不要产出 | 「这个方案行不行」 |

**任务型（必须优化）**：下任务、归纳总结、生成、安装、修复、转换、推送、产出文件等**重要任务**。

容易混淆的边界：**纯摘要 ≠ 归纳总结**。把给定文本缩短、不产出新结论 → 禁止优化；对一组材料做结构化归纳、产出结论 / 报告 / 文件 → 任务型，要优化。判定顺序固定为「先查禁止清单（命中即停）→ 再看是否任务型 → 其余直接回应」，不可颠倒。

用户补充的边界约束原文已一字不改存入 `references/prompt-architect.md`。

## V0.03：第一步优化提示词

**元提示词原文**（可直接复制给任何 AI）：

```
你现在是顶级的AI提示词架构师，我接下来只告诉你使用场景和用途。你要自动完成四件事。一、补齐我没说出口的隐性需求，自动加上角色设定、风格约束、输出格式。二、出两个版本，精简通用版和高阶顶配版。三、用清晰的结构化排版，不废话，不闲聊，不凑字数。四、自动适配ChatGPT、claudecode、豆包、deepseek harness.kimi等等所有AGENT智能体，规避逻辑漏洞和无效指令。
```

| 原文要求 | 落地规则 |
| --- | --- |
| 补齐隐性需求 | 角色设定、目标受众、风格约束、输出格式、验收标准、边界条件；缺失按保守默认值并标注假设，不反问 |
| 出两个版本 | 精简通用版（≤120 字、单段可复制）+ 高阶顶配版（分段结构化，含约束 / 验收 / 负面清单） |
| 结构化排版 | Markdown 标题 + 列表 + 表格；无寒暄、无铺垫、无凑字数复述 |
| 适配所有智能体 | ChatGPT / Claude Code / 豆包 / DeepSeek / Kimi / harness 类；平台中立语法；逐条排查目标冲突、循环依赖、不可验证形容词、重复指令、越权假设、**范围过宽** |

优化后的提示词作为**后续所有步骤的唯一输入**：第二步取关键词、第三步定素材与格式、第四步拆任务图，都不用原始口语需求。细则、两版模板、适配矩阵、漏洞清单与历次实跑留痕见 `references/prompt-architect.md`。

## V0.02：第二步任务前置分流

接到**任务型请求**时，用第一步产出的高阶顶配版做 find-skills 语义检索，按相似度决定复用还是自造；命中禁止优化清单时本步骤一并跳过。

| 禁止优化 + 不检索 | 要优化 + 检索 |
| --- | --- |
| 寒暄致谢、闲聊 | 下任务、归纳总结 |
| 纯事实问答 / 翻译 / 摘要 | 生成 PPT / 网页 / 文件 |
| 「继续」「换成蓝色」等延续性修改 | 安装技能、修复、转换格式 |
| 用户已点名技能或文件 | 推送仓库、产出报告 |
| 只要判断、建议、审阅 | 冒出的新任务域（单独检索） |

| score | 判定 | 动作 |
| --- | --- | --- |
| ≥ 0.90 | 高相似 | **直接复用**，不自造 |
| 0.60 ~ 0.90 | 相关但不确定 | 列候选，用户点名才用 |
| < 0.60 | 无现成技能 | 自主实现，写明「已检索、无高相似技能」 |

已明确落在网页 PPT 域时，本仓库 A / B 两条路线就是现成能力，直接进入第三步，不重复检索。细则见 `references/skill-first-workflow.md`，前置依赖 `find-skills` 需全局安装：

```bash
grep -rl "^name: find-skills" ~/.codebuddy/skills/*/SKILL.md
```

## 两条路线对比

| | 路线 A · frontend-slides | 路线 B · guizang-ppt-skill |
| --- | --- | --- |
| 上游仓库 | <https://github.com/zarazhangrui/frontend-slides> | <https://github.com/op7418/guizang-ppt-skill> |
| 星标 | 约 30.3k | 约 28.9k |
| 解决什么 | 旧 PPTX 提取文字 / 图片 / 备注，重做成会动的网页演示 | 从一句话 / 一篇文章做出能上台讲的网页 PPT |
| 风格机制 | 先出 3 张标题页样稿让你挑，12 套基础 + 34 套扩展设计 | 二选一：杂志风（叙事）/ 瑞士风（数据），配色只能从预设挑 |
| 拿手好戏 | 动效、视觉自由度、固定 16:9 舞台、单文件零依赖 | 演讲者模式（备注 / 计时 / 激光笔 / 双窗口）、锁定版式、质量校验 |
| 许可 | MIT | AGPL-3.0 |

> ⚠️ **两条路线产出的都是单文件 HTML 网页演示，不是 `.pptx` 文件。**
> 电脑浏览器打开就能讲，但要交付可编辑 PPTX 时请先别用 —— 这是最常见的返工点。

## 怎么选（第三步）

```
有旧 PPT / PPTX 想换皮？ ── 是 ──▶ frontend-slides/
        │                              （也能改已有的 HTML deck）
        否
        ▼
只有主题 / 文章 / 想法？  ── 是 ──▶ guizang-ppt-skill/
        │                              （杂志风讲故事 / 瑞士风讲数据）
        否
        ▼
明确要 .pptx 文件？      ── 是 ──▶ 先停下，改用 Office/PPTX 工作流
```

技能自迭代、嫁接新能力、纯工程任务不属于这个路由域，无需强套 A / B 路线，把判定写进留痕即可。

## 安装

```bash
# 一行安装（Skills CLI）
npx skills add https://github.com/cuohuatang/cht-work-skill --skill cht-work-skill

# 或手动装到全局（对所有对话和项目生效）
git clone https://github.com/cuohuatang/cht-work-skill ~/.codebuddy/skills/cht-work-skill

# 验证
grep -rl "^name: cht-work-skill" ~/.codebuddy/skills/*/SKILL.md
```

安装后直接说需求即可：**任务型请求会自动优化提示词**，寒暄、翻译、延续性修改等命中禁止清单的输入会直接执行，不会硬套两版模板。

- 「把这份 Q3 复盘.pptx 重做成网页 PPT，先给我 3 个风格样稿」
- 「基于这篇文章做一份瑞士风 PPT，7 页左右，带演讲者备注」
- 「把这份 Markdown 做成杂志风演讲 PPT，再出一张公众号 21:9 头图」

## 目录结构

```
cht-work-skill/
├── SKILL.md                      # 主入口：禁止优化硬约束 + 五步流程 + 两条路线要点
├── README.md                     # 本文件
├── references/
│   ├── prompt-architect.md       # 第一步细则：元提示词原文、禁止优化清单、两版模板、漏洞清单
│   ├── skill-first-workflow.md   # 第二步细则：对话分类、阈值判定、留痕格式
│   ├── ufo-execution-paradigm.md # 第四步细则（V0.05）：UFO²/UFO³ 术语、转译表、诚实边界、实跑留痕
│   ├── visual-feedback-routing.md# 第五步细则（V0.06）：Pinta/Inspecto/human-review/EditHere 路由、接入命令、MCP 判定
│   ├── decision-fork.md         # 第三步细则（V0.07）：分叉触发条件、呈现规范、选它会得到什么、兜底
│   ├── ponytail-minimal-code.md # 第四步细则（V0.08）：七级阶梯、两级防重造、四档模式、诚实数据口径
│   ├── weknora-knowledge-workbench.md # 第零步细则（V0.09）：素材工作台启用判定、能力对照、边界与许可口径
│   └── quick-commands.md         # 按钮细则（V0.10）：12 按钮清单、适用边界、安装排错、项目速记
├── commands/                     # 12 个中文快捷按钮（V0.10，slash commands，随仓库分发）
│   ├── ppt.md / 改.md / fix.md           # 总入口
│   ├── 改旧PPT.md / 从零做.md             # PPT 两路线
│   ├── 理素材.md / 优化提示词.md / 找技能.md # 前段能力
│   ├── 改网页.md / 跳源码.md / 改文档.md / 改画面.md # 反馈四工具
│   └── 项目速记-示例.md           # 项目速记表模板（安装时跳过）
├── scripts/
│   └── install-commands.sh       # 一键把 12 按钮装到 ~/.codebuddy/commands/
├── frontend-slides/              # 上游完整副本（MIT）
│   ├── SKILL.md
│   ├── STYLE_PRESETS.md
│   ├── html-template.md
│   ├── animation-patterns.md
│   ├── viewport-base.css
│   ├── bold-template-pack/       # 34 套扩展设计 + selection-index.json
│   ├── scripts/                  # extract-pptx.py / deploy.sh / export-pdf.sh
│   └── LICENSE
└── guizang-ppt-skill/            # 上游完整副本（AGPL-3.0）
    ├── SKILL.md
    ├── references/               # checklist / layouts / themes / presenter-mode 等
    ├── assets/                   # template.html / template-swiss.html / 背景图 / motion.min.js
    ├── scripts/                  # 瑞士风校验、演讲者模式校验、主题生成
    └── LICENSE
```

两个子技能的 `SKILL.md` 及其相对路径引用都保持原样，**执行时以各自子目录为路径基准**。UFO 相关只落一份 Markdown 范式笔记，**没有复制任何 UFO 代码**；第五步四个工具同样只记路由与官方接入方式，**未复制其代码、不内置其运行时**。

## 常见坑（都写进主 SKILL.md 了）

1. 交付格式：要 pptx 就别开工，先说明 HTML 的限制。
2. 别把所有输入都优化：命中禁止优化清单就禁止输出两版模板、直接执行。
3. 别拿口语需求直接检索或选路线：任务型先过第一步提示词优化。
4. 别让用户描述「高级大气」：路线 A 直接给 3 张样稿挑，路线 B 只让选杂志 / 瑞士。
5. 别自由调色：瑞士风只能挑预设锚点色（IKB 蓝 / 柠檬黄 / 柠檬绿 / 安全橙）；紫色渐变白底属于明确禁用的 AI 审美。
6. 别把两套模板混着用，子目录里的 `references/` 和 `assets/` 不通用。
7. 现场演讲前用演讲者模式排练一遍，按 `B` 可关掉 WebGL 动画兜底老旧设备。
8. 导出 PDF 是逐页截图，动画和编辑功能都会丢失。
9. 别把 UFO 当成本技能的能力：它只是第四步的编排范式来源，UIA / WinCOM / OmniParser 一个都没引入。
10. 别给一步能做完的活上 DAG：单一交付物直接执行，复合任务才拆任务图。
11. 别把 Pinta 当 GTK 画图软件：此处是网页批注工具（companion + MCP），`PintaProject/Pinta` 是同名不同物。
12. 别把文档类塞给前端工具：PPT / Word / Markdown / 图片走 human-review 或 EditHere，不走 Pinta / Inspecto。
13. 别为了「高级」把本技能改成 MCP：决策层与工具层是上下游，四工具形态也不统一。
14. 别逢事就分叉让用户选（V0.07）：只在判定模糊时弹选项，确定性高就直达；分叉选项必须写清「选它会得到什么」，别给「方案 A / 方案 B」这种选完还不知道拿到什么的东西。
15. 别把「精简」做成「阉割」（V0.08）：写代码前过七级阶梯，但校验 / 安全 / 可访问性 / 错误处理不砍；也别把「Token 降 94%」当事实转述——那是重造轮子任务的代码量峰值，官方 v5 是代码 -53% / Token -45%。
16. 别为做 PPT 去部署 WeKnora（V0.09）：素材单一就用路线脚本；它只是可选上游工作台，不内置、不强制安装；许可也别说成纯 MIT（主体 MIT + 第三方组件各自许可）。
17. 别以为要先「打开技能」再敲按钮（V0.10）：按钮本身就调用技能，敲 `/改` 即干活；按钮是入口、不是拆解，本体与两个子技能完整保留。
18. 别把中文命令名不显示当成坏了（V0.10）：客户端斜杠解析器可能不认中文名，用英文保底 `/fix`；新按钮需 `/reload-plugins` 才生效。

## 许可说明

本仓库为聚合分发，**不重新授权上游代码**：

| 来源 | 许可 | 引入方式 |
| --- | --- | --- |
| `frontend-slides/` | MIT | 完整副本，含 scripts / assets / references |
| `guizang-ppt-skill/` | AGPL-3.0 | 完整副本，含 scripts / assets / references；修改或再分发须遵守其对应义务（含源码开放要求） |
| <https://github.com/microsoft/UFO> · <https://microsoft.github.io/UFO/ufo2/overview/> | MIT | **仅方法论借鉴，未复制任何代码**，仅作范式来源标注 |
| Pinta（`pinta-companion` / `pinta-mcp`）· Inspecto · <https://github.com/petergyang/human-review>（MIT）· <https://github.com/Inginnng/EditHere>（MIT） | 见各上游 | **仅路由与官方接入命令说明，未复制代码、未内置运行时**；是否安装由用户决定 |
| <https://github.com/DietrichGebert/ponytail> | MIT | **仅方法论借鉴（七级代码最小化阶梯），未复制代码、未引入插件钩子命令**，详见 `references/ponytail-minimal-code.md` |
| <https://github.com/Tencent/WeKnora> · 文档 <https://weknora.weixin.qq.com/docs/01-getting-started/01-introduction> | 主体 MIT，第三方组件各自许可（官方 LICENSE；API 标记 NOASSERTION） | **仅能力路由说明，未部署、未内置运行时、未复制代码**，详见 `references/weknora-knowledge-workbench.md` |
| 12 个快捷按钮 `commands/*.md` + `scripts/install-commands.sh` | 本仓库原创 | 按钮是本技能能力的入口封装，**未引入外部代码 / 依赖**，详见 `references/quick-commands.md` |

各子目录内的 LICENSE、README、SPONSORS 与来源说明均原样保留。UFO 相关商标归微软所有。第五步四工具的商标与名称归各自作者所有，本仓库仅作工具路由的来源标注。
