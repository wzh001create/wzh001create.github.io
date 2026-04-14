# 📚 Hugo 博客使用指南

欢迎使用你的个人技术博客！本指南将帮助你快速上手博客的日常使用。

---

## 📁 目录结构

```
~/wzh_blog/
├── my-blog/                    # Hugo 博客主目录
│   ├── .opencode/skills/       # 🤖 OpenCode Skills
│   │   ├── blog-import-post/   # 导入文章 skill
│   │   └── blog-delete-post/   # 删除文章 skill
│   ├── content/
│   │   ├── posts/              # 📝 文章存放目录
│   │   ├── specials/           # 🧩 HTML 专题栏目
│   │   ├── about/              # 关于页面
│   │   └── search.md           # 搜索页面
│   ├── static/
│   │   ├── images/             # 🖼️  图片存放目录
│   │   └── *.html              # 独立 HTML 页面
│   ├── themes/PaperMod/        # 主题
│   ├── hugo.toml               # ⚙️  博客配置文件
│   └── public/                 # 生成的静态网站（自动生成）
├── scripts/                    # 🛠️  发布脚本
│   ├── new-post.sh             # 创建新文章
│   ├── import-post.sh          # 导入现有 Markdown
│   ├── word2md.sh              # Word 转 Markdown
│   └── publish.sh              # 一键发布
└── drafts/                     # 📋 草稿箱（可选）
```

---

## 🚀 快速开始

### 🤖 使用 OpenCode Skills（最简单）

如果你使用 OpenCode，可以直接用自然语言操作：

#### 导入文章

```
"导入文章 ~/Documents/kubernetes-guide.md"
"帮我把 /path/to/my-article.md 添加到博客"
```

OpenCode 会自动：
- 检测并处理 front matter（有就保留，没有就询问）
- 复制同目录下的图片到正确位置
- 更新文章中的图片路径
- 询问是否立即发布到 GitHub

#### 删除文章

```
"删除文章"
"删除 Docker 那篇文章"
```

OpenCode 会：
- 列出所有文章让你选择
- 确认后删除文章和图片
- 自动提交并推送到 GitHub

---

### 📝 使用脚本（传统方式）

#### 方式 A：创建新的 Markdown 文章

```bash
cd ~/wzh_blog/scripts
./new-post.sh
```

**交互式步骤：**
1. 输入文章标题（支持中文）
2. 输入标签（逗号分隔，可留空）
3. 输入分类（可留空）
4. 是否创建图片目录

**示例：**
```bash
$ ./new-post.sh

=== Hugo 博客文章创建工具 ===

📝 文章标题: Kubernetes 入门实战
🏷️  标签（逗号分隔，可留空）: Kubernetes, 云原生, Docker
📂 分类（可留空）: 容器技术
🖼️  是否创建图片目录? (Y/n): y

✅ 文章创建成功！

文件位置: /home/wzh111/wzh_blog/my-blog/content/posts/Kubernetes-入门实战.md
图片目录: /home/wzh111/wzh_blog/my-blog/static/images/Kubernetes-入门实战/
```

---

#### 方式 B：导入现有的 Markdown 文件

如果你已经有写好的 Markdown 文件，可以直接导入：

```bash
cd ~/wzh_blog/scripts
./import-post.sh ~/Documents/我的文章.md
```

**两种导入模式：**

**模式 1：重写 Front Matter（默认）**
```bash
./import-post.sh ~/Documents/我的文章.md
```
- 会提取或询问文章的标题、标签、分类
- 生成标准的 Hugo front matter
- 适合从其他博客平台迁移的文章

**模式 2：保留原有 Front Matter**
```bash
./import-post.sh ~/Documents/我的文章.md --keep-frontmatter
```
- 保留原文件的 front matter
- 自动更新 author 为 wzh001create
- 如果缺少 date 或 draft 字段会自动补充
- 适合已经是 Hugo 格式的文章

