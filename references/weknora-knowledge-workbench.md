# WeKnora 素材工作台细则（V0.09 嫁接，流程第零步 · 可选上游层 / V0.10 新增 /理素材按钮直达）

配套主 `SKILL.md` 的「第零步 · 素材工作台」。解决一个前面五步都没覆盖的问题：**路线 A / B 都要读素材，但素材本身可能散落、多格式、带 scanned 件、分布在飞书 / Notion / 语雀 / 本地 Word·PDF 里——在「优化提示词 / 选路线 / 写代码」之前，得先把原始资料变成可用的知识**。这一层借鉴腾讯开源 WeKnora 的能力，只作可选上游路由，不引入其运行时。

## 1. 来源与定位

- 来源：<https://github.com/Tencent/WeKnora>，腾讯微信团队开源，官网 <https://weknora.weixin.qq.com>，约 **3.8 万星**（截图流传的「2.6 万」是旧数据），主分支 `main`，创建于 2025-07-22。
- 是什么：开源 LLM 知识平台，把原始文档变成「可查询的 RAG + 自主推理 Agent + 自维护 Wiki」，MIT 许可（主体）。技术栈 Go 后端 + Vue 前端 + Python docreader，标准部署含 PostgreSQL(pgvector) / Elasticsearch / Redis / MinIO，Lite 版才是单二进制（SQLite + 内存队列）。
- 在本技能的层次定位：**输入侧上游层**，与五步主流程和两条 PPT 路线正交。它不产出 PPT，只把「素材整理」这一步做扎实，再把结果喂给第一步优化。

| 层 | 解决什么 | 由谁负责 |
| --- | --- | --- |
| **第零步 素材工作台** | 素材从哪来、怎么变成可用知识 | WeKnora（可选）或本地脚本 |
| 第一步～第五步 | 优化 → 检索 → 选路线 → 执行 → 反馈 | 本技能主流程 |

## 2. 何时启用 / 何时不启用

**启用（满足任一）**：
- 素材多格式混合：PDF + Word + Excel + 扫描件 + 网页 + 图片；
- 素材散落多平台：飞书 Wiki / 飞书云文档 / Notion / 语雀 / Confluence / GitLab / 钉钉文档 / 腾讯 IMA / Seafile / RSS；
- 用户要「先从一堆资料里理出大纲 / 找依据 / 核实数据」；
- 需要带出处的引用、事实核查，避免 PPT 里写错数字；
- 素材量大，本地脚本逐个提取不划算。

**不启用（保持直达）**：
- 手里就是一个旧 PPTX / 一份文章 / 一个明确主题——路线 A 的 `scripts/extract-pptx.py` 或直接读文本更快；
- 用户只要判断、纯问答、寒暄、延续性修改；
- 命中禁止优化清单（除非明确要求「整理这些素材」）。

## 3. 能力对照表（它做什么，对本技能的价值）

| WeKnora 能力 | 对本技能的价值 | 官方依据 |
| --- | --- | --- |
| 多格式解析：PDF 版式分析、扫描件 OCR、Office 用 anydoc 进程内解析、网页抓取、图片描述，10+ 格式（含 XMind / EPUB / MHTML） | 素材统一入库，路线 A/B 不必各写一套提取逻辑 | README「Data sources and formats」 |
| 混合检索：向量 + BM25 关键词 + RRF 融合 + Rerank 重排，可选知识图谱 GraphRAG、Wiki 导航 | 从大素材里精准捞「这页要用哪段依据」 | 官网产品介绍 / README |
| 带引用回答，切片可编辑 / diff / 版本回滚，保留目录树 | 事实可核查、可修正，避免 PPT 写错数据 | README「Memory and curation」 |
| 自动 Wiki + 知识图谱 + 多智能体协作 + 跨会话长期记忆 | 把素材整理成大纲 / 讲稿，交给第一步提示词优化 | 官网 v0.9.0 / README |
| 内置 MCP Server：`/mcp/<endpoint_id>` Streamable HTTP，按知识库授权 + token + 速率限制 + 工具组 | 未来若接 MCP 客户端可直接查素材；**本技能不依赖它** | README「Built-in MCP Server」 |
| 多源自动同步（飞书 / Notion / 语雀 / Confluence / GitLab / IMA / 钉钉 / Seafile / RSS） | 素材不用手工搬运 | README「Data sources」 |
| 29 家内置模型 + Ollama 本地，LLM/Embedding/Rerank/VLM 分类管理 | 私有化场景可自选模型 | README「Models」 |

## 4. 与本技能五步的衔接（不改动主流程）

