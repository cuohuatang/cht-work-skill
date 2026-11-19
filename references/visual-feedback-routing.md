# 人在回路视觉反馈工具路由细则（V0.06 嫁接，流程第五步）

配套主 `SKILL.md` 的「第五步 · 人在回路视觉反馈路由」。解决一个问题：**交付之后，让人用鼠标圈一下、画个框、写句人话，就能让 Agent 精准改到对的地方**，而不是在聊天框里打一大段「左上角那个按钮、不是这个、是下面那个」。

> 本步**可选**：只在用户要求审改 / 走查 / 圈选反馈 / 「改这里」时启用。不装任何下列工具，前四步与两条 PPT 路线照常工作。

## 0. 一句话结论

| 用户要改的东西 | 工具 | 为什么是它 |
| --- | --- | --- |
| 前端源码 / 网页 UI（点元素 + 说人话 + Agent 改源码） | **Pinta（主力）** | 零框架侵入、localhost 私有化、不挑 Agent，右侧栏点选 / 画圈 / 写批注 |
| 前端 + 跳源码行 / 任务时间线 / 自定义工作流 | **Inspecto（进阶）** | 前端工程化更舒服，有 Alt+点击跳行、session 时间线、prompts.json |
| 网页 / PPT / Word / 图片文档逐段审改 | **human-review** | 浏览器里直接改字、选中留言，一次批量回传，原位锚定 |
| 一切画面（截图 / AI 生图 / 视频 / 游戏 HUD / 桌面 UI） | **EditHere** | 不绑模型不绑 DOM，原图不覆盖，坐标 + 布局变化进 JSON |
| 都不是（纯逻辑、纯文字、无视觉对象） | 都不用 | 直接文字反馈 |

## 1. 命名避坑（最重要）

**Pinta 有两个同名工具，别搞混：**

| 名称 | 是什么 | 本技能用哪个 |
| --- | --- | --- |
| `PintaProject/Pinta` | GTK 绘图程序，Paint.NET 的开源复刻，桌面端画图 / 修图 | ❌ **不是** |
| Pinta（网页批注） | Chrome 扩展 + 本地 `pinta-companion` + Pinta MCP，圈选网页元素交给 Agent 改源码 | ✅ **是这个** |

检索、安装、写文档时一律带 `companion` / `mcp` / `pinta-mcp` 关键词区分；用户说"Pinta 圈选改源码"指的是后者。

## 2. Pinta（主力）

**定位**：网页元素 → 批注 → Agent 改源码。零框架侵入、localhost 私有化、不挑 Agent。

**组成与接入**（教程：<https://www.opcchina.ai/?p=4191>）：

```bash
# 1) 浏览器装 Pinta 扩展（Chrome Web Store 搜 Pinta），固定到工具栏
# 2) 项目根目录启动 companion，默认监听 127.0.0.1:7878，终端别关
npx pinta-companion .

# 3) 给本地 Agent 添加 Pinta MCP（一次配置即可）
codex mcp add pinta -- npx -y -p pinta-companion pinta-mcp
codex mcp list          # 确认列表里有 pinta

# 4) 启动前端项目（如 Vite），浏览器打开 localhost 页面，点 Pinta 图标显示 Connected
npm run dev
```

**操作流**：`Alt + S` 选元素 → 写批注 → `Add annotation` → 右侧 `Send to agent` → Agent 读 session → **先 Plan 后改**（列出将改的文件 / 样式 / 组件，确认再执行）→ 刷新看效果。

**标注工具**：Arrow / Rect / Pen / Pin / Select，改具体按钮文字卡片用 Select 即可。

**批注写法**（越具体越稳）：

- ✅ 「按钮背景改成黑色，增加圆角，整体尺寸稍微放大」
- ❌ 「优化一下这个按钮」

**边界**：只处理前端 DOM / 组件；需要 Node.js 20+；companion 必须运行在正确项目目录，否则浏览器侧不显示 Connected。

## 3. Inspecto（进阶补位）

**定位**：浏览器 UI 问题 → 准确源码上下文 → AI / MCP Agent → 页面内跟进。前端工程化更舒服。（<https://inspecto-dev.github.io/inspecto/zh/>）

**升级触发条件**（缺一不上升，默认用 Pinta）：

1. 需要 `Alt + 点击` **跳到准确源码行**；
2. 需要**任务时间线**——session 状态实时回传侧边栏（领取 / 处理中 / 完成 / 忽略）；
3. 需要 `prompts.json` **自定义工作流按钮**（如 Deploy Preview / Review & PR），让 Agent 调用自身 skill、MCP server 和 tool。