**功能特点：**
- ✅ 自动检测和处理 front matter
- ✅ 支持复制同目录下的图片文件
- ✅ 可选自动更新图片路径引用
- ✅ 保留中文文件名

---

### 方式 C：从 Word 文档转换

```bash
cd ~/wzh_blog/scripts
./word2md.sh ~/Documents/我的文章.docx
```

**功能特点：**
- ✅ 自动提取 Word 中的图片
- ✅ 自动转换 TIFF 格式为 PNG（需要 imagemagick）
- ✅ 交互式添加标签和分类
- ✅ 可选删除原 Word 文件

**注意事项：**
- 需要先安装 pandoc：`sudo apt install pandoc`
- 图片转换需要 imagemagick：`sudo apt install imagemagick`（可选）

---

## ✍️ 编辑文章

### 1. 文章结构

每篇文章包含两部分：**Front Matter（元信息）** 和 **正文内容**

```markdown
---
title: "文章标题"
date: 2026-01-22T10:00:00+08:00
draft: false
tags: ["标签1", "标签2"]
categories: ["分类"]
author: "wzh001create"
---

这里写文章摘要，会显示在首页...

<!--more-->

## 正文开始

这里是正文内容...
```

### 2. Front Matter 字段说明

| 字段 | 说明 | 必填 |
|------|------|------|
| `title` | 文章标题 | ✅ |
| `date` | 发布日期 | ✅ |
| `draft` | 是否为草稿（true/false） | ✅ |
| `tags` | 标签数组 | ❌ |
| `categories` | 分类数组 | ❌ |
| `author` | 作者名 | ❌ |

### 3. Markdown 常用语法

#### 标题
```markdown
## 二级标题
### 三级标题
#### 四级标题
```

#### 强调
```markdown
**粗体文字**
*斜体文字*
~~删除线~~
```

#### 列表
```markdown
- 无序列表项 1
- 无序列表项 2

1. 有序列表项 1
2. 有序列表项 2
```

#### 代码

