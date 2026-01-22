# ⚙️ 安装 Pandoc 指南

Pandoc 是 Word 转 Markdown 功能所必需的工具。

## Ubuntu/Debian 系统

```bash
sudo apt update
sudo apt install pandoc
```

## 验证安装

```bash
pandoc --version
```

应该看到类似输出：
```
pandoc 2.x.x
...
```

## 可选：安装 ImageMagick（用于图片格式转换）

```bash
sudo apt install imagemagick
```

ImageMagick 可以自动将 Word 中的 TIFF 格式图片转换为 PNG。

## 如果不想安装 Pandoc

如果你主要使用 Markdown 写作，可以不安装 pandoc。直接使用 `new-post.sh` 创建文章即可。

Word 转换功能（`word2md.sh`）只在需要从 Word 文档转换时才用到。
