# 📝 wzh001create 的技术博客

这是一个使用 Hugo + PaperMod 主题搭建的个人技术博客，部署在 GitHub Pages 上。

**网站地址：** https://wzh001create.github.io/

---

## 🚀 快速开始

### 方式 1：使用 OpenCode Skills（推荐）

如果你使用 OpenCode，可以用自然语言直接操作：

```bash
# 导入现有的 Markdown 文章
"导入文章 ~/Documents/my-article.md"

# 删除文章
"删除文章"
"删除 Docker 那篇文章"

# 编辑文章
"编辑文章"
"把文章标题改成 xxx"
```

OpenCode 会自动：
- 处理 front matter 和图片
- 询问是否立即发布（导入时）
- 自动提交并推送到 GitHub（删除时）
- 编辑文章并询问是否发布

### 方式 2：使用脚本

#### 创建新文章

```bash
cd ~/wzh_blog/scripts
./new-post.sh
```

#### 导入现有文章

```bash
cd ~/wzh_blog/scripts
./import-post.sh ~/Documents/my-article.md
```

#### 发布文章

```bash
cd ~/wzh_blog/scripts
./publish.sh
```

#### 从 Word 转换

```bash
cd ~/wzh_blog/scripts
./word2md.sh ~/Documents/文章.docx
```

---

## 📚 文档

- **[📖 完整使用指南](./BLOG_GUIDE.md)** - 详细的博客使用说明
- **[🚀 部署 Prompt](./DEPLOY_PROMPT.md)** - 给朋友的一键部署指南
- **[⚙️  Pandoc 安装](./INSTALL_PANDOC.md)** - Word 转换工具安装

---

## 📁 项目结构

```
wzh001create.github.io/
├── .github/workflows/hugo.yml         # GitHub Pages 部署工作流
├── content/
│   ├── posts/                         # Markdown 文章
│   ├── specials/                      # HTML 专题栏目
│   │   ├── _index.md                  # 专题列表页
│   │   └── git-guide/index.md         # Git 专题入口页
│   ├── about/                         # 关于页面
│   └── search.md                      # 搜索页面
├── static/
│   ├── images/                        # 图片资源
│   └── git.html                       # 原始 HTML 页面示例
├── themes/PaperMod/                   # Hugo 主题
├── BLOG_GUIDE.md                      # 使用指南
├── DEPLOY_PROMPT.md                   # 部署 Prompt
├── README.md                          # 项目说明
└── hugo.toml                          # 站点配置
```

---

## 🤖 OpenCode Skills

本项目包含三个 OpenCode Skills，让博客管理更加智能和便捷。

### blog-import-post - 导入文章

用自然语言导入现有的 Markdown 文章到博客。

**触发方式：**
```
"导入文章 ~/Documents/kubernetes-guide.md"
"帮我把这篇文章添加到博客 /path/to/my-article.md"
```

**自动处理：**
- ✅ 智能检测和处理 front matter（有就保留，没有就询问）
- ✅ 自动复制同目录下的图片到 static/images/
- ✅ 自动更新文章中的图片路径引用
- ✅ 询问是否立即发布到 GitHub

### blog-delete-post - 删除文章

交互式删除博客文章，自动清理图片并发布。

**触发方式：**
```
"删除文章"
"删除 Docker 那篇文章"
"帮我移除某篇博客"
```

**自动处理：**
- ✅ 列出所有文章供选择（支持序号/标题/关键词）
- ✅ 确认后删除文章文件和图片目录
- ✅ 自动提交并推送到 GitHub
- ✅ 显示删除成功信息

### blog-edit-post - 编辑文章

自由编辑文章内容或元数据，必要时再询问细节。

**触发方式：**
```
"编辑文章"
"修改 Git 那篇文章"
"把文章标题改成 xxx"
```

**自动处理：**
- ✅ 总是列出所有文章供选择
- ✅ 直接按用户描述编辑内容
- ✅ 询问是否立即发布到 GitHub

**Skills 位置：** `.opencode/skills/`

---

## 🛠️ 工具脚本

### 1. new-post.sh - 创建新文章

交互式创建新的 Markdown 文章，自动生成 front matter。

**功能：**
- ✅ 自动生成文章元信息
- ✅ 交互式输入标签和分类
- ✅ 自动创建图片目录
- ✅ 支持中文文件名

**使用示例：**
```bash
./new-post.sh "Kubernetes 入门实战"
```

### 2. import-post.sh - 导入现有 Markdown

导入已有的 Markdown 文件到博客，支持保留或重写 front matter。

**功能：**
- ✅ 自动检测和处理 front matter
- ✅ 支持复制同目录下的图片
- ✅ 自动更新图片路径引用
- ✅ 保留中文文件名

**使用示例：**
```bash
# 重写 front matter（默认）
./import-post.sh ~/Documents/我的文章.md

# 保留原有 front matter
./import-post.sh ~/Documents/我的文章.md --keep-frontmatter
```

### 3. word2md.sh - Word 转 Markdown

将 Word 文档转换为 Markdown 格式，自动提取图片。