1. **→ 第一步（提示词优化）**：WeKnora 整理出的「大纲 / 依据 / 引用」作为素材输入，优化后的提示词里「用途 + 素材 + 交付格式」的「素材」部分更实。
2. **→ 第三步（选路线）**：WeKnora 只提供内容，不决定路线；有旧 PPT 仍走 A、无稿从零仍走 B，别因为用了知识库就改路线规则。
3. **→ 第四步（执行）**：检索出的带引用片段用于填页内容；写代码时仍按 Ponytail 七级阶梯（本轮 V0.08）最小化实现。
4. **→ 第五步（视觉反馈）**：圈选反馈若要改内容事实，可用 WeKnora 再核查依据；两个环节独立。
5. **不触发第二步技能检索**：WeKnora 是素材工具，不是「可复用技能」；别把它当 find-skills 的检索结果。

## 5. 边界与诚实说明（必须随交付一起说明）

- **不部署、不内置、不要求安装**：WeKnora 是重型系统（Go + Vue + docreader + PG/ES/Redis/MinIO；Lite 版单二进制），本技能**只记录路由**，不复制其代码、不引入运行时、不要求用户为做 PPT 去部署它。
- **有实例才用**：用户已有 WeKnora 实例时，可把它的检索结果作为素材输入；没有就用路线自带脚本 / 直接读文本，不阻塞主流程。
- **许可按原文**：官方 LICENSE 写明「WeKnora is licensed under the MIT except for the third-party components listed below」——**主体 MIT，列出的第三方组件保留各自许可**。GitHub API 的 license 字段返回 `NOASSERTION` 正是这个原因；转述时别说成「纯 MIT」。
- **星数以核实为准**：README 徽章与官方站点给的是约数，GitHub API 实测约 3.8 万星；截图里「2.6 万」是旧数据。
- **不做新路线**：WeKnora 产出的是知识与引用，不是 HTML 演示；本技能两条路线仍是唯一交付主体。

## 6. 官方接入方式（仅记录，本技能不内置）

标准部署（需 Docker / Docker Compose / Git）：

```bash
git clone https://github.com/Tencent/WeKnora.git
cd WeKnora
cp .env.example .env          # 按需配置模型 / 存储 / 密钥
docker compose pull
docker compose up -d          # 启动核心服务
# Web UI: http://localhost  |  后端 API: http://localhost:8080
```

轻量部署：Lite 单二进制（SQLite + 内存队列，无外部依赖，见官方 `docs/LITE.md`）；桌面应用为 Lite 运行时 + GUI，官方尚未发布安装包，需源码构建。

数据源接入：Web UI 里配置飞书 / Notion / 语雀 / Confluence / GitLab / IMA 等连接器；文档可直接上传或给 `resource_urls`。MCP Server 按 workspace 生成 `/mcp/<endpoint_id>` 端点，带 token 与知识库范围。**这些命令只作记录，本技能不执行、不要求用户执行。**

## 7. V0.09 实跑留痕（本轮自身）

- **判定**：本条为「下任务 + 嫁接新能力」，未命中 V0.04 禁止优化清单，属任务型 → 执行第一步优化成两版（精简通用版：把 WeKnora 多格式解析 + 混合检索 + 带引用能力转译为第零步可选素材工作台，与五步正交、不新增路线、不部署不内置，诚实标注许可与星数；高阶顶配版：含角色 / 上下文 / 任务拆解 / 约束 / 输出规格 / 验收清单 / 负面清单，全文入库）；**不属于网页 PPT 路由域**，按主文件说明自主实现。
- **第二步检索留痕**：两组查询「WeKnora 腾讯 知识库 RAG 文档解析 Office PDF Agent Wiki 素材整理」「WeKnora tencent RAG knowledge base document parsing office pdf agent wiki ingestion」最高 score 均 **0.050**（< 0.60），无高相似现成技能 → 自主完成 V0.09 迭代。
- **资料核实**：GitHub API 确认仓库 `Tencent/WeKnora`、约 37,910 星、主分支 main；官方 README 取能力表、部署方式、MCP 端点与数据源；官方 LICENSE 原文确认「主体 MIT + 第三方组件各自许可」（API 因此标记 NOASSERTION）；**纠正截图「2.6 万星」为旧数据**。
- **嫁接决策**：定位为流程最上游的可选素材层，与两条 PPT 路线正交；只借鉴能力路由，不部署 / 不内置 / 不要求安装，不改成 MCP。
- **文档落地**：主 `SKILL.md` 新增第零步小节、注意事项第 11 条、交付话术第 8 条、版本表 V0.09 行、来源表 WeKnora 行；本细则新建；README 与六份既有细则补衔接。

## V0.10 衔接（快捷按钮）

`/理素材` 按钮直达本步骤（第零步）：素材散落多格式 / 要带引用理大纲时启用，单一素材用路线脚本更快。按钮只是入口，不部署 / 不内置运行时 / 不要求安装的边界与许可口径（主体 MIT + 第三方组件各自许可）仍按本细则；用户已有 WeKnora 实例才把检索结果当素材输入。按钮清单见 `references/quick-commands.md`。
