# cht-work-skill

把两个高星网页 PPT 技能合并成一个入口：**有旧 PPT 就翻新，没旧 PPT 就从零做**。

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

## 怎么选

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

安装后直接对 Agent 说需求即可，例如：

- 「把这份 Q3 复盘.pptx 重做成网页 PPT，先给我 3 个风格样稿」
- 「基于这篇文章做一份瑞士风 PPT，7 页左右，带演讲者备注」
- 「把这份 Markdown 做成杂志风演讲 PPT，再出一张公众号 21:9 头图」

## 目录结构

```
cht-work-skill/
├── SKILL.md                      # 合并入口：路由决策 + 通用规则 + 两条路线要点
├── README.md                     # 本文件
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
2. 别让用户描述「高级大气」：路线 A 直接给 3 张样稿挑，路线 B 只让选杂志 / 瑞士。
3. 别自由调色：瑞士风只能挑预设锚点色（IKB 蓝 / 柠檬黄 / 柠檬绿 / 安全橙）；紫色渐变白底属于明确禁用的 AI 审美。
4. 别把两套模板混着用，子目录里的 `references/` 和 `assets/` 不通用。
5. 现场演讲前用演讲者模式排练一遍，按 `B` 可关掉 WebGL 动画兜底老旧设备。
6. 导出 PDF 是逐页截图，动画和编辑功能都会丢失。

## 许可说明

本仓库为聚合分发，**不重新授权上游代码**：`frontend-slides/` 为 MIT，`guizang-ppt-skill/` 为 AGPL-3.0。使用、修改或再分发 AGPL-3.0 部分时须遵守其对应义务（含源码开放要求）。各子目录内的 LICENSE、README、SPONSORS 与来源说明均原样保留。
