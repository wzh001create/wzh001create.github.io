#!/bin/bash

# word2md.sh - 将 Word 文档转换为 Markdown 格式
# 使用方法: ./word2md.sh <word文件路径>

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
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Word 转 Markdown 工具 ===${NC}\n"

# 检查 pandoc 是否安装
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}❌ 错误: pandoc 未安装${NC}"
    echo ""
    echo "请先安装 pandoc:"
    echo "  sudo apt install pandoc"
    echo ""
    exit 1
fi

# 检查参数
if [ -z "$1" ]; then
    echo -e "${YELLOW}使用方法: ./word2md.sh <word文件路径>${NC}"
    exit 1
fi

WORD_FILE="$1"

# 检查文件是否存在
if [ ! -f "$WORD_FILE" ]; then
    echo -e "${RED}❌ 文件不存在: $WORD_FILE${NC}"
    exit 1
fi

# 检查文件格式
if [[ ! "$WORD_FILE" =~ \.(docx|doc)$ ]]; then
    echo -e "${YELLOW}⚠️  警告: 文件可能不是 Word 文档${NC}"
    read -p "是否继续? (y/N): " CONTINUE
    if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
        exit 0
    fi
fi

# 从文件名提取标题
BASENAME=$(basename "$WORD_FILE")
DEFAULT_TITLE="${BASENAME%.*}"

echo -e "${GREEN}📄 检测到文件: $BASENAME${NC}\n"

# 交互式获取信息
read -p "📝 文章标题 [默认: $DEFAULT_TITLE]: " TITLE
TITLE=${TITLE:-$DEFAULT_TITLE}

# 生成文件名
FILENAME=$(echo "$TITLE" | sed 's/ /-/g' | sed 's/[?？]//g')

# 获取标签和分类
read -p "🏷️  标签（逗号分隔）: " TAGS_INPUT
if [ -n "$TAGS_INPUT" ]; then
    TAGS=$(echo "$TAGS_INPUT" | awk -F',' '{for(i=1;i<=NF;i++){gsub(/^[ \t]+|[ \t]+$/,"",$i); printf "\"%s\", ", $i}}' | sed 's/, $//')
    TAGS="[$TAGS]"
else
    TAGS="[]"
fi

read -p "📂 分类: " CATEGORY
if [ -n "$CATEGORY" ]; then
    CATEGORY_LINE="categories: [\"$CATEGORY\"]"
else
    CATEGORY_LINE="categories: []"
fi

# 创建临时目录
TEMP_DIR=$(mktemp -d)
TEMP_MD="$TEMP_DIR/content.md"
IMG_EXTRACT_DIR="$TEMP_DIR/media"

echo ""
echo -e "${BLUE}🔄 正在转换文档...${NC}"

# 使用 pandoc 转换，提取图片
pandoc "$WORD_FILE" \
    -f docx \
    -t markdown \
    --extract-media="$TEMP_DIR" \
    -o "$TEMP_MD" \
    --wrap=none

# 创建图片目录
mkdir -p "$IMAGES_DIR/$FILENAME"

# 处理图片
if [ -d "$IMG_EXTRACT_DIR" ]; then
    echo -e "${BLUE}🖼️  正在处理图片...${NC}"
    
    IMG_COUNT=0
    for img in "$IMG_EXTRACT_DIR"/*; do
        if [ -f "$img" ]; then
            IMG_COUNT=$((IMG_COUNT + 1))
            IMG_BASENAME=$(basename "$img")
            IMG_EXT="${IMG_BASENAME##*.}"
            
            # 如果是 TIFF 格式，尝试转换为 PNG
            if [[ "$IMG_EXT" == "tiff" || "$IMG_EXT" == "tif" ]]; then
                NEW_NAME="image_${IMG_COUNT}.png"
                if command -v convert &> /dev/null; then
                    convert "$img" "$IMAGES_DIR/$FILENAME/$NEW_NAME"
                    echo "  ✓ 转换并保存: $NEW_NAME (TIFF → PNG)"
                else
                    cp "$img" "$IMAGES_DIR/$FILENAME/image_${IMG_COUNT}.${IMG_EXT}"
                    echo "  ✓ 保存: image_${IMG_COUNT}.${IMG_EXT}"
                    echo "    (提示: 安装 imagemagick 可自动转换 TIFF 格式)"
                fi
            else
                NEW_NAME="image_${IMG_COUNT}.${IMG_EXT}"
                cp "$img" "$IMAGES_DIR/$FILENAME/$NEW_NAME"
                echo "  ✓ 保存: $NEW_NAME"
            fi
        fi
    done
    
    if [ $IMG_COUNT -gt 0 ]; then
        echo -e "${GREEN}✓ 已提取 $IMG_COUNT 张图片到: static/images/$FILENAME/${NC}"
    fi
fi

# 修正图片路径
sed -i "s|$TEMP_DIR/media|/images/$FILENAME|g" "$TEMP_MD"
sed -i "s|!\[\](|![图片](|g" "$TEMP_MD"

# 读取转换后的内容
CONTENT=$(cat "$TEMP_MD")

# 获取当前时间
CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%S%:z")

# 生成最终的 Markdown 文件
FILEPATH="$CONTENT_DIR/${FILENAME}.md"

cat > "$FILEPATH" <<EOF
---
title: "$TITLE"
date: $CURRENT_DATE
draft: false
tags: $TAGS
$CATEGORY_LINE
author: "$AUTHOR"
---

<!--more-->

$CONTENT
EOF

# 清理临时文件
rm -rf "$TEMP_DIR"

# 询问是否删除原 Word 文件
echo ""
read -p "🗑️  是否删除原 Word 文件? (y/N): " DELETE_WORD
if [ "$DELETE_WORD" == "y" ] || [ "$DELETE_WORD" == "Y" ]; then
    rm "$WORD_FILE"
    echo -e "${GREEN}✓ 已删除原文件${NC}"
fi

echo ""
echo -e "${GREEN}✅ 转换完成！${NC}"
echo ""
echo -e "${BLUE}Markdown 文件:${NC} $FILEPATH"
echo -e "${BLUE}图片目录:${NC} $IMAGES_DIR/$FILENAME/"
echo ""
echo -e "${YELLOW}下一步操作:${NC}"
echo "  1. 检查文章: cat $FILEPATH"
echo "  2. 编辑文章: vim $FILEPATH"
echo "  3. 本地预览: cd $BLOG_DIR && hugo server -D"
echo "  4. 发布文章: cd ~/wzh_blog/scripts && ./publish.sh"
echo ""
