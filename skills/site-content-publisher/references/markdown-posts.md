# Markdown 文章

用于处理 `content/posts/` 下文章的导入、局部编辑和删除。

## 核心原则

- 继承 `.opencode/skills/blog-import-post`、`.opencode/skills/blog-edit-post`、`.opencode/skills/blog-delete-post` 里那套省 token 思路。
- 优先用 shell 操作和局部编辑，不要一上来就读全文、重写全文。
- 除非用户明确要求重命名，否则保留原始文件名。
- 所有对用户的说明和提问都用中文。

## 关键路径

- 仓库根目录：`D:\code\AI\wzh001create.github.io`
- 文章目录：`content/posts/`
- 图片目录：`static/images/`
- 默认作者：`wzh001create`

## 导入已有 Markdown

1. 先校验输入路径和扩展名。
2. 只检查前 50 行，判断有没有 front matter，以及是否包含 `title`。
3. 分两条路径处理：
   - front matter 完整且有 `title`：直接保留原有元数据，复制文件后做最小修正。
   - 没有 front matter 或缺少关键字段：向用户确认标题、标签、分类，再生成一份干净的 Hugo front matter，正文保留原内容。
4. 导入后至少保证这些字段存在：
   - `title`
   - `date`
   - `draft: false`
   - `author: "wzh001create"`
5. 检查源 Markdown 同目录下是否有图片；如果有，复制到 `static/images/<article-name>/`，并把相对图片引用改成 `/images/<article-name>/<file>`。
6. 校验时优先用路径检查或短 front matter 检查，不要再次读取全文。
7. 如果用户一开始没有明确要求立即上线，再询问是否发布。

## 编辑已有 Markdown

1. 总是先列出当前文章，即使用户已经给了关键词。
2. 允许用户按序号、标题、文件名或关键词选择。
3. 只读取本次改动需要的那一小段：
   - 只改 front matter：读前 40 行
   - 只改正文某一段：围绕目标片段做局部读取
4. 优先精准修改：
   - `title`、`tags`、`categories`、`date`、`draft`、`description` 只改 front matter。
   - 正文修改尽量做局部替换，不要整篇重写。
5. 如果图片有新增、删除、重命名，保证 `static/images/<article-name>/` 和 Markdown 引用同步。
6. 如果用户没明确要求立即上线，最后再询问是否发布。

## 删除已有 Markdown

1. 总是先列出所有文章。
2. 匹配用户选择后，在删除前把准确目标展示出来。
3. 删除时同时处理：
   - `content/posts/<filename>.md`
   - `static/images/<article-name>/`（如果存在）
4. 任何删除动作都先确认。
5. 如果用户意图明显是“从网站上删掉”，确认后就视为包含发布；否则再问是否要推送删除结果。

## 推荐的 Front Matter 形态

```yaml
---
title: "文章标题"
date: 2026-04-21T12:00:00+08:00
draft: false
tags: ["标签1", "标签2"]
categories: ["分类"]
author: "wzh001create"
description: "可选，一句话摘要"
---
```

## 提交信息建议

- Import: `feat: 添加文章《标题》`
- Edit: `chore: 更新文章《标题》`
- Delete: `chore: 删除文章《标题》`

## 校验清单

- Markdown 文件已经出现在 `content/posts/` 下。
- 图片引用已经指向 `/images/<article-name>/...`。
- `draft` 没有误设成 `true`。
- 如果已经发布，确认文章详情页或首页列表确实更新。
