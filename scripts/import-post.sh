#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 博客根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$SCRIPT_DIR")"
POSTS_DIR="$BLOG_DIR/content/posts"
IMAGES_DIR="$BLOG_DIR/static/images"

echo -e "${BLUE}=== Markdown 文章导入工具 ===${NC}\n"

# 检查参数
if [ $# -eq 0 ]; then
    echo -e "${RED}错误: 请提供 Markdown 文件路径${NC}"
    echo "用法: $0 <markdown文件路径> [--keep-frontmatter]"
    echo ""
    echo "示例:"
    echo "  $0 ~/Documents/我的文章.md"
    echo "  $0 ~/Documents/我的文章.md --keep-frontmatter  # 保留原有的 front matter"
    exit 1
fi

MD_FILE="$1"
KEEP_FRONTMATTER=false

# 检查是否保留 front matter
if [ "$2" == "--keep-frontmatter" ]; then
    KEEP_FRONTMATTER=true
fi

# 检查文件是否存在
if [ ! -f "$MD_FILE" ]; then
    echo -e "${RED}错误: 文件不存在: $MD_FILE${NC}"
    exit 1
fi

# 检查文件扩展名
if [[ ! "$MD_FILE" =~ \.md$ ]] && [[ ! "$MD_FILE" =~ \.markdown$ ]]; then
    echo -e "${RED}错误: 文件不是 Markdown 格式 (.md 或 .markdown)${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 找到文件: $MD_FILE${NC}\n"

# 提取原文件名（不含扩展名）
ORIGINAL_FILENAME=$(basename "$MD_FILE" .md)
ORIGINAL_FILENAME=$(basename "$ORIGINAL_FILENAME" .markdown)

# 检查文件是否已有 front matter
HAS_FRONTMATTER=false
TITLE=""
TAGS=""
CATEGORIES=""

if head -1 "$MD_FILE" | grep -q "^---$"; then
    HAS_FRONTMATTER=true
    # 提取 title
    TITLE=$(sed -n '/^---$/,/^---$/p' "$MD_FILE" | grep "^title:" | sed 's/title: *"\(.*\)"/\1/' | sed "s/title: *'\(.*\)'/\1/" | sed 's/title: *//')
    # 提取 tags
    TAGS=$(sed -n '/^---$/,/^---$/p' "$MD_FILE" | grep "^tags:" | sed 's/tags: *//')
    # 提取 categories
    CATEGORIES=$(sed -n '/^---$/,/^---$/p' "$MD_FILE" | grep "^categories:" | sed 's/categories: *//')
fi

# 如果保留原 front matter 且文件有 front matter
if [ "$KEEP_FRONTMATTER" = true ] && [ "$HAS_FRONTMATTER" = true ]; then
    echo -e "${BLUE}保留原有的 front matter${NC}\n"
    
    # 询问目标文件名
    read -p "文章文件名 (默认: $ORIGINAL_FILENAME): " FILENAME
    FILENAME=${FILENAME:-$ORIGINAL_FILENAME}
    
    TARGET_FILE="$POSTS_DIR/${FILENAME}.md"
    
    # 复制文件
    cp "$MD_FILE" "$TARGET_FILE"
    
    # 更新 author 字段（如果存在）
    if grep -q "^author:" "$TARGET_FILE"; then
        sed -i 's/^author:.*/author: "wzh001create"/' "$TARGET_FILE"
    else
        # 在 front matter 中添加 author
        sed -i '/^---$/a author: "wzh001create"' "$TARGET_FILE"
    fi
    
    # 如果没有 date 字段，添加当前日期
    if ! grep -q "^date:" "$TARGET_FILE"; then
        CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%S+08:00")
        sed -i "/^author:/a date: $CURRENT_DATE" "$TARGET_FILE"
    fi
    
    # 如果没有 draft 字段，添加 draft: false
    if ! grep -q "^draft:" "$TARGET_FILE"; then
        sed -i "/^date:/a draft: false" "$TARGET_FILE"
    fi
    
    FINAL_FILENAME="$FILENAME"
    
else
    # 需要添加或重写 front matter
    echo -e "${YELLOW}需要添加文章元数据${NC}\n"
    
    # 询问标题
    if [ -n "$TITLE" ]; then
        read -p "文章标题 (默认: $TITLE): " INPUT_TITLE
        TITLE=${INPUT_TITLE:-$TITLE}
    else
        read -p "文章标题 (默认: $ORIGINAL_FILENAME): " INPUT_TITLE
        TITLE=${INPUT_TITLE:-$ORIGINAL_FILENAME}
    fi
    
    # 询问文件名
    read -p "文章文件名 (默认: $ORIGINAL_FILENAME): " FILENAME
    FILENAME=${FILENAME:-$ORIGINAL_FILENAME}
    
    # 询问标签
    if [ -n "$TAGS" ]; then
        read -p "标签 (逗号分隔，默认: $TAGS): " INPUT_TAGS
        TAGS=${INPUT_TAGS:-$TAGS}
    else
        read -p "标签 (逗号分隔，例如: 技术,教程): " TAGS
    fi
    
    # 询问分类
    if [ -n "$CATEGORIES" ]; then
        read -p "分类 (逗号分隔，默认: $CATEGORIES): " INPUT_CATEGORIES
        CATEGORIES=${INPUT_CATEGORIES:-$CATEGORIES}
    else
        read -p "分类 (逗号分隔，例如: 开发): " CATEGORIES
    fi
    
    TARGET_FILE="$POSTS_DIR/${FILENAME}.md"
    
    # 获取当前日期时间
    CURRENT_DATE=$(date +"%Y-%m-%dT%H:%M:%S+08:00")
    
    # 处理标签和分类
    TAGS_ARRAY=""
    if [ -n "$TAGS" ]; then
        IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
        for tag in "${TAG_ARRAY[@]}"; do
            tag=$(echo "$tag" | xargs) # 去除空格
            if [ -n "$TAGS_ARRAY" ]; then
                TAGS_ARRAY="$TAGS_ARRAY, \"$tag\""
            else
                TAGS_ARRAY="\"$tag\""
            fi
        done
    fi
    
    CATEGORIES_ARRAY=""
    if [ -n "$CATEGORIES" ]; then
        IFS=',' read -ra CAT_ARRAY <<< "$CATEGORIES"
        for cat in "${CAT_ARRAY[@]}"; do
            cat=$(echo "$cat" | xargs) # 去除空格
            if [ -n "$CATEGORIES_ARRAY" ]; then
                CATEGORIES_ARRAY="$CATEGORIES_ARRAY, \"$cat\""
            else
                CATEGORIES_ARRAY="\"$cat\""
            fi
        done
    fi
    
    # 创建新文件并写入 front matter
    cat > "$TARGET_FILE" << EOF
---
title: "$TITLE"
date: $CURRENT_DATE
draft: false
tags: [$TAGS_ARRAY]
categories: [$CATEGORIES_ARRAY]
author: "wzh001create"
---

EOF
    
    # 如果原文件有 front matter，跳过它，只复制正文
    if [ "$HAS_FRONTMATTER" = true ]; then
        sed -n '/^---$/,/^---$/!p' "$MD_FILE" | sed '1,/^---$/d' >> "$TARGET_FILE"
    else
        # 否则复制整个文件内容
        cat "$MD_FILE" >> "$TARGET_FILE"
    fi
    
    FINAL_FILENAME="$FILENAME"
fi

echo ""
echo -e "${GREEN}✅ 文章导入成功！${NC}\n"
echo -e "${BLUE}文件位置:${NC} $TARGET_FILE"

# 询问是否需要创建图片目录
read -p "是否创建对应的图片目录? (y/N): " CREATE_IMG_DIR
if [ "$CREATE_IMG_DIR" == "y" ] || [ "$CREATE_IMG_DIR" == "Y" ]; then
    IMG_DIR="$IMAGES_DIR/$FINAL_FILENAME"
    mkdir -p "$IMG_DIR"
    echo -e "${GREEN}✓ 已创建图片目录: $IMG_DIR${NC}"
    
    # 检查原文件所在目录是否有图片文件
    ORIGINAL_DIR=$(dirname "$MD_FILE")
    if ls "$ORIGINAL_DIR"/*.{png,jpg,jpeg,gif,svg,webp} 2>/dev/null | grep -q .; then
        echo -e "${YELLOW}检测到原目录中有图片文件${NC}"
        read -p "是否复制这些图片到图片目录? (y/N): " COPY_IMAGES
        if [ "$COPY_IMAGES" == "y" ] || [ "$COPY_IMAGES" == "Y" ]; then
            cp "$ORIGINAL_DIR"/*.{png,jpg,jpeg,gif,svg,webp} "$IMG_DIR/" 2>/dev/null
            echo -e "${GREEN}✓ 图片已复制${NC}"
            
            # 询问是否更新图片路径
            read -p "是否自动更新文章中的图片路径? (y/N): " UPDATE_PATHS
            if [ "$UPDATE_PATHS" == "y" ] || [ "$UPDATE_PATHS" == "Y" ]; then
                # 更新相对路径的图片引用
                sed -i "s|\!\[\([^]]*\)\](\([^/)][^)]*\))|\![\1](/images/$FINAL_FILENAME/\2)|g" "$TARGET_FILE"
                echo -e "${GREEN}✓ 图片路径已更新${NC}"
            fi
        fi
    fi
fi

echo ""
echo -e "${YELLOW}下一步操作:${NC}"
echo "  1. 编辑文章: vim $TARGET_FILE"
echo "  2. 本地预览: cd $BLOG_DIR && hugo server -D"
echo "  3. 发布文章: cd $SCRIPT_DIR && ./publish.sh"
