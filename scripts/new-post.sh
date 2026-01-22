#!/bin/bash

# new-post.sh - 创建新博客文章
# 使用方法: ./new-post.sh [文章标题]

set -e

# 配置
BLOG_DIR="$HOME/wzh_blog/my-blog"
CONTENT_DIR="$BLOG_DIR/content/posts"
IMAGES_DIR="$BLOG_DIR/static/images"
AUTHOR="wzh001create"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Hugo 博客文章创建工具 ===${NC}\n"

# 获取文章标题
if [ -z "$1" ]; then
    read -p "📝 文章标题: " TITLE
else
    TITLE="$1"
fi

if [ -z "$TITLE" ]; then
    echo -e "${YELLOW}❌ 标题不能为空${NC}"
    exit 1
fi

# 生成文件名（保持中文，转换空格为连字符）
FILENAME=$(echo "$TITLE" | sed 's/ /-/g' | sed 's/[?？]//g')
FILEPATH="$CONTENT_DIR/${FILENAME}.md"

# 检查文件是否已存在
if [ -f "$FILEPATH" ]; then
    echo -e "${YELLOW}⚠️  文件已存在: $FILEPATH${NC}"
    read -p "是否覆盖? (y/N): " OVERWRITE
    if [ "$OVERWRITE" != "y" ] && [ "$OVERWRITE" != "Y" ]; then
        echo "取消操作"
        exit 0
    fi
fi

# 交互式获取标签
read -p "🏷️  标签（逗号分隔，可留空）: " TAGS_INPUT
if [ -n "$TAGS_INPUT" ]; then
    # 将逗号分隔的标签转换为 YAML 数组格式
    TAGS=$(echo "$TAGS_INPUT" | awk -F',' '{for(i=1;i<=NF;i++){gsub(/^[ \t]+|[ \t]+$/,"",$i); printf "\"%s\", ", $i}}' | sed 's/, $//')
    TAGS="[$TAGS]"
else
    TAGS="[]"
fi

# 交互式获取分类
read -p "📂 分类（可留空）: " CATEGORY
if [ -n "$CATEGORY" ]; then
    CATEGORY_LINE="categories: [\"$CATEGORY\"]"
else
    CATEGORY_LINE="categories: []"
fi

# 询问是否需要图片目录
read -p "🖼️  是否创建图片目录? (Y/n): " CREATE_IMG_DIR
if [ "$CREATE_IMG_DIR" != "n" ] && [ "$CREATE_IMG_DIR" != "N" ]; then
    mkdir -p "$IMAGES_DIR/$FILENAME"
    echo -e "${GREEN}✓ 已创建图片目录: static/images/$FILENAME/${NC}"
fi

# 获取当前时间
CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%S%:z")

# 生成 Markdown 文件
cat > "$FILEPATH" <<EOF
---
title: "$TITLE"
date: $CURRENT_DATE
draft: false
tags: $TAGS
$CATEGORY_LINE
author: "$AUTHOR"
---

在这里写文章摘要，会显示在首页和列表页...

<!--more-->

## 正文开始

在这里开始写你的文章内容...

### 小标题示例

内容示例...

#### 代码示例

\`\`\`python
def hello():
    print("Hello, World!")
\`\`\`

#### 图片示例

如果你创建了图片目录，可以这样引用图片：

![图片描述](/images/$FILENAME/image.png)

#### 引用示例

> 这是一段引用文字

#### 列表示例

- 项目 1
- 项目 2
- 项目 3

EOF

echo ""
echo -e "${GREEN}✅ 文章创建成功！${NC}"
echo ""
echo -e "${BLUE}文件位置:${NC} $FILEPATH"
if [ "$CREATE_IMG_DIR" != "n" ] && [ "$CREATE_IMG_DIR" != "N" ]; then
    echo -e "${BLUE}图片目录:${NC} $IMAGES_DIR/$FILENAME/"
fi
echo ""
echo -e "${YELLOW}下一步操作:${NC}"
echo "  1. 编辑文章: vim $FILEPATH"
echo "  2. 本地预览: cd $BLOG_DIR && hugo server -D"
echo "  3. 发布文章: cd ~/wzh_blog/scripts && ./publish.sh"
echo ""
