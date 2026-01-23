---
name: blog-edit-post
description: Edit blog posts with list-first selection, freeform edits, optional image changes, and publish confirmation
---

# Blog Edit Post Skill

Edit existing blog posts with list-first selection, freeform user requests, and optional publishing.

## What I do

- Always list all blog posts first (titles + filenames)
- Let users choose a post by number, title, filename, or keyword
- Apply **freeform edits** based on the user's request
- Support front matter updates and body edits
- Optional image add/remove/rename
- Ask whether to publish changes to GitHub

## When to use me

Use this skill when the user wants to:
- Edit an existing article
- Fix a typo, update content, or change metadata
- Add or remove images
- Update tags/categories/title/date

## Trigger phrases (examples)

- "编辑文章"
- "修改 Git 那篇文章"
- "把文章标题改成 xxx"
- "edit the kubernetes post"
- "我想改一下某篇文章"

## How I work

### Step 1: ALWAYS list all blog posts first

Use Bash to list markdown files and extract titles:

```bash
cd ~/wzh_blog/my-blog/content/posts
ls -1 *.md
```

For each file:

```bash
grep "^title:" <filename> | head -1
```

Show a numbered list:

```
📚 当前博客文章列表：

1. Git 常用命令速查手册
   文件: git-commands-reference.md

共 1 篇文章
```

### Step 2: Match the user's selection

Accept:
- Number ("1")
- Title keyword ("Git")
- Filename ("git-commands-reference")

If multiple matches, list them and ask to clarify.

### Step 3: Interpret the edit request (freeform)

**Goal:** Apply the user's request directly when clear. Only ask follow-ups if the request is ambiguous.

Examples:
- "把标题改成 X" → update front matter title
- "把 tags 改成 A,B" → update tags
- "把第一段的 XXX 改成 YYY" → Edit body text
- "删除最后一节" → remove content block

If the user did not specify what to edit, ask:

```
你想修改哪一部分？
1. 标题/标签/分类/日期
2. 正文内容
3. 图片
```

### Step 4A: Front matter edits

Read the front matter only (first 40 lines):

```
filePath: <article-file>
offset: 0
limit: 40
```

Use Edit tool to update specific fields:
- title
- tags
- categories
- date
- draft
- author

Example update:

```
title: "旧标题" → "新标题"
tags: ["旧"] → ["新1", "新2"]
```

### Step 4B: Body content edits

Use Edit tool to apply focused changes. Prefer targeted replacements instead of rewriting the whole file.

When user provides a specific change, apply it directly.

### Step 4C: Image edits

If the user asks to add/remove/rename images:

- Article image dir: `static/images/<article-name>/`
- Use Bash to list files, copy, remove, or rename
- Update image references in markdown if filenames change

### Step 5: Ask whether to publish

After edits, ask:

```
是否立即发布到 GitHub？
- 是 - 立即提交并推送
- 否 - 稍后手动发布
```

### Step 6: Publish if confirmed

```bash
cd ~/wzh_blog/my-blog
git add -A
git commit -m "chore: 更新文章《<article-title>》"
git push
```

### Step 7: Confirm success

```
✅ 编辑完成！

📄 文件：content/posts/<article-name>.md
🚀 已推送到 GitHub（如果选择发布）
```

## Important notes

- ALWAYS list all posts before editing
- Prefer direct edits; ask only when the request is unclear
- Use Read with a small limit for front matter inspection
- Avoid rewriting the whole file unless necessary
- Image changes should keep markdown paths in sync

## Tools to use

- **Bash**: list posts, manage images, git commands
- **Read**: inspect front matter or specific sections
- **Edit**: make focused changes
- **Question**: when clarification or publish confirmation is needed
