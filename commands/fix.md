---
description: 保底入口（若命令列表不显示中文名就用这个）：点选「改网页 / 改文档 / 改画面」，一键弹出中文选择框
argument-hint: "[可选：直接说要改什么，如『改首页按钮』]"
allowed-tools: Read, Write, Edit, Bash, WebFetch, WebSearch, Skill, Glob, Grep, AskUserQuestion, present_files, ViewImage
disable-model-invocation: true
---

说明：本命令与 `/改` 功能完全相同，仅作为英文保底名——当客户端斜杠命令列表不显示中文名（`/改`）时使用。

用户输入：$ARGUMENTS

## 第零步：项目速记匹配（命中则跳过第一步选择框）

先读 `/root/.codebuddy/command-projects.md` 速记表，把 `$ARGUMENTS` 里的项目别名（如「报价器」）与表中别名做模糊匹配：

- **命中**：直接取该行的「类型 / 项目路径 / 启动命令 / 页面 URL」，映射到对应工具（网页→Pinta / Inspecto、文档→human-review、画面→EditHere），说一句「已按速记『报价器』走改网页」后**直接进入第二步执行**，不弹选择框、不再问路径。
- **未命中**：继续第一步弹选择框。若用户给了路径/URL，执行完顺手补一行速记，下次即命中。
- 示例行（`/path/to/quotation-app`）不是真实项目，不许拿它当真实路径启动，它只是格式样例。

## 第一步：弹出中文选择框（未命中速记时才做，别让用户记英文）

**先调用 AskUserQuestion 工具弹出选择框**，让用户点选要改哪一类：

```
questions:
  - question: "你要改什么？点一个，我帮你打开对应的标注工具。"
    header: "改什么"
    multiSelect: false
    options:
      - label: "改网页"
        description: "前端页面/UI：浏览器右侧栏圈选元素、写人话，Agent 改源码（Pinta，进阶 Inspecto）"
      - label: "改文档"
        description: "网页/PPT/Word/Markdown：审改面板里像 Docs 一样直接改字、圈选留言（human-review）"
      - label: "改画面"
        description: "截图/AI生图/视频帧/游戏HUD/桌面UI：桌面上框选批注、导出坐标（EditHere）"
```

**例外**：如果 `$ARGUMENTS` 已明确类别（如「改首页按钮」「审改这份 Word」「标注这张截图」），直接判定并说一句「已按『改网页』处理」，跳过选择框，不重复问。

## 第二步：按选择执行（工具与流程按 cht-work-skill 第五步 `references/visual-feedback-routing.md`）

### 选「改网页」→ Pinta（主力）/ Inspecto（进阶）
1. 项目根目录启动 ``npx pinta-companion .``（保持运行，默认 127.0.0.1:7878）；确认 Pinta MCP 已配（``codex mcp list``，没有就 ``codex mcp add pinta -- npx -y -p pinta-companion pinta-mcp``）。
2. 让用户启动 dev server（如 ``npm run dev``），浏览器打开页面，点工具栏 Pinta 图标打开**右侧边栏**，看到 `Connected` 即连通。
3. 告诉用户：`Alt + S` 选元素 → 写具体意见（「按钮背景改黑、加圆角、放大」，别写「优化一下」）→ `Add annotation` → `Send to agent`。
4. 读批注 session → **先 Plan 后改** → 按 Ponytail 七级阶梯写最小代码（校验/安全/可访问性不砍）→ 刷新核验。
5. 若需跳源码行 / 任务时间线 / 自定义工作流按钮，升级 Inspecto（``npm install -D @inspecto-dev/cli``，配置查官方文档，不编造字段）。

### 选「改文档」→ human-review
1. 打开：本地 HTML ``npx -y human-review path/to/file.html``；本地页面 ``npx -y human-review http://localhost:3000/wiki``；首次可 ``npx -y human-review setup --global``。
2. 告诉用户：在浏览器里像 Google Docs 一样直接改字、拖图、选中短语留言、对区块批注 → 点 **Send** 回传。
3. Markdown / localhost 页面须点 Send，再用 ``npx -y human-review poll <目标>`` 等待并把修改应用回源文件；HTML 直接编辑自动保存。
4. 读回核验。边界：它不做产品决策、不等于代码 Review。

### 选「改画面」→ EditHere（桌面应用，非浏览器右边栏，如实说明）
1. 打开 **EditHere 桌面应用**（Qt）+ companion skill + `edithere-cli`，加载截图 / AI 生图 / 视频帧 / 游戏 HUD / 设计稿。未安装给官方入口 <https://github.com/Inginnng/EditHere>，不阻塞。
2. 告诉用户：智能选块 / 点 / 框 / 全局意见 + 拖动布局；视频按帧批注带时间戳；批注与坐标独立导出。
3. 读导出的**原图 + 编号坐标 + 布局变化 JSON**，我直接读图解析意图，无需另配 API Key。
4. 按意图改对应内容并对照核验。边界：EditHere 不调用模型、不写代码、不做语义抠图/补背景。

## 提醒
- 三类互不串台：前端源码 UI 走改网页，文档走改文档，截图/生图/画面走改画面。
- 只做路由与接入引导，不部署工具、不内置运行时；本技能保持 Skill 形态，不改成 MCP。
- 若工具未装或无目标文件，如实告知获取方式，先完成能做的部分，不空等。
