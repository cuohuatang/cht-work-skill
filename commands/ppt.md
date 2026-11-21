---
description: 一键调用 cht-work-skill 制作/修改网页 PPT（有旧稿翻新，没旧稿从零做）
argument-hint: "[需求：主题/旧PPT路径/要改成什么样]"
allowed-tools: Read, Write, Edit, Bash, WebFetch, WebSearch, Skill, Glob, Grep, AskUserQuestion, present_files
disable-model-invocation: true
---

请使用 **cht-work-skill** 技能完成本次任务，严格按它的五步流程执行（素材工作台→提示词优化→技能检索→选路线→执行编排→按需视觉反馈）。

用户的需求如下：
$ARGUMENTS

执行要求：
1. 先判断用户输入（$ARGUMENTS）是否命中「禁止优化清单」；命中则直接干活，不生成两版提示词。
2. 选路线：有旧 PPT/PPTX 或已有 HTML deck 走 frontend-slides；没有旧稿、从主题/文章/想法起步走 guizang-ppt-skill；明确要 .pptx 先说明格式冲突。
3. 判定模糊（两条路线都行、用户拿不准、跨类型需求）时按第三步分叉规则给 2~3 个选项，每个选项写清「选它会得到什么」并标推荐项，用户不选就走推荐项。
4. 写代码/改 HTML·CSS·JS 前过 Ponytail 七级代码最小化阶梯，校验/安全/可访问性不砍。
5. 交付的是单文件 HTML 网页演示（不是 .pptx），交付前浏览器逐页自检，并按交付话术说明路线、风格、留痕与格式限制。
6. 若用户是要审改已有成品、圈选反馈，再按第五步路由到对应反馈工具（Pinta/Inspecto/human-review/EditHere）；首发交付不强制走。

若 $ARGUMENTS 为空，先问用户：手上有旧 PPT 吗？主题或素材是什么？用来什么场合讲？
