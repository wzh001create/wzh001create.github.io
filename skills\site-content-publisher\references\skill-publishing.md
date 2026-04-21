# Skill 发布与上站

用于把可复用 Skill 新增到站点、更新元数据、生成技能库页面，或把已有 Skill 上架到 `技能库`。

## 真正的源目录

- Skill 源目录：`skills/<slug>/`
- 生成的详情页：`content/skills/<slug>.md`
- 生成的 API：
  - `static/api/skills.json`
  - `static/api/skills/<slug>.json`
- 生成的公开文件：
  - `static/skill-files/<slug>/`
  - `static/skill-files/<slug>.zip`

## 最小目录结构

```text
skills/<slug>/
  SKILL.md
  skill.json
  agents/openai.yaml
  references/
  assets/
  scripts/
```

必需：

- `SKILL.md`

推荐：

- `skill.json`
- `agents/openai.yaml`

可选：

- `references/`
- `assets/`
- `scripts/`

## 新建规则

1. 目录名使用连字符风格的 `hyphen-case`。
2. `SKILL.md` 保持精炼，重点写触发场景和工作规则。
3. 复杂流程、不同变体、长说明放进 `references/`，不要把 `SKILL.md` 写得过胖。
4. `agents/openai.yaml` 要和技能真实行为保持一致。
5. 只要站点展示需要更多信息，就补 `skill.json`。

## 导入或打磨已有 Skill 时

- 把用户自己的 `SKILL.md` 视为内容真源。
- 除非用户明确要求改技能内容，否则不要重写他们的 `SKILL.md`。
- 网站展示相关字段优先放进 `skill.json`，例如：
  - 展示标题
  - summary
  - version
  - tags
  - platforms
  - install 命令
- 启动器和技能芯片相关元数据优先放进 `agents/openai.yaml`。

## 推荐的 `skill.json` 字段

```json
{
  "name": "Skill Display Name",
  "slug": "skill-slug",
  "summary": "Short summary",
  "description": "Longer header description",
  "author": "wzh001create",
  "version": "0.1.0",
  "tags": ["tag1", "tag2"],
  "platforms": ["Windows", "Hugo"],
  "install": [
    "git clone https://github.com/wzh001create/wzh001create.github.io.git",
    "Copy skills/skill-slug to $CODEX_HOME/skills/ or ~/.codex/skills/"
  ],
  "repo": "https://github.com/wzh001create/wzh001create.github.io/tree/main/skills/skill-slug",
  "featured": false,
  "order": 100
}
```

## 构建与校验流程

1. 每次改完 Skill 后都运行 `node scripts/build-skill-catalog.mjs`。
2. 确认目标 `slug` 的生成产物已经出现。
3. 记住对外下载的是整个 Skill 目录的 zip，不是单独的 `SKILL.md`。
4. 如果是网站渲染问题，优先改 `layouts/skills/*.html` 或 `assets/css/extended/skills.css`，不要先去动 Skill 正文。

## 上线检查清单

- `skills/<slug>/` 源目录存在。
- `content/skills/<slug>.md` 已生成。
- `static/api/skills/<slug>.json` 已生成。
- `static/skill-files/<slug>.zip` 已生成。
- 如果已经上线，验证：
  - `/skills/<slug>/`
  - `/skill-files/<slug>.zip`
  - `/api/skills/<slug>.json`
