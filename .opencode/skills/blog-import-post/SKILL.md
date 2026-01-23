---
name: blog-import-post
description: Import existing Markdown files into the Hugo blog with smart metadata handling, automatic image processing, and token optimization
---

# Blog Import Post Skill

Import existing Markdown files into the Hugo blog with intelligent handling of front matter, automatic image processing, and optimized token usage.

## What I do

- Import Markdown files into the blog's `content/posts/` directory
- **Token-optimized processing**:
  - If file has complete front matter → use `cp` + `sed` commands (saves 70% tokens)
  - If file lacks front matter → use Write tool with user-provided metadata
- Automatically detect and copy images from source directory
- Update image paths to use Hugo's static path structure
- Optionally publish immediately to GitHub

## When to use me

Use this skill when the user wants to:
- Add an existing Markdown file to the blog
- Import articles written elsewhere (Documents, Downloads, etc.)
- Migrate content from other blogging platforms
- Publish a markdown file they've prepared

## Trigger phrases (examples)

- "导入文章 ~/Documents/kubernetes-guide.md"
- "帮我把这篇文章添加到博客 /path/to/my-article.md"
- "import this markdown file to my blog ~/article.md"
- "把 /home/user/blog-post.md 发布到博客"
- "添加文章到博客"

## How I work

### Step 1: Validate the file path

Check if the user provided a markdown file path:

```bash
# Verify file exists
if [ ! -f "<file-path>" ]; then
  echo "错误: 文件不存在"
  exit 1
fi

# Check extension
if [[ ! "<file-path>" =~ \.md$ ]] && [[ ! "<file-path>" =~ \.markdown$ ]]; then
  echo "错误: 文件不是 Markdown 格式"
  exit 1
fi
```

**If not provided or invalid:**
- Ask: "请提供要导入的 Markdown 文件路径"
- Verify and retry

**If valid:**
- Show: `✓ 找到文件: <file-path>`

---

### Step 2: Smart front matter detection (Token-optimized)

**IMPORTANT: Only read the first 50 lines to save tokens**

Use Read tool with limit:
```
filePath: <source-file>
offset: 0
limit: 50
```

Check for front matter structure:
- Line 1 must be `---`
- Must have another `---` within first 50 lines
- Extract: title, tags, categories, author, date, draft

**Determine completeness:**
- **Complete**: Has `title` field (minimum requirement). Keep existing metadata and do not ask follow-ups.
- **Incomplete**: Missing `title` or no front matter at all. Ask user for metadata.

---

### Step 3A: Import with complete front matter (Token-saving path ⚡)

**When to use:** File has `---` ... `---` structure with at least a `title` field

**Token estimate:** ~500-800 tokens (saves 70% compared to Write)

**Commands:**

```bash
cd ~/wzh_blog/my-blog

# Extract original filename (preserve Chinese characters)
ORIGINAL_NAME=$(basename "<source-file>" .md)
ORIGINAL_NAME=$(basename "$ORIGINAL_NAME" .markdown)

# Copy file directly
cp "<source-file>" "content/posts/${ORIGINAL_NAME}.md"

# Update author to wzh001create
sed -i 's/^author:.*/author: "wzh001create"/' "content/posts/${ORIGINAL_NAME}.md"

# Add date if missing
if ! grep -q "^date:" "content/posts/${ORIGINAL_NAME}.md"; then
  CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%S+08:00")
  sed -i "/^---$/a date: $CURRENT_DATE" "content/posts/${ORIGINAL_NAME}.md"
fi

# Add draft: false if missing
if ! grep -q "^draft:" "content/posts/${ORIGINAL_NAME}.md"; then
  sed -i "/^date:/a draft: false" "content/posts/${ORIGINAL_NAME}.md"
fi
```

**Show progress:**
```
✓ 找到文件: <source-file>
✓ 检测到完整的 front matter，保留原有元数据
  - 标题: <extracted-title>
  - 标签: <extracted-tags>
  - 分类: <extracted-categories>
✓ 文章已导入到 content/posts/<filename>.md
```

