# Skills 源目录

把每个可分享的 skill 作为一个独立目录放在这里，站点会在构建时自动生成：

- `/skills/<slug>/` 详情页
- `/api/skills.json` 索引文件
- `/skill-files/<slug>/SKILL.md` 原始下载地址

推荐结构：

```text
skills/
  my-awesome-skill/
    SKILL.md
    skill.json
    assets/
```

约定：

- `SKILL.md` 必填
- `skill.json` 选填，用来补充标题、标签、版本、安装命令等元数据
- `assets/` 选填，里面的图片或示例文件会自动复制到公开静态目录
- 以下划线开头的目录会被忽略，可用来存放模板

本地生成命令：

```bash
node scripts/build-skill-catalog.mjs
```
