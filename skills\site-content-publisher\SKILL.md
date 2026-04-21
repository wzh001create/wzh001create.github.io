---
name: site-content-publisher
description: "用于管理 wzh001create Hugo 站点的内容发布流程。适用于导入、编辑、发布或删除 `content/posts/` 下的 Markdown 文章并同步 front matter 与图片；新增或更新独立 HTML 页面及其 `content/specials/` 包装页；以及创建、更新、发布 `skills/` 下的可复用技能，补齐 `skill.json`、`agents/openai.yaml`、生成技能库页面、zip 压缩包与上线校验。"
---

# 站点内容发布

默认仓库根目录：`D:\code\AI\wzh001create.github.io`。

## 开始前

1. 动手前先判断目标类型：Markdown 文章、HTML 专题页，还是网站技能库条目。
2. 先看一次 `git status --short`，避免覆盖用户已有改动。
3. 对用户的说明、提问、结果汇报统一使用中文。
4. 优先少量读取、局部编辑；能精准修改就不要整篇重写。
5. 只有在用户明确要求上线、上传、发布时才继续做部署；否则完成本地校验后汇报改动路径即可。

## 选择流程

- 处理 `content/posts/*.md` 时，读取 [references/markdown-posts.md](references/markdown-posts.md)。
- 处理 `static/*.html` 或 `content/specials/` 时，读取 [references/html-specials.md](references/html-specials.md)。
- 处理 `skills/`、`content/skills/`、`static/api/skills*.json` 或技能库展示模板时，读取 [references/skill-publishing.md](references/skill-publishing.md)。
- 如果任务混合了多种类型，只读取必要的 reference，并按这个顺序处理：内容源文件优先，站点包装页其次，部署和验收最后。

## 全局规则

- 除非必须重命名且用户同意，否则保留现有文件名。
- 独立资源放回它所属内容旁边：
  - Markdown 图片放在 `static/images/<article-name>/`
  - HTML 源文件放在 `static/<slug>.html`
  - Skill 源目录放在 `skills/<slug>/`
- 优先修元数据和包装层，不优先大改正文：
  - Markdown 元数据只改 front matter 区块。
  - HTML 专题优先改 Hugo 包装页，原始 HTML 尽量保持独立。
  - Skill 默认不要改用户原始 `SKILL.md`，除非用户明确要求；展示和集成问题优先通过 `skill.json`、`agents/openai.yaml`、`references/` 或站点模板解决。
- 只要改了 `skills/` 下的内容，就必须运行 `node scripts/build-skill-catalog.mjs`。
- 汇报成功前至少做最小必要校验：
  - 文件是否存在、路径是否合理
  - 生成产物是否出现
  - 如果任务包含发布，还要检查公开 URL
- 只要涉及真实上线，不要默认部署成功，必须验最终页面或下载地址。

## 输出要求

- 说明本次使用的是哪条流程。
- 给出准确的改动路径。
- 如果已经发布，给出公开访问 URL 或下载地址。
- 如果还没发布，说明下一步命令或剩余动作。

## 触发示例

- "把 `D:\\Docs\\文章.md` 发成博客文章"
- "把这个 HTML 页面挂到专题栏目"
- "把这个 skill 放到网站技能库里"
- "更新技能库详情页样式，但别动 skill 正文"

## 附加说明

- 文章导入、编辑、删除、front matter 和图片同步，看 [references/markdown-posts.md](references/markdown-posts.md)。
- 独立 HTML 页面和 `专题` 包装页，看 [references/html-specials.md](references/html-specials.md)。
- Skill 新建、补元数据、目录生成、压缩包和技能库展示，看 [references/skill-publishing.md](references/skill-publishing.md)。