**接入**：项目根目录一条安装命令（由 AI 助手主导引导配置，如 `npm install -D @inspecto-dev/cli`），重启 dev server 后打开浏览器。支持 VS Code + Copilot / Cursor / Trae 等。

**三模式**：Quick Jump（跳源码行）/ Inspect Mode（点组件带上下文直接 Ask AI）/ Annotate Mode（跨组件圈选批量打包）。

**边界**：官方 overview 页未给出 MCP server 的完整配置 schema 与 `prompts.json` 字段定义；需要精确配置时查 `/inspecto/zh/config/plugin` 与 `/inspecto/zh/guide/getting-started`，**不要凭空编造配置键名**。

## 4. human-review（网页 / 文档审改）

**定位**：把 HTML / Markdown / localhost 页面在真实浏览器里打开，用户像用 Google Docs 一样直接改字、加粗、建列表、拖图片、选中短语留言、对图片/区块批注、直接删除，点 Send 一次性回传全部修改与评论。（<https://github.com/petergyang/human-review>，MIT，约 1.3k stars）

**形态**：**Skill**（`SKILL.md` 由 Agent 按需加载），不是 MCP。`npx -y human-review setup --global` 可全局配置。

**接入命令**：

```bash
# 打开本地文件或本地开发页面
npx -y human-review path/to/file.html
npx -y human-review http://localhost:3000/wiki

# 阻塞等待用户点 Send，收到反馈后退出
npx -y human-review poll path/to/file.html

# 作为 Skill 安装（任意读 SKILL.md 的 Agent）
git clone --depth 1 https://github.com/petergyang/human-review.git /tmp/human-review
mkdir -p .claude/skills && cp -r /tmp/human-review/src .claude/skills/human-review
```

**关键行为**：HTML 的直接编辑 / 图片缩放自动保存；**Markdown 与 localhost 页面必须点 Send，由 Agent 把修改应用回源文件**——Markdown 文件本身不被改写，批注引用的是渲染后文本。要求 Node.js 20+，npm 包约 0.4.0。

**适用边界**：文档、方案、落地页、本地 Web 应用、多页网站；**不替你做产品决策，也不等于代码 Review**（视觉改对不代表性能 / 可访问性 / 响应式 / 业务逻辑没问题）。

## 5. EditHere（一切画面）

**定位**：把修改意图直接标在图上。截图 / 智能选块 / 点 / 框 / 全局意见 + 「大爆炸」拖动布局，导出**原图 + 编号坐标 + 布局变化 JSON**，交给任意多模态 AI。不绑模型、不绑 DOM，屏幕上能看到就能标。（<https://github.com/Inginnng/EditHere>，MIT）

**形态**：桌面应用（Qt 原生，Windows / macOS）+ companion skill + `edithere-cli`。**不调用模型、不写代码**，只导出结构化反馈。

**适用范围**：网页与客户端界面、游戏 HUD / 界面、AI 生图局部重绘、视频 / 动画按帧批注（带时间戳）、图表与演示页局部修改、设计稿与实现核对（取色 / 坐标 / 长截图 / OCR）。

**反馈 JSON**：原图信息 + 每个对象的 `region` / `global` 坐标 + `movement`（移动前后真实矩形）+ 编号意见；格式见上游 `feedback-minimal-v4.schema.json`。**原图完整保留**，批注与坐标独立导出。

**AI 解析**：内置 OpenAI / Claude / DeepSeek / GLM / Kimi 等预设，但**直接让当前 Agent 读图 + JSON 时无需另配 API Key**；密钥存系统凭据库（QtKeychain），不写进项目或 JSON。

**边界**：不做语义抠图、不自动补背景、不执行视频剪辑；透明空洞由 Agent 结合项目实现补。本技能**不内置**该应用，仅记录路由与官方入口。

## 6. MCP 形态判定：本技能**不改成 MCP**（V0.06 结论）

用户提问「原 cht-work-skill 是不是要改成 MCP？」——**结论：不改，保持 Skill 形态。** 四条依据：

