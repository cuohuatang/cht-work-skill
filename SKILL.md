---
name: cht-work-skill
description: 把内容做成有动效、有设计感的单文件网页 PPT（HTML 演示文稿），并内置「先复用现成技能、后自主实现」的任务前置分流。合并了两个高星技能：有旧 PPT/PPTX 需要翻新时用 frontend-slides（提取文字、图片、备注，先出 3 张风格样稿供挑选，再生成整套 16:9 网页演示）；没有旧稿、要从零做时用 guizang-ppt-skill（杂志风讲故事 / 瑞士风讲数据，配色只能从预设里挑，自带演讲者模式、备注、计时、激光笔）。当用户要做 PPT、网页 PPT、HTML 幻灯片、发布会演示、把 PPTX 转成网页、改旧 PPT、提到杂志风 PPT / 瑞士风 PPT / Swiss Style / frontend-slides / guizang-ppt-skill 时使用；接到任务型请求时先按第零步分流，检索相似度≥0.90 的现成技能复用，闲聊与延续性对话不检索。注意：两条路线交付的都是 HTML，不是 pptx 文件；若用户明确要求交付 .pptx，先提醒格式冲突再决定是否继续。
---

# CHT Work Skill · 网页 PPT 二合一

> **版本：V0.02**（V0.01 为两技能合并版；V0.02 嫁接「先复用、后自造」的任务前置分流）

一个入口，两条路线。把内容做成浏览器直接放映、会动、不像 AI 模板的演示文稿。

> **硬性前提**：本技能两条路线产出的都是**单文件 HTML 网页演示**，不是 `.pptx`。
> 浏览器打开即可全屏演讲、翻页、分享链接，但 PowerPoint 里打不开、也交不了「发我 pptx」的差。
> 一旦用户明确说「领导要发 pptx」「要可编辑的 PPT 文件」，**先停下说明这个限制**，别闷头做完再返工。
> 可以给的替代方案：导出 PDF（静态，动画会丢）、或改用本地 Office 编辑链路生成 pptx。

## 第零步 · 任务前置分流（V0.02 新增，先复用后自造）

**先判断对话类型，别一上来就从零造车，也别什么都去搜。**

### 哪些对话不检索（直接回答或执行）

| 类型 | 例子 |
| --- | --- |
| 寒暄、致谢、闲聊、情绪表达 | 「早上好」「谢谢」「今天累死了」 |
| 纯事实问答 / 概念解释 / 翻译 / 摘要已有文本 | 「AGPL 和 MIT 差在哪」「这段话翻成英文」 |
| 延续性对话：确认、追问、澄清、对上一轮结果提修改意见 | 「继续」「换成蓝色」「你明白我意思吗」 |
| 用户已点名用哪个技能 / 哪份文件 / 哪个仓库 | 「用 cht-work-skill 做」「按这个 README 改」 |
| 只要判断、建议、审阅，不产出文件 | 「这个方案行不行」「帮我看看有没有坑」 |

### 哪些对话要检索（任务型：要生成 / 安装 / 修复 / 转换 / 推送 / 分析并产出文件）

1. **调用 find-skills 的语义检索**（SkillHub）：
   ```bash
   curl -s "https://lightmake.site/api/v1/search?q=<URL编码后的用户需求>&limit=10"
   ```
   中英文关键词各试一组，读 `results[].score`（0~1，越高越相关；低于 0.05 的结果直接忽略）。
2. **按阈值判定**：

   | score | 判定 | 动作 |
   | --- | --- | --- |
   | **≥ 0.90** | 高相似，现成技能可用 | **直接复用**：按 find-skills 的安装流程装好并调用，不自造、不重复造轮子 |
   | 0.60 ~ 0.90 | 相关但不确定 | 列出候选并说明差异，用户点名才用 |
   | **< 0.60** | 无现成技能 | 自主实现，并在说明里写明「已检索、无高相似技能」 |

3. **留痕**：在执行说明里记录「检索词 / 最高 score / 阈值判定」，便于追溯。

### 例外（避免重复检索）

用户已明确本任务落在网页 PPT 域时（「做 PPT」「改旧 PPT」），**本仓库的两条路线就是已匹配到的现成能力**，直接进第一步选路线，不必为同一需求再搜一遍。只有当任务里冒出**新的任务域**（例如顺带要推送 GitHub、生成配图、写测试用例）时，才对那个新任务域单独检索一次。

