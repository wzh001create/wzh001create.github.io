# 🤖 OpenCode Skills 使用指南

本博客项目包含三个 OpenCode Skills，让你可以用自然语言轻松管理博客文章。

---

## 📦 已安装的 Skills

### 1. blog-import-post - 导入文章

**用途：** 将现有的 Markdown 文件导入到博客

**触发示例：**
```
导入文章 ~/Documents/kubernetes-guide.md
帮我把 /path/to/my-article.md 添加到博客
import this markdown file to my blog ~/article.md
```

**自动处理：**
- ✅ 智能检测 front matter（有就保留，没有就询问）
- ✅ 自动复制同目录下的图片文件（无需确认）
- ✅ 自动更新文章中的图片路径为 `/images/<文章名>/...`
- ✅ 询问是否立即发布到 GitHub

**工作流程：**
1. 检查文件是否存在和有效
2. 检测 front matter 状态
3. 直接导入（保留原文件名，不询问文件名）
4. 自动处理图片（复制和更新路径）
5. 询问是否发布
   - 如果是：自动 `git add + commit + push`
   - 如果否：提示手动发布方法

---

### 2. blog-delete-post - 删除文章

**用途：** 从博客中删除文章（包括图片）

**触发示例：**
```
删除文章
删除 Docker 那篇文章
帮我移除某篇博客
delete the kubernetes post
```

**自动处理：**
- ✅ 列出所有文章（序号 + 标题 + 文件名）
- ✅ 支持多种选择方式（序号/标题/关键词）
- ✅ 确认后删除文章和图片目录
- ✅ 自动提交并推送到 GitHub

**工作流程：**
1. 列出 `content/posts/` 下的所有文章
2. 提取每篇文章的标题
3. 让用户选择要删除的文章
4. 确认删除操作
5. 删除 `.md` 文件和 `static/images/<文章名>/` 目录
6. 自动 `git add + commit + push`

---

### 3. blog-edit-post - 编辑文章

**用途：** 编辑现有文章内容或元数据

**触发示例：**
```
编辑文章
修改 Git 那篇文章
把文章标题改成 xxx
```

**自动处理：**
- ✅ 总是列出所有文章供选择
- ✅ 支持自由编辑（标题/标签/正文/图片）
- ✅ 仅在不明确时询问细节
- ✅ 询问是否立即发布到 GitHub

**工作流程：**
1. 列出 `content/posts/` 下的所有文章
2. 用户选择文章
3. 根据用户请求直接修改（必要时再询问）
4. 询问是否发布

---

## 🎯 使用场景

### 场景 1：分享本地写好的文章

```bash
# 在 OpenCode 中直接说：
"导入文章 ~/Documents/我的新文章.md"

# OpenCode 会自动：
# 1. 检查文章是否有 front matter
# 2. 如果没有，询问标题、标签、分类
# 3. 复制同目录下的图片
# 4. 询问："是否立即发布到 GitHub？(y/N)"
```

### 场景 2：删除旧文章

```bash
# 在 OpenCode 中直接说：
"删除文章"

# OpenCode 会：
# 1. 列出所有文章：
#    1. Docker 化迁移实战：将 C++ 项目容器化 (my-first-post.md)
#    2. Kubernetes 入门教程 (kubernetes-tutorial.md)
#
# 2. 你输入序号或关键词：2
# 3. 确认删除
# 4. 自动删除并推送到 GitHub
```

### 场景 3：快速删除特定文章

```bash
# 直接指定关键词：
"删除 Docker 那篇文章"

# OpenCode 会：
# 1. 自动匹配包含 "Docker" 的文章
# 2. 显示匹配结果并确认
# 3. 删除并自动发布
```

### 场景 4：编辑文章

```bash
# 在 OpenCode 中直接说：
"编辑文章"

# OpenCode 会：
# 1. 列出所有文章
# 2. 你选择文章
# 3. 直接按你的描述修改内容
# 4. 询问是否发布
```

---

## 🔧 技术细节

### Skills 文件位置

```
~/wzh_blog/my-blog/.opencode/skills/
├── blog-import-post/
│   └── SKILL.md
├── blog-delete-post/
│   └── SKILL.md
└── blog-edit-post/
    └── SKILL.md
```

### 与现有脚本的关系

- **blog-import-post** 直接使用 Bash + Read/Write（不调用脚本）
- **blog-delete-post** 使用 Bash 直接操作文件和 Git
- **blog-edit-post** 使用 Read/Edit 修改文章
- 脚本保留供手动使用

### 重要路径

- **博客根目录**: `~/wzh_blog/my-blog/`
- **文章目录**: `~/wzh_blog/my-blog/content/posts/`
- **图片目录**: `~/wzh_blog/my-blog/static/images/`
- **脚本目录**: `~/wzh_blog/my-blog/scripts/`

---

## ❓ 常见问题

### Q: Skills 什么时候生效？

A: 当你在博客项目目录（`~/wzh_blog/my-blog/`）中使用 OpenCode 时，Skills 会自动加载。OpenCode 会检测 `.opencode/skills/` 目录下的所有 SKILL.md 文件。

### Q: 如何知道 Skills 是否已加载？

A: 你可以在 OpenCode 中询问：
```
"你有哪些 skills？"
"list available skills"
```

OpenCode 应该会列出 `blog-import-post`、`blog-delete-post` 和 `blog-edit-post`。

### Q: 导入文章时，如果图片路径是绝对路径怎么办？

A: `import-post.sh` 脚本会尝试更新文章中的相对路径引用。如果是绝对路径（如 `C:\Users\...`），可能需要手动调整。建议：
1. 把图片和 markdown 文件放在同一目录
2. 使用相对路径引用：`![图片](./image.png)`

### Q: 删除文章是否可以恢复？

A: 删除操作会立即推送到 GitHub，但你可以通过 Git 历史恢复：
```bash
cd ~/wzh_blog/my-blog
git log --oneline  # 找到删除前的 commit
git checkout <commit-hash> -- content/posts/<文章名>.md
git checkout <commit-hash> -- static/images/<文章名>/
```

### Q: 能否同时导入多篇文章？

A: 当前版本每次导入一篇。如果需要批量导入，可以多次使用 skill，或直接使用脚本：
```bash
cd ~/wzh_blog/my-blog/scripts
for file in ~/Documents/*.md; do
  ./import-post.sh "$file"
done
```

### Q: 导入时不想立即发布怎么办？

A: 当 OpenCode 询问"是否立即发布到 GitHub？"时，回答 `n` 或 `no`。之后可以：
- 继续导入其他文章
- 一起发布：`cd ~/wzh_blog/my-blog/scripts && ./publish.sh`

---

## 🚀 快速开始

1. **确保在正确的目录**
   ```bash
   cd ~/wzh_blog/my-blog
   opencode
   ```

2. **导入你的第一篇文章**
   ```
   导入文章 ~/Documents/my-first-article.md
   ```

3. **删除测试文章**
   ```
   删除文章
   ```

就是这么简单！

---

## 📚 更多资源

- **[README.md](./README.md)** - 项目概览
- **[BLOG_GUIDE.md](./BLOG_GUIDE.md)** - 完整使用指南
- **[DEPLOY_PROMPT.md](./DEPLOY_PROMPT.md)** - 部署指南

---

**提示：** Skills 使用自然语言触发，不需要记住复杂的命令。告诉 OpenCode 你想做什么，它会理解并执行！