**功能：**
- ✅ 自动提取 Word 中的图片
- ✅ 自动转换 TIFF 格式为 PNG
- ✅ 交互式添加元信息
- ✅ 可选删除原 Word 文件

**前置要求：**
```bash
sudo apt install pandoc
sudo apt install imagemagick  # 可选
```

**使用示例：**
```bash
./word2md.sh ~/Documents/我的技术文章.docx
```

### 4. publish.sh - 一键发布

自动构建、提交并推送到 GitHub。

**功能：**
- ✅ 自动检测更改
- ✅ 可选本地预览
- ✅ 自动生成提交信息
- ✅ 一键推送部署

**使用示例：**
```bash
# 直接发布
./publish.sh

# 先预览再发布
./publish.sh --preview
```

---

## 📝 写作流程

### 场景 1：Markdown 写作（推荐）

```bash
# 1. 创建文章
cd ~/wzh_blog/scripts
./new-post.sh "我的新文章"

# 2. 编辑文章
vim ~/wzh_blog/my-blog/content/posts/我的新文章.md

# 3. 添加图片（可选）
cp image.png ~/wzh_blog/my-blog/static/images/我的新文章/

# 4. 发布
./publish.sh
```

### 场景 2：Word 转换

```bash
# 1. 转换 Word
cd ~/wzh_blog/scripts
./word2md.sh ~/Documents/文章.docx

# 2. 检查并编辑（可选）
vim ~/wzh_blog/my-blog/content/posts/文章.md

# 3. 发布
./publish.sh
```

---

## 🖼️ 图片管理

### 存放位置

```
static/images/
└── 文章名/
    ├── image1.png
    └── image2.jpg
```

### 引用方式

```markdown
![图片描述](/images/文章名/image.png)
```

---

## 🧩 HTML 专题发布

除了常规 Markdown 文章，这个站点现在也支持发布独立 HTML 页面，并统一收纳到顶栏的 `专题` 栏目中。

### 发布规则

1. 原始 HTML 文件放到 `static/` 目录，例如：`static/git.html`
2. 在 `content/specials/<slug>/index.md` 创建一个 Hugo 入口页
3. 入口页负责提供标题、摘要、列表展示，以及用 `iframe` 嵌入原始 HTML
4. 发布后可以通过 `/specials/` 像 `posts` 一样集中查看

### 当前示例

- 原始页面：`/git.html`
- 栏目入口：`/specials/git-guide/`
- 栏目列表：`/specials/`

### 入口页模板

```markdown
---
title: "页面标题"
date: 2026-04-14T12:00:00+08:00
draft: false
description: "页面简介"
summary: "显示在专题列表中的摘要"
aliases: ["/old-path/"]
---

这里写入口页说明文字。

<iframe src="/your-page.html" title="页面标题"></iframe>
```

### 适用场景

- 交互式教程
- 单页演示页
- 纯 HTML/CSS/JS 作品展示
- 不适合改造成 Markdown 的独立页面

更完整的操作步骤见 [BLOG_GUIDE.md](./BLOG_GUIDE.md)。

---

## 🌐 网站信息

- **网站地址：** https://wzh001create.github.io/
- **专题栏目：** https://wzh001create.github.io/specials/
- **GitHub 仓库：** https://github.com/wzh001create/wzh001create.github.io
- **部署状态：** https://github.com/wzh001create/wzh001create.github.io/actions

---

## 🎨 特性

- ✅ 简洁现代的 PaperMod 主题
- ✅ 深色/浅色模式自动切换
- ✅ 响应式设计，完美支持移动端
- ✅ 全文搜索功能
- ✅ 代码高亮（Monokai 主题）
- ✅ 自动生成目录（TOC）
- ✅ `专题` 栏目聚合独立 HTML 页面
- ✅ 阅读时间估算
- ✅ 社交分享按钮
- ✅ RSS 订阅支持
- ✅ SEO 优化

---

## 🔧 常用命令

### 本地预览

```bash
cd ~/wzh_blog/my-blog
hugo server -D
# 访问 http://localhost:1313
```

### 手动构建

```bash
cd ~/wzh_blog/my-blog
hugo --gc --minify
```

### 检查 Git 状态

```bash
cd ~/wzh_blog/my-blog
git status
```

---

## 📦 技术栈

- **静态站点生成器：** [Hugo](https://gohugo.io/) v0.150.0+
- **主题：** [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
- **托管：** [GitHub Pages](https://pages.github.com/)
- **CI/CD：** [GitHub Actions](https://github.com/features/actions)
- **文档转换：** [Pandoc](https://pandoc.org/)

---

## 📚 学习资源

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [PaperMod 主题文档](https://github.com/adityatelane/hugo-PaperMod/wiki)
- [Markdown 语法指南](https://www.markdownguide.org/)
- [GitHub Pages 文档](https://docs.github.com/pages)

---

## 🤝 分享给朋友

如果你的朋友也想搭建相同风格的博客，可以把 `DEPLOY_PROMPT.md` 发送给他们，按照里面的 prompt 指导 AI 助手完成搭建。

---

## 📄 许可证

本项目遵循 MIT 许可证。

---

**Happy Blogging! ✨**