| # | 依据 | 说明 |
| --- | --- | --- |
| 1 | **层级不同** | cht-work-skill 是决策 / 编排层（提示词优化、禁止优化硬约束、任务分流、路线选择、执行编排、反馈路由），MCP 是工具 / 能力层。两者是**上下游**，不是替代关系。改成 MCP 等于把编排大脑降级成接口，丢掉六步工作流。 |
| 2 | **四工具形态不统一** | Pinta / Inspecto 提供 MCP server；human-review 本身是 Skill（纯 Markdown）；EditHere 是桌面应用 + companion skill。**没有统一形态可"改"**，也没有哪个工具要求调用方必须是 MCP。 |
| 3 | **违背"不挑 Agent"** | Skill 是纯 Markdown，ChatGPT / Claude Code / 豆包 / DeepSeek / Kimi / harness 都能读（V0.03 跨智能体适配）；MCP 只覆盖支持 MCP 的 Agent。Pinta 的卖点正是"不挑 Agent"，载体不该反过来收窄。 |
| 4 | **正确方向是反过来** | 让 cht-work-skill **编排**这些工具：MCP server 是被调用对象，不是它自身形态。若真要统一 MCP 化，应**另起一个项目**（例如把四类反馈 session 归一化的 MCP server），而不是改造本技能。 |

**一句话**：Skill 管「判断用什么、怎么改」，MCP 管「把能力接进来」；cht-work-skill 站在判断这一侧，不需要降级成能力接口。

## 7. 路由决策表（可执行）

| 信号（用户说了什么） | 路由 | 动作 |
| --- | --- | --- |
| 「这个按钮 / 标题 / 卡片改一下」「圈出来给你看」+ 前端页面 | Pinta | 启 companion → 用户 Alt+S 批注 → Agent 读 session → 先 Plan 后改 |
| 「跳到源码行」「看 Agent 处理到哪了」「加个 Review & PR 按钮」 | Inspecto | 升级到进阶工具，按三模式之一操作 |
| 「这份 PPT / Word / Markdown / 网页帮我逐段看看」 | human-review | `npx -y human-review <目标>` → 用户改 → `poll` 收反馈 → 应用回源文件 |
| 「这张图 / 这个视频 / 游戏界面这里不对」 | EditHere | 用户截图批注 / 大爆炸调布局 → Agent 读坐标 JSON → 改 |
| 「帮我看看逻辑对不对」「这段文案通顺吗」（无视觉对象） | 都不用 | 直接文字反馈，不引入工具 |
| 工具未安装 / 用户不想装 | 降级 | 说明该工具可选，改用文字或截图描述继续主流程 |

### 闭环位置（接回 UFO 四阶段）

```
交付成品（前四步）
   → 第五步选工具 → 用户圈选批注 → 工具导出反馈
   → Agent 读取反馈 → 必要时回第一步重新优化需求
   → 第三步选路线 / 第四步执行修改
   → 再交回工具复审 → 记忆更新（版本历史 / 留痕）
```

## 8. 本轮实跑留痕（V0.06）

**判定**：本条消息含「帮我嫁接进去 / 给出嫁接方案 / 是不是要改成 MCP」，属**下任务 + 转换 + 迭代升级**的任务型，未命中禁止优化清单；同时**不属于网页 PPT 路由域**（是工具路由方案），按主文件第三步说明走自主实现路径。

### 精简通用版

```
角色：AI 技能架构师。把 Pinta（前端源码批注主力）、Inspecto（跳源码行+时间线+自定义工作流进阶）、human-review（网页/PPT/Word/图片文档审改）、EditHere（一切画面坐标批注）四工具嫁接进 cht-work-skill 第五步；固化文档类不走前端工具、Pinta 非 GTK 画图软件的边界；判定本技能保持 Skill 不改 MCP；升版本推送并全局同步。
```

### 高阶顶配版