**Then jump to Step 4 (handle images)**

---

### Step 3B: Import without front matter (Standard path)

**When to use:** File has no front matter OR incomplete front matter (no title)

**Token estimate:** ~2500-3000 tokens (normal Write operation)

**Ask user for metadata:**

Use Question tool or direct text:
```
需要添加文章元数据，请提供：

1. 标题 (title):
2. 标签 (tags, 逗号分隔):
3. 分类 (categories, 逗号分隔):
```

**Create file with Write tool:**

```yaml
---
title: "<user-provided-title>"
date: <current-datetime-+08:00>
draft: false
tags: ["<tag1>", "<tag2>", "<tag3>"]
categories: ["<category1>", "<category2>"]
author: "wzh001create"
---

<original-file-content>
```

**Important:**
- Use original filename (preserve Chinese characters)
- If original file had incomplete front matter, skip it and only copy the body
- Generate current date in format: `2026-01-22T19:30:00+08:00`

**Show progress:**
```
✓ 找到文件: <source-file>
✓ 已添加 front matter 元数据
✓ 文章已导入到 content/posts/<filename>.md
```

---

### Step 4: Handle images automatically

**Detect images in source directory:**

```bash
SOURCE_DIR=$(dirname "<source-file>")
ARTICLE_NAME=$(basename "<source-file>" .md | basename - .markdown)

# Check for image files
if ls "$SOURCE_DIR"/*.{png,jpg,jpeg,gif,svg,webp} 2>/dev/null | grep -q .; then
  IMAGE_COUNT=$(ls "$SOURCE_DIR"/*.{png,jpg,jpeg,gif,svg,webp} 2>/dev/null | wc -l)
  echo "检测到 $IMAGE_COUNT 张图片"
fi
```

**If images found: Automatically copy them (as per user requirement)**

```bash
# Create image directory
mkdir -p "static/images/${ARTICLE_NAME}"

# Copy all images
cp "$SOURCE_DIR"/*.{png,jpg,jpeg,gif,svg,webp} "static/images/${ARTICLE_NAME}/" 2>/dev/null

# Update image paths in the markdown
sed -i "s|\!\[\([^]]*\)\](\([^/)][^)]*\))|\![\1](/images/${ARTICLE_NAME}/\2)|g" "content/posts/${ARTICLE_NAME}.md"

echo "✓ 已复制 $IMAGE_COUNT 张图片到 static/images/${ARTICLE_NAME}/"
echo "✓ 已更新图片路径引用"
```

**If no images found:**
```
ℹ️  未检测到图片文件
```

---

### Step 5: Verify import success (Minimal token usage)

**DO NOT re-read the entire file** - just verify it exists:

```bash
ls "content/posts/<article-name>.md" && echo "✓ 文件已成功创建"
```

**Optional:** If you used Step 3A (cp + sed), you can quickly verify front matter:
```bash
head -15 "content/posts/<article-name>.md" | grep -E "^(title|author|date|draft):"
```

---

### Step 6: Ask about publishing

Use the Question tool to ask:

```
是否立即发布到 GitHub？
- 是 - 立即提交并推送
- 否 - 稍后手动发布
```

---

### Step 7: Handle publishing

**If user chooses YES:**

```bash
cd ~/wzh_blog/my-blog
git add -A
git commit -m "feat: 添加文章《<article-title>》"
git push
```

Then show:
```
✅ 导入并发布成功！

✓ 已提交更改
✓ 已推送到 GitHub
🚀 GitHub Actions 正在部署...

你的文章将在几分钟内上线：
https://wzh001create.github.io/posts/<article-slug>/

📄 文件：content/posts/<article-name>.md
🖼️  图片：static/images/<article-name>/ (如果有图片)
```

**If user chooses NO:**

