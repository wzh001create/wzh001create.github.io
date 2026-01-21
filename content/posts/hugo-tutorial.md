---
title: "Hugo 博客搭建指南：从零到部署"
date: 2026-01-21T10:00:00+08:00
draft: false
summary: "一篇完整的 Hugo 静态博客搭建教程，包括安装、配置、主题定制和 GitHub Pages 部署。"
---

## 为什么选择 Hugo

在众多静态站点生成器中，Hugo 以其**极速构建**和**简单易用**著称。相比 Jekyll 需要 Ruby 环境、Hexo 需要 Node.js，Hugo 只需一个二进制文件即可运行。

### Hugo 的优势

- **构建速度快**：毫秒级构建，即使有上千篇文章也能秒级完成
- **零依赖**：单个可执行文件，无需安装运行时环境
- **灵活的模板系统**：基于 Go template，功能强大
- **活跃的社区**：丰富的主题和插件生态

## 快速开始

### 1. 安装 Hugo

```bash
# Ubuntu/Debian
sudo apt install hugo

# macOS
brew install hugo

# 验证安装
hugo version
```

### 2. 创建新站点

```bash
hugo new site my-blog
cd my-blog
```

### 3. 添加内容

```bash
hugo new posts/hello-world.md
```

编辑生成的 Markdown 文件，添加你的内容。

### 4. 本地预览

```bash
hugo server -D
```

打开浏览器访问 `http://localhost:1313` 即可预览。

## 部署到 GitHub Pages

1. 在 GitHub 创建仓库 `<username>.github.io`
2. 生成静态文件：`hugo`
3. 将 `public` 目录推送到仓库
4. 在仓库设置中启用 GitHub Pages

## 总结

Hugo 是一个高效、灵活的静态博客工具，特别适合技术博客。配合 GitHub Pages，可以零成本搭建个人博客，专注于内容创作。

如果你有任何问题，欢迎通过[联系页面](/contact/)与我交流。