单行代码：\`code\`

代码块：
\`\`\`python
def hello():
    print("Hello, World!")
\`\`\`

#### 引用
```markdown
> 这是引用文字
```

#### 链接
```markdown
[链接文字](https://example.com)
```

#### 图片
```markdown
![图片描述](/images/文章名/image.png)
```

---

## 🖼️ 图片管理

### 图片存放规则

每篇文章的图片应该放在对应的目录：

```
static/images/
└── 文章名/
    ├── image1.png
    ├── image2.jpg
    └── diagram.png
```

### 在文章中引用图片

```markdown
![图片描述](/images/文章名/image.png)
```

**示例：**

如果文章文件名是 `Kubernetes-入门实战.md`，图片应该放在：
```
static/images/Kubernetes-入门实战/
```

在文章中引用：
```markdown
![K8s架构图](/images/Kubernetes-入门实战/architecture.png)
```

### 图片最佳实践

- ✅ 使用英文或拼音命名图片文件
- ✅ 避免空格和特殊字符
- ✅ 推荐格式：PNG、JPG、WebP
- ✅ 压缩大图片（推荐 < 500KB）
- ❌ 避免使用中文文件名
- ❌ 避免过大的图片（> 2MB）

---

## 🧩 发布 HTML 专题页面

如果你以后要发布很多独立 HTML 页面，统一放到顶栏的 `专题` 栏目里。这样它们会像 `posts` 一样集中展示，同时每个页面仍然可以保留自己的原始 HTML 文件。

### 目录约定

```text
content/specials/                # 专题列表与条目入口
static/xxx.html                  # 原始 HTML 页面
```

### 推荐发布流程

#### 1. 放置原始 HTML 文件

例如：

```bash
static/git.html
static/demo-canvas.html
static/three-scene.html
```

这些文件发布后会直接对应：

```text
/git.html
/demo-canvas.html
/three-scene.html
```

#### 2. 创建专题入口页

为每个 HTML 页面创建一个 Hugo 条目页，例如：

```bash
content/specials/git-guide/index.md
```

示例模板：

```markdown
---
title: "Git 学习向导"
date: 2026-04-14T12:00:00+08:00
draft: false
description: "VS Code Git 与 Git Bash 对照学习向导"
summary: "显示在专题列表页中的一句摘要。"
aliases: ["/git/"]
---

这里写这个专题的介绍。

如果你想直接打开原始页面，也可以放一个链接：[打开独立版](/git.html)

<div class="special-embed">
  <iframe src="/git.html" title="Git 学习向导" loading="lazy"></iframe>
</div>

<style>
  .special-embed iframe {
    width: 100%;
    height: 80vh;
    border: 0;
  }
</style>
```

### 字段说明

- `title`：专题标题，会显示在列表和详情页
- `description`：页面说明
- `summary`：显示在 `/specials/` 列表中的摘要
- `aliases`：可选，用于兼容旧链接，例如保留 `/git/`

### 发布后的访问路径

- 专题列表：`/specials/`
- 专题详情：`/specials/<slug>/`
- 原始 HTML：`/xxx.html`

### 当前示例

- 列表页：`https://wzh001create.github.io/specials/`
- 详情页：`https://wzh001create.github.io/specials/git-guide/`
- 原始 HTML：`https://wzh001create.github.io/git.html`

### 什么时候用这种方式

- 页面是完整的 HTML/CSS/JS 成品
- 页面交互很多，不适合拆成 Markdown
- 想保留原始前端效果，同时接入站点导航和内容聚合

---

## 👀 本地预览

在发布前，可以先本地预览效果：

```bash
cd ~/wzh_blog/my-blog
hugo server -D
```

然后在浏览器打开：`http://localhost:1313`

**参数说明：**
- `-D`：显示草稿（draft: true）
- `--bind 0.0.0.0`：允许外部访问

**停止预览：** 按 `Ctrl + C`

---

## 📤 发布文章

### 方式 1：一键发布（推荐）

```bash
cd ~/wzh_blog/scripts
./publish.sh
```

**脚本会自动：**
1. ✅ 检测更改的文件
2. ✅ 询问是否预览
3. ✅ 构建静态网站
4. ✅ 生成提交信息
5. ✅ 推送到 GitHub
6. ✅ 自动触发部署

### 方式 2：带预览的发布

```bash
cd ~/wzh_blog/scripts
./publish.sh --preview
```

会先启动本地服务器预览，按 `Ctrl+C` 停止后继续发布流程。

### 方式 3：手动发布

```bash
cd ~/wzh_blog/my-blog

# 1. 构建
hugo --gc --minify

# 2. 提交
git add .
git commit -m "发布：文章标题"
git push

# 3. 等待部署（1-2分钟）
```

---

## 🌐 查看博客

### 访问地址
**https://wzh001create.github.io/**

### 专题栏目
**https://wzh001create.github.io/specials/**

### 查看部署状态
**https://github.com/wzh001create/wzh001create.github.io/actions**

部署通常需要 1-2 分钟完成。

---

## 🔧 常见操作

### 修改已发布的文章

1. 编辑文章文件：
   ```bash
   vim ~/wzh_blog/my-blog/content/posts/文章名.md
   ```

2. 发布更新：
   ```bash
   cd ~/wzh_blog/scripts
   ./publish.sh
   ```

### 删除文章

1. 删除文件：
   ```bash
   rm ~/wzh_blog/my-blog/content/posts/文章名.md
   rm -rf ~/wzh_blog/my-blog/static/images/文章名/
   ```

2. 发布更改：
   ```bash
   cd ~/wzh_blog/scripts
   ./publish.sh
   ```

### 设置文章为草稿

在文章的 Front Matter 中设置：
```yaml
draft: true
```

草稿不会出现在已发布的网站上，但可以在本地预览（`hugo server -D`）。

### 修改博客配置

编辑配置文件：
```bash
vim ~/wzh_blog/my-blog/hugo.toml
```

**常用配置项：**
- `title`：网站标题
- `params.description`：网站描述
- `params.author`：作者名
- `params.socialIcons`：社交链接

修改后记得重新发布。

### 更新"关于"页面

```bash
vim ~/wzh_blog/my-blog/content/about/index.md
```

---

## 📋 完整工作流示例

### 场景 1：发布一篇新的技术文章

```bash
# 1. 创建文章
cd ~/wzh_blog/scripts
./new-post.sh "Docker 容器化实战"

# 输入标签: Docker, 容器化, DevOps
# 输入分类: 实战教程
# 创建图片目录: y

# 2. 编辑文章
vim ~/wzh_blog/my-blog/content/posts/Docker-容器化实战.md

# 3. 添加图片（如果有）
cp ~/Pictures/docker-arch.png ~/wzh_blog/my-blog/static/images/Docker-容器化实战/

# 4. 预览效果
cd ~/wzh_blog/my-blog
hugo server -D
# 浏览器打开 http://localhost:1313 查看

# 5. 发布
cd ~/wzh_blog/scripts
./publish.sh

# 6. 访问网站查看
# https://wzh001create.github.io/
```

### 场景 2：从 Word 文档发布

```bash
# 1. 转换 Word 文档
cd ~/wzh_blog/scripts
./word2md.sh ~/Documents/我的技术分享.docx

# 输入标签: Python, 数据分析
# 输入分类: 教程
# 删除原文件: y

# 2. 检查并编辑（可选）
vim ~/wzh_blog/my-blog/content/posts/我的技术分享.md

# 3. 发布
./publish.sh
```

---

## ⚠️ 常见问题

### Q1: pandoc 未安装怎么办？

```bash
sudo apt update
sudo apt install pandoc
```

### Q2: 图片无法显示？

检查：
1. 图片路径是否正确：`/images/文章名/图片.png`
2. 图片文件是否存在于 `static/images/文章名/` 目录
3. 文件名是否包含特殊字符或空格

### Q3: 推送失败 "permission denied"？

确保 SSH 密钥已添加到 GitHub：
```bash
cat ~/.ssh/id_ed25519.pub
```
复制输出内容，添加到 GitHub Settings → SSH Keys

### Q4: 网站没有更新？

1. 检查 GitHub Actions 是否运行成功
2. 等待 1-2 分钟让部署完成
3. 清除浏览器缓存后刷新

### Q5: 文章没有显示在首页？

检查文章的 Front Matter：
- `draft: false`（不是 true）
- `date` 不是未来时间

### Q6: HTML 专题页打不开或显示空白？

检查：
1. 原始文件是否真的在 `static/xxx.html`
2. 入口页里的 `iframe src="/xxx.html"` 是否写对
3. 专题入口文件是否位于 `content/specials/<slug>/index.md`
4. `draft` 是否为 `false`
5. GitHub Pages 部署是否成功

---

## 🎨 自定义博客

### 更换主题

编辑 `hugo.toml`：
```toml
theme = "主题名"
```

克隆新主题到 `themes/` 目录。

### 修改配色

PaperMod 主题支持自定义 CSS。创建文件：
```bash
mkdir -p ~/wzh_blog/my-blog/assets/css/extended
vim ~/wzh_blog/my-blog/assets/css/extended/custom.css
```

添加自定义样式。

### 添加评论系统

参考 PaperMod 文档配置 Disqus、utterances 等评论系统。

---

## 📚 学习资源

- **Hugo 官方文档**: https://gohugo.io/documentation/
- **PaperMod 主题文档**: https://github.com/adityatelange/hugo-PaperMod
- **Markdown 语法**: https://www.markdownguide.org/
- **GitHub Pages 文档**: https://docs.github.com/pages

---

## 🆘 获取帮助

如果遇到问题：

1. 查看本指南的"常见问题"部分
2. 检查 Hugo 构建日志：`hugo --verbose`
3. 查看 GitHub Actions 构建日志
4. 搜索相关问题或咨询 AI 助手

---

**祝你写作愉快！✨**
