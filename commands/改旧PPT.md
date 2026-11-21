---
description: 路线A直达：把旧 PPT/PPTX 或已有 HTML deck 翻新成会动的网页演示（frontend-slides）
argument-hint: "[旧PPT/PPTX 或 HTML deck 路径，可选：要改成什么样]"
allowed-tools: Read, Write, Edit, Bash, WebFetch, WebSearch, Skill, Glob, Grep, AskUserQuestion, present_files
disable-model-invocation: true
---

请使用 **cht-work-skill** 的**路线 A（frontend-slides）**完成，直接读 `frontend-slides/SKILL.md` 原文执行，不用本文件摘要代替。

用户输入：$ARGUMENTS

## 执行要点
1. 先判定是否命中「禁止优化清单」；命中直接干活，不生成两版提示词。
2. 旧稿转换用 `scripts/extract-pptx.py` 提取文字 / 图片 / 备注 → 先列「标题 / 内容摘要 / 图片数量」清单给用户确认 → 保留页序素材重做成网页演示（**不输出新的可编辑 PPTX**）。
3. 先出 3 张标题页预览（真实标题与素材，不写「方案 A」），用户挑一张；风格索引见 `STYLE_PRESETS.md` / `bold-template-pack/selection-index.json`，选中后才加载该套 `design.md`。
4. 固定 16:9（1920×1080）舞台、单文件 HTML、CSS/JS 内联、零依赖；方向键 / 空格 / 滚轮翻页，E 编辑、Ctrl+S 保存。禁用紫色渐变 + 白底这类 AI 味审美。
5. 写代码前过 Ponytail 七级阶梯；交付前浏览器逐页自检（溢出 / 重叠 / 图片 / 动画 / 16:9）。
6. 若用户明确要 `.pptx`，先停下说明格式冲突，给 PDF 导出或本地 Office 链路替代。

若 $ARGUMENTS 为空或没给旧稿路径，先问：旧 PPT/PPTX 或 HTML deck 在哪个路径？想保留内容换皮还是大改？
