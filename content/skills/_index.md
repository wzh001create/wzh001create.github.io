---
title: "技能库"
description: "集中展示可复用的 Codex / OpenCode skills，并提供统一的浏览与分享入口。"
summary: "这个栏目会自动扫描仓库里的 skills 目录，生成列表页、详情页和 JSON 索引。"
showtoc: false
---

这里展示的是仓库根目录 `skills/` 下的公开 skill。

你后面只需要新增一个目录，并至少放入一个 `SKILL.md`：

```text
skills/
  my-skill/
    SKILL.md
    skill.json
    assets/
```

补充说明：

- `skill.json` 是可选的，但建议加上，方便展示标题、版本、标签、安装命令
- `assets/` 中的图片和示例文件会自动复制到公开静态目录
- 构建时会自动生成 `/api/skills.json`，方便以后接安装器、搜索或聚合站

如果当前列表为空，说明你还没把真实 skill 放进来。