### 前置依赖

`find-skills`（`name: find-skills`）需全局安装；缺失时先按项目规范装到 `~/.codebuddy/skills/find-skills/` 再执行本步骤。细则见 `references/skill-first-workflow.md`。

> V0.02 实测留痕：检索「技能发现 优先搜索现成 skill 复用」与「github push create repository skill」，两组最高 score 均为 **0.050**，低于 0.60，判定「无高相似现成技能」，因此本轮自主完成 V0.02 迭代。

## 第一步：选路线（必做，别猜）

| 用户手上有什么 | 走哪条 | 读哪份规范 |
| --- | --- | --- |
| 有**旧 PPT / PPTX**，想保留内容换个高级皮 | 路线 A · 改旧稿 | `frontend-slides/SKILL.md` |
| **什么都没有**，只有一个主题 / 文章 / 想法 | 路线 B · 从零做 | `guizang-ppt-skill/SKILL.md` |
| 已有**网页 PPT 的 HTML**，想改文字 / 加图 / 拆页 | 路线 A（它支持修改既有 HTML deck） | `frontend-slides/SKILL.md` |
| 明确要 **.pptx 文件** | **两条都别用**，先讲清格式冲突 | — |

一句话记忆：**有旧的用第一个，没旧的用第二个，要 pptx 就先别用。**

## 通用执行规则

1. **选定路线后，完整读取对应子目录的 `SKILL.md`**，按它的流程走，不要用本文件的摘要代替原文规则。
2. **路径基准**：子技能内部的 `references/`、`assets/`、`scripts/`、`bold-template-pack/` 等引用都是**相对该子目录自身**的。执行时以 `frontend-slides/` 或 `guizang-ppt-skill/` 为基准解析，不要从本仓库根目录去拼路径。
3. **不要混用两套设计系统**：A 的风格预设 / 模板包与 B 的杂志 / 瑞士版式互不通用。选了 B 就只用 B 的 `assets/template*.html` 和 `references/`。
4. **先给可看的样稿再批量生成**：路线 A 必须先出 3 张标题页预览让用户挑；路线 B 必须先让用户确认风格（A 杂志风 / B 瑞士风），再生成整套。
5. **配色不许自由发挥**：路线 B 只能从预设主题里选（Style A 5 套电子墨水、Style B 4 套锚点色，如 IKB 克莱因蓝、柠檬黄、柠檬绿、安全橙）；路线 A 明确禁用紫色渐变 + 白底这类 AI 味审美。
6. **交付前自检**：浏览器打开逐页翻，检查文字溢出、元素重叠、16:9 画布、图片是否带齐、动画是否可用、是否需要 `prefers-reduced-motion`。

## 路线 A · frontend-slides（改旧 PPT / 从主题起步）

来源：<https://github.com/zarazhangrui/frontend-slides>（MIT，约 30k stars）

适合：手上有旧 PPTX、发布会 / 产品 / 课程 / 提案、想要动效和视觉自由度。

- **旧稿转换**：`scripts/extract-pptx.py` 提取每页文字、图片、演讲者备注 → 先展示「标题 / 内容摘要 / 图片数量」清单等用户确认 → 保留页序和素材，重新设计成网页演示。这是「提取内容后重做」，不是把 PPT 版式对象原样搬过来，也**不会输出新的可编辑 PPTX**。
- **先选风格再生成**：生成 3 份可直接打开的 HTML 标题页预览（用真实标题和素材，不写「方案 A」字样），用户挑一张或指定混搭。风格索引见 `STYLE_PRESETS.md` 与 `bold-template-pack/selection-index.json`；选中某套后**才**加载该套 `design.md`（渐进式加载）。
- **固定 16:9 舞台**：每页按 1920×1080 画布制作，整页等比缩放到窗口，手机上也**不重排**。
- **单文件输出**：CSS/JS 内联，零依赖；方向键 / 空格 / 滚轮 / 触控翻页，按 `E` 进入文字编辑、`Ctrl+S` 保存。
- 附加能力：`scripts/deploy.sh` 部署 Vercel 分享链接、`scripts/export-pdf.sh` 导出 PDF（需 Node.js + Playwright，PDF 为逐页截图、无动画）；转换 PPTX 需 Python + `python-pptx`。
- 规范细节：`html-template.md`（结构）、`animation-patterns.md`（动效）、`viewport-base.css`（舞台基准）。

