# cht-work-skill

> **当前版本：V0.06** ｜ V0.01 合并两技能 → V0.02 嫁接「先复用后自造」→ V0.03 把「提示词优化」前置为第一步 → V0.04 把「禁止优化」升级为硬约束 → V0.05 嫁接微软 UFO² / UFO³ 执行编排范式作为第四步 → **V0.06 嫁接「人在回路视觉反馈工具路由」作为第五步（Pinta / Inspecto / human-review / EditHere）**。

> **形态说明**：本技能**保持 Skill 形态，不改成 MCP**。它是决策 / 编排层，MCP 是工具 / 能力层，两者是上下游；四工具形态不统一，无一要求本技能转型。理由见文末与 `references/visual-feedback-routing.md` 第 6 节。

把两个高星网页 PPT 技能合并成一个入口：**有旧 PPT 就翻新，没旧 PPT 就从零做**。现在还顺手解决另外两个问题：**不会写提示词也能让 AI 干活，但不是所有输入都要优化提示词**；以及**选定方案之后怎么把活可靠地干完**（第四步执行编排）。

## 完整流程（第一步就是优化提示词，但先过硬约束）

```
用户消息
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
   ↓
第四步 · 执行编排（V0.05 · UFO²/UFO³ 范式）
   两层分工 ｜ 脚本/API 优先、界面兜底 ｜ 批量并行动作 ｜ 复合任务 DAG
   ↓ 四阶段闭环：采集 → 决策 → 执行 → 记忆更新（留痕回写）
第五步 · 人在回路视觉反馈路由（V0.06，可选）
   前端源码 → Pinta ｜ 进阶跳行/时间线 → Inspecto
   网页/PPT/Word/图片文档 → human-review ｜ 一切画面 → EditHere
```

前三步解决「做什么、用什么、走哪条」，第四步解决「怎么把它可靠地干完、干完怎么沉淀」，第五步解决「做完后怎么让人圈一下就能改」。

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
│   └── visual-feedback-routing.md# 第五步细则（V0.06）：Pinta/Inspecto/human-review/EditHere 路由、接入命令、MCP 判定
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

## 许可说明

本仓库为聚合分发，**不重新授权上游代码**：

| 来源 | 许可 | 引入方式 |
| --- | --- | --- |
| `frontend-slides/` | MIT | 完整副本，含 scripts / assets / references |
| `guizang-ppt-skill/` | AGPL-3.0 | 完整副本，含 scripts / assets / references；修改或再分发须遵守其对应义务（含源码开放要求） |
| <https://github.com/microsoft/UFO> · <https://microsoft.github.io/UFO/ufo2/overview/> | MIT | **仅方法论借鉴，未复制任何代码**，仅作范式来源标注 |
| Pinta（`pinta-companion` / `pinta-mcp`）· Inspecto · <https://github.com/petergyang/human-review>（MIT）· <https://github.com/Inginnng/EditHere>（MIT） | 见各上游 | **仅路由与官方接入命令说明，未复制代码、未内置运行时**；是否安装由用户决定 |

各子目录内的 LICENSE、README、SPONSORS 与来源说明均原样保留。UFO 相关商标归微软所有。第五步四工具的商标与名称归各自作者所有，本仓库仅作工具路由的来源标注。
