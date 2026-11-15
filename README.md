# cht-work-skill

> **当前版本：V0.03** ｜ V0.01 合并两技能 → V0.02 嫁接「先复用后自造」→ **V0.03 把「提示词优化」前置为第一步**。

把两个高星网页 PPT 技能合并成一个入口：**有旧 PPT 就翻新，没旧 PPT 就从零做**。现在还顺手解决另一个问题：**不会写提示词也能让 AI 干活**。

## 完整流程（从左到右，第一步就是优化提示词）

```
用户消息 → 执行前判定（闲聊 / 纯问答 / 延续性对话 → 直接回应，跳过优化与检索）
   ↓ 任务型：生成 / 安装 / 修复 / 转换 / 推送 / 产出文件
第一步 · 提示词优化
   元提示词 → 精简通用版 + 高阶顶配版
   补齐隐性需求 ｜ 结构化排版 ｜ 适配所有智能体 ｜ 规避逻辑漏洞
   ↓ 优化后的提示词 = 后续步骤唯一输入
第二步 · 技能检索（find-skills）
   最高 score ≥ 0.90 直接复用 ｜ 0.60~0.90 列候选 ｜ < 0.60 自主实现
   ↓
第三步 · 选路线
   有旧 PPT → frontend-slides ｜ 无 → guizang-ppt-skill ｜ 要 .pptx → 停下说明冲突
```

## V0.03 新增：第一步优化提示词

**元提示词原文**（可直接复制给任何 AI）：

```
你现在是顶级的AI提示词架构师，我接下来只告诉你使用场景和用途。你要自动完成四件事。一、补齐我没说出口的隐性需求，自动加上角色设定、风格约束、输出格式。二、出两个版本，精简通用版和高阶顶配版。三、用清晰的结构化排版，不废话，不闲聊，不凑字数。四、自动适配ChatGPT、claudecode、豆包、deepseek harness.kimi等等所有AGENT智能体，规避逻辑漏洞和无效指令。
```

| 原文要求 | 落地规则 |
| --- | --- |
| 补齐隐性需求 | 角色设定、目标受众、风格约束、输出格式、验收标准、边界条件；缺失按保守默认值并标注假设，不反问 |
| 出两个版本 | 精简通用版（≤120 字、单段可复制）+ 高阶顶配版（分段结构化，含约束 / 验收 / 负面清单） |
| 结构化排版 | Markdown 标题 + 列表 + 表格；无寒暄、无铺垫、无凑字数复述 |
| 适配所有智能体 | ChatGPT / Claude Code / 豆包 / DeepSeek / Kimi / harness 类；平台中立语法；逐条排查目标冲突、循环依赖、不可验证形容词、重复指令、越权假设 |

细则、两版模板、适配矩阵、漏洞清单与实跑留痕见 `references/prompt-architect.md`。

> V0.03 实测留痕：先把口语需求优化成两版提示词，再用优化后的关键词检索，两组最高 score 均为 0.050（< 0.60），判定无高相似现成技能，故自主完成本次迭代。

## V0.02：第二步任务前置分流

接到**任务型请求**时，用第一步产出的高阶顶配版做 find-skills 语义检索，按相似度决定复用还是自造；**闲聊、纯问答、延续性对话不做优化也不检索**。

| 不优化 / 不检索 | 要优化 + 检索 |
| --- | --- |
| 寒暄、致谢、闲聊 | 生成 PPT / 网页 / 文件 |
| 事实问答、翻译、摘要已有文本 | 安装技能、修复、转换格式 |
| 「继续」「换成蓝色」等延续性修改 | 推送仓库、分析并产出报告 |
| 只要判断、建议、审阅 | 冒出的新任务域（单独检索） |

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

## 安装

```bash
# 一行安装（Skills CLI）
npx skills add https://github.com/cuohuatang/cht-work-skill --skill cht-work-skill

# 或手动装到全局（对所有对话和项目生效）
git clone https://github.com/cuohuatang/cht-work-skill ~/.codebuddy/skills/cht-work-skill

# 验证
grep -rl "^name: cht-work-skill" ~/.codebuddy/skills/*/SKILL.md
```

安装后直接说需求即可，不会写提示词也没关系，第一步会自动优化：

- 「把这份 Q3 复盘.pptx 重做成网页 PPT，先给我 3 个风格样稿」
- 「基于这篇文章做一份瑞士风 PPT，7 页左右，带演讲者备注」
- 「把这份 Markdown 做成杂志风演讲 PPT，再出一张公众号 21:9 头图」

## 目录结构

```
cht-work-skill/
├── SKILL.md                      # 主入口：执行前判定 + 三步流程 + 两条路线要点
├── README.md                     # 本文件
├── references/
│   ├── prompt-architect.md       # V0.03 第一步提示词优化细则（含元提示词原文）
│   └── skill-first-workflow.md   # V0.02 第二步任务前置分流细则
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

两个子技能的 `SKILL.md` 及其相对路径引用都保持原样，**执行时以各自子目录为路径基准**。

## 常见坑（都写进主 SKILL.md 了）

1. 交付格式：要 pptx 就别开工，先说明 HTML 的限制。
2. 别拿口语需求直接检索或选路线：先过第一步提示词优化。
3. 别让用户描述「高级大气」：路线 A 直接给 3 张样稿挑，路线 B 只让选杂志 / 瑞士。
4. 别自由调色：瑞士风只能挑预设锚点色（IKB 蓝 / 柠檬黄 / 柠檬绿 / 安全橙）；紫色渐变白底属于明确禁用的 AI 审美。
5. 别把两套模板混着用，子目录里的 `references/` 和 `assets/` 不通用。
6. 现场演讲前用演讲者模式排练一遍，按 `B` 可关掉 WebGL 动画兜底老旧设备。
7. 导出 PDF 是逐页截图，动画和编辑功能都会丢失。

## 许可说明

本仓库为聚合分发，**不重新授权上游代码**：`frontend-slides/` 为 MIT，`guizang-ppt-skill/` 为 AGPL-3.0。使用、修改或再分发 AGPL-3.0 部分时须遵守其对应义务（含源码开放要求）。各子目录内的 LICENSE、README、SPONSORS 与来源说明均原样保留。