## 路线 B · guizang-ppt-skill（从零做 / 上台演讲）

来源：<https://github.com/op7418/guizang-ppt-skill>（AGPL-3.0，约 29k stars）
作者把自己线下演讲踩过的坑都写进了 `references/checklist.md`，生成前务必读。

适合：观点鲜明的分享、行业 keynote、AI 产品发布、demo day；**不适合**密集表格、长篇培训课件、多人协作编辑。

- **两种风格，只能选一种**：
  - **Style A · 电子杂志 × 电子墨水**：衬线标题 + 流体背景 + 暖色，像 Monocle 贴了代码，**讲故事、谈观点**用。10 种布局，模板 `assets/template.html`，主题 `references/themes.md`，版式 `references/layouts.md`。
  - **Style B · 瑞士国际主义**：网格至上、单一高饱和锚点色、直角、发丝线、极致字号对比，**讲数据、讲产品、讲方法论**用。22 种锁定版式，模板 `assets/template-swiss.html`，主题 `references/themes-swiss.md`，版式 `references/layouts-swiss.md`，锁定规则 `references/swiss-layout-lock.md`。
- **颜色不许随便改**：从预设主题里挑；给品牌色时按 `scripts/gz-theme.mjs` 的色彩科学生成受约束的品牌主题，不要手调。
- **演讲者模式**（右下角按 `P`）：双窗口观众屏、当前页 / 下一页 16:9 预览、演讲备注、计时排练、自动翻页、激光笔、圈选、现场故障恢复，全部本地 HTML、不联网。规范见 `references/presenter-mode.md`。
- **翻页与兜底**：左右方向键 / 滚轮 / 触屏滑动 / 底部圆点 / `ESC` 索引；按 `B` 关闭 WebGL / canvas 动画退回静态，照顾老旧电脑。
- **配图与封面**：`references/image-prompts.md` 出图提示词、`references/screenshot-framing.md` 截图再设计；同一套视觉规则可产出公众号 21:9 头图、1:1 分享卡、小红书 3:4 封面等。
- **质量校验**：`scripts/validate-swiss-deck.mjs`（版式漂移、图片槽位、标题对齐、危险 SVG）、`scripts/validate-presenter-mode.mjs`、`scripts/check-presenter-runtime-sync.mjs`；有条件时用 Playwright 后验测量超出、底部空白、nav 安全线、标题间距。
- 组件参考：`references/components.md`、`references/gz-components.md`、`references/swiss-map-component.md`。

## 交付话术模板

做完告诉用户三件事，别只丢一个文件：

1. 成品路径（HTML，浏览器双击即可放映）和翻页 / 演讲者模式按键。
2. 用了哪条路线、哪种风格、多少页、素材是否完整保留；若走过第零步，附「检索词 / 最高 score / 阈值判定」。
3. **再提醒一次**：这是网页演示不是 pptx；需要附件可导出 PDF（动画会丢），需要可编辑 PPTX 得换工作流。

## 版本历史

| 版本 | 变更 |
| --- | --- |
| V0.01 | 合并 `frontend-slides`（MIT）与 `guizang-ppt-skill`（AGPL-3.0），建立双路线路由与 pptx 格式冲突提醒 |
| **V0.02** | 嫁接「任务前置分流」：任务型请求先用 find-skills 语义检索，`score ≥ 0.90` 直接复用现成技能；明确列出不检索的对话类型与例外，避免重复造轮子也避免无差别检索；新增 `references/skill-first-workflow.md` 细则 |

## 来源与许可

本仓库是聚合分发，不重新授权上游代码：

| 子目录 | 上游仓库 | 许可 |
| --- | --- | --- |
| `frontend-slides/` | <https://github.com/zarazhangrui/frontend-slides> | MIT（见 `frontend-slides/LICENSE`） |
| `guizang-ppt-skill/` | <https://github.com/op7418/guizang-ppt-skill> | AGPL-3.0（见 `guizang-ppt-skill/LICENSE`） |

使用、修改、再分发 `guizang-ppt-skill/` 部分时须遵守 AGPL-3.0 的对应义务（含源码开放要求）。各子目录内的 README、SPONSORS、来源说明均原样保留。