```
# 角色
你是 AI 技能架构师，熟悉 Agent Skill 规范、MCP 协议与人在回路反馈工具生态。

# 上下文
公开仓库 cuohuatang/cht-work-skill 当前为 V0.05，已有五步流程雏形：
禁止优化硬约束 → 提示词优化 → 技能检索 → 路线选择 → UFO 执行编排。
用户新给四工具路由意图，并询问是否要把技能整体改成 MCP。

# 任务拆解
1. 核实四个工具的真实形态与接入方式，区分同名 Pinta。
2. 建立「改什么 → 用什么工具」路由表与三条硬规则。
3. 判断 MCP 形态问题，给四条可验证依据，结论必须明确。
4. 写第五步细则：接入命令、边界、闭环、降级路径。
5. 同步主 SKILL、README、既有细则；升 V0.06、提交、推送、全局同步。

# 约束
- 保持 Skill 形态，不改成 MCP；不把四工具代码复制进仓库。
- 元提示词原文、特别注意原文、V0.04 硬约束一字不改。
- 不编造 Inspecto 的配置 schema 与 prompts.json 键名（官方页未给出）。
- 不把令牌写入仓库，推送后清除远端地址令牌。

# 输出规格
V0.06；新增 references/visual-feedback-routing.md；主 SKILL 与 README 更新；
一条 feat(v0.06) 提交；仓库 public、main；远端可核验。

# 验收清单
主文件含第五步且五步顺序正确；路由表覆盖四工具；MCP 判定含四条依据；
原文保真；两个上游子目录零改动；全局 grep 验证通过。

# 负面清单
禁止把 Pinta 当 GTK 画图工具、禁止把文档类塞给 Pinta/Inspecto、
禁止声称本技能是 MCP server、禁止编造未核实的配置键名、
禁止反问用户补充信息、禁止生成第三版提示词。
```

### 隐性需求补齐

| 项 | 补齐内容 | 依据 |
| --- | --- | --- |
| 角色设定 | AI 技能架构师 + 工具集成顾问 | 用户只说「嫁接进去」 |
| 目标受众 | 用 Agent 做前端 / 文档的人 | 元提示词「适配所有智能体」 |
| 风格约束 | 不废话、不闲聊、不凑字数 | 元提示词第三条 |
| 输出格式 | 嫁接方案 + 路由表 + MCP 判断 | 用户明确要「给出嫁接方案」 |
| 验收标准 | 版本号、文件落点、提交推送、全局验证 | 历次迭代惯例 |
| 边界条件 | 文档类不走前端工具、工具可选不阻塞 | 用户「文档类不走这俩」 |
| 架构判定 | 保持 Skill、不改 MCP | 四工具形态不统一 + 不挑 Agent |
| 命名辨析 | Pinta 非 GTK 绘图程序 | 检索发现同名冲突 |

### 已规避的漏洞

- 目标冲突：改成 MCP 与「不挑 Agent」冲突 → 判定保持 Skill。
- 循环依赖：要先有 MCP 才能判断要不要 MCP → 用四工具形态证据直接判定。
- 不可验证形容词：「前端工程化更舒服」→ 转成 Inspecto 三个可观测触发条件。
- 重复指令：第五步与前四步职责重叠 → 第五步只管交付后的反馈路由。
- 越权假设：假定 Pinta 是画图软件 → 命名辨析表锁定。
- 范围过宽：所有交付都走反馈工具 → 声明可选、只在审改时启用。
- 无依据编造：Inspecto 配置 schema 官方页未给 → 显式写「不要编造，去查配置页」。

### 第二步检索留痕

| 检索词 | 最高 score | ≥0.90 命中 | 判定 |
| --- | --- | --- | --- |
| 前端可视化标注 Agent 改源码 工具路由 MCP 插件 | 0.050 | 0 | < 0.60，自主实现 |
| visual annotation agent edit source code tool routing mcp skill | 0.050 | 0 | < 0.60，自主实现 |

结论：**无高相似现成技能**，按 V0.02 规则自主完成 V0.06 迭代。四个工具通过官方文档 / 教程直接核实，未复制到仓库。

## 9. V0.07 衔接补充（第三步分叉）

V0.07 在第三步新增「中间分叉」，位于第五步之前：分叉只决定「走哪条路线 / 哪种风格」，与第五步「交付后改什么用什么工具」是两个独立环节，互不触发。分叉选定路线后正常交付，交付后如需圈选审改再进第五步；不因走了分叉就跳过或强制启用第五步。本细则记录的四工具路由与 MCP 判定不受 V0.07 影响，本技能仍保持 Skill 形态。衔接细则见 `references/decision-fork.md`。

## 10. V0.08 衔接补充（第四步代码最小化）

V0.08 在第四步嫁接 Ponytail 七级代码阶梯，位于第五步之前：第五步圈选反馈若要**改代码**，改的那段同样要过七级阶梯（先问代码库 / 标准库 / 原生 / 现有依赖能否复用，再写最小实现，校验 / 安全 / 可访问性不砍）。第五步负责「定位改哪里」，Ponytail 负责「那段代码怎么写得最少」，两个环节独立但串联。本细则四工具路由与 MCP 判定不受 V0.08 影响；Ponytail 只借鉴方法论、不引入插件命令，本技能仍保持 Skill 形态。衔接细则见 `references/ponytail-minimal-code.md`。