```
✅ 导入成功！

📄 文件位置: content/posts/<article-name>.md
🖼️  图片目录: static/images/<article-name>/ (如果有图片)

需要发布时，请运行：
  cd ~/wzh_blog/my-blog/scripts
  ./publish.sh

或者手动执行：
  cd ~/wzh_blog/my-blog
  git add -A
  git commit -m "feat: 添加文章《<article-title>》"
  git push
```

---

## Important paths and files

- **Blog root directory**: `~/wzh_blog/my-blog/`
- **Posts directory**: `~/wzh_blog/my-blog/content/posts/`
- **Images directory**: `~/wzh_blog/my-blog/static/images/`
- **Import script** (for manual use): `~/wzh_blog/my-blog/scripts/import-post.sh`
- **Author name**: `wzh001create` (always use this)

---

## Token optimization strategy

### Path A: File with complete front matter
```
1. Read first 50 lines only (500 tokens)
2. Use cp + sed commands (50 tokens)
3. Handle images with bash (100 tokens)
4. Verify with ls (50 tokens)
Total: ~700 tokens ⚡ (70% savings)
```

### Path B: File without front matter
```
1. Read first 50 lines (500 tokens)
2. Ask user for metadata (100 tokens)
3. Write entire file (2000 tokens)
4. Handle images with bash (100 tokens)
Total: ~2700 tokens (standard)
```

**Key principle:** Avoid reading or writing the full file content unless absolutely necessary.

---

## Error handling

### File not found
```
❌ 错误: 文件不存在

检查路径: <provided-path>
请提供有效的 Markdown 文件路径。
```

### Not a markdown file
```
❌ 错误: 文件不是 Markdown 格式

文件扩展名: <extension>
请提供 .md 或 .markdown 文件。
```

### Git push fails
```
❌ 推送失败

文章已在本地导入，但未能推送到 GitHub。
错误信息: <error-output>

请检查网络连接和 Git 认证，然后手动推送：
  cd ~/wzh_blog/my-blog
  git push
```

---

## Important notes

### About the import script
- The `import-post.sh` script is **available for manual use**
- This skill does NOT call the script (to avoid interactive prompts)
- The skill uses direct file operations (cp, sed, Write) for automation

### File naming
- **Always preserve the original filename** (including Chinese characters)
- Use the filename without extension as the article slug
- Hugo will generate the URL slug automatically

### Front matter detection
- **Only read first 50 lines** to detect front matter
- Minimum requirement for "complete": must have `title` field
- If `title` exists, preserve all other fields (tags, categories, etc.)

### Image handling
- **Automatically copy images** when detected (no asking)
- Always check source directory for common image formats
- Update relative paths to `/images/<article-name>/...`

### Tools to use
- **Read**: Only with offset/limit to minimize token usage
- **Bash**: For cp, sed, ls, mkdir operations
- **Write**: Only when creating new files from scratch
- **Question**: For publishing confirmation

---

## Example interaction

**User input:**
```
导入文章 ~/Downloads/Git常用命令速查手册.md
```

**Your response (Path A - has front matter):**
```
正在导入文章...

✓ 找到文件: ~/Downloads/Git常用命令速查手册.md
✓ 检测到完整的 front matter，保留原有元数据
  - 标题: Git 常用命令速查手册
  - 标签: Git, 版本控制, 命令速查
  - 分类: 教程

正在复制文件和处理图片...
ℹ️  未检测到图片文件
✓ 文章已导入到 content/posts/Git常用命令速查手册.md

📤 是否立即发布到 GitHub？(y/N)
```

**User input:**
```
y
```

**Your response:**
```
✅ 导入并发布成功！

✓ 已提交更改
✓ 已推送到 GitHub
🚀 GitHub Actions 正在部署...

你的文章将在几分钟内上线：
https://wzh001create.github.io/posts/git常用命令速查手册/

📄 文件：content/posts/Git常用命令速查手册.md
```

---

Remember: This skill is optimized for minimal token usage while maintaining full automation. Always choose the token-saving path (cp + sed) when possible.
