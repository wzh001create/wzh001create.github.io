#!/bin/bash

# publish.sh - 一键发布博客文章
# 使用方法: ./publish.sh [--preview]

set -e

# 配置
BLOG_DIR="$HOME/wzh_blog/my-blog"
CONTENT_DIR="$BLOG_DIR/content/posts"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 检查是否有预览参数
PREVIEW_MODE=false
if [ "$1" == "--preview" ] || [ "$1" == "-p" ]; then
    PREVIEW_MODE=true
fi

echo -e "${BLUE}=== 博客发布工具 ===${NC}\n"

# 切换到博客目录
cd "$BLOG_DIR"

# 检查是否有未提交的更改（包括未跟踪的文件）
UNTRACKED_FILES=$(git ls-files --others --exclude-standard | wc -l)
if ! git diff --quiet || ! git diff --cached --quiet || [ $UNTRACKED_FILES -gt 0 ]; then
    echo -e "${YELLOW}📝 检测到未提交的更改${NC}\n"
    
    # 显示更改的文件
    echo -e "${BLUE}更改的文件:${NC}"
    git status --short
    echo ""
    
    # 检查是否有新文章
    NEW_POSTS=$(git status --short | grep "content/posts/" | wc -l)
    if [ $NEW_POSTS -gt 0 ]; then
        echo -e "${GREEN}✓ 发现 $NEW_POSTS 个新文章或更新${NC}\n"
    fi
else
    echo -e "${YELLOW}⚠️  没有检测到更改，仓库已是最新状态${NC}\n"
    read -p "是否继续发布? (y/N): " CONTINUE
    if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
        exit 0
    fi
fi

# 如果开启预览模式或询问是否预览
if [ "$PREVIEW_MODE" = true ]; then
    SHOULD_PREVIEW="y"
else
    read -p "🔍 是否先本地预览? (y/N): " SHOULD_PREVIEW
fi

if [ "$SHOULD_PREVIEW" == "y" ] || [ "$SHOULD_PREVIEW" == "Y" ]; then
    echo ""
    echo -e "${BLUE}🚀 启动本地服务器...${NC}"
    echo -e "${YELLOW}提示: 按 Ctrl+C 停止预览并继续发布${NC}\n"
    
    # 构建并启动服务器
    hugo server -D --bind 0.0.0.0
    
    echo ""
    echo -e "${BLUE}预览已停止${NC}\n"
fi

# 询问是否继续发布
read -p "📤 是否继续发布到 GitHub? (Y/n): " SHOULD_PUBLISH
if [ "$SHOULD_PUBLISH" == "n" ] || [ "$SHOULD_PUBLISH" == "N" ]; then
    echo "取消发布"
    exit 0
fi

echo ""
echo -e "${BLUE}🔨 正在构建站点...${NC}"

# 清理并重新构建
rm -rf public
if hugo --gc --minify; then
    echo -e "${GREEN}✓ 构建成功${NC}\n"
else
    echo -e "${RED}❌ 构建失败，请检查错误信息${NC}"
    exit 1
fi

# 生成提交信息
echo -e "${BLUE}📋 生成提交信息...${NC}"

# 检查是否有新增或修改的文章
NEW_FILES=$(git status --short | grep "^??" | grep "content/posts/" | wc -l)
MODIFIED_FILES=$(git status --short | grep "^ M" | grep "content/posts/" | wc -l)

if [ $NEW_FILES -gt 0 ] || [ $MODIFIED_FILES -gt 0 ]; then
    # 尝试提取最新的文章标题
    LATEST_POST=$(git status --short | grep "content/posts/" | head -1 | awk '{print $2}')
    if [ -n "$LATEST_POST" ] && [ -f "$LATEST_POST" ]; then
        TITLE=$(grep "^title:" "$LATEST_POST" | head -1 | sed 's/title: *"\(.*\)"/\1/' | sed "s/title: *'\(.*\)'/\1/")
        if [ -n "$TITLE" ]; then
            COMMIT_MSG="发布：$TITLE"
        else
            COMMIT_MSG="更新博客内容"
        fi
    else
        COMMIT_MSG="更新博客内容"
    fi
else
    COMMIT_MSG="更新博客配置"
fi

# 显示将要使用的提交信息
echo -e "${YELLOW}提交信息:${NC} $COMMIT_MSG"
read -p "是否修改提交信息? (y/N): " EDIT_MSG

if [ "$EDIT_MSG" == "y" ] || [ "$EDIT_MSG" == "Y" ]; then
    read -p "输入新的提交信息: " CUSTOM_MSG
    if [ -n "$CUSTOM_MSG" ]; then
        COMMIT_MSG="$CUSTOM_MSG"
    fi
fi

echo ""
echo -e "${BLUE}📦 提交更改...${NC}"

# Git 操作
git add .

if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  暂存区没有更改，跳过提交${NC}"
else
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}✓ 提交成功${NC}\n"
fi

echo -e "${BLUE}🚀 推送到 GitHub...${NC}"

if git push; then
    echo -e "${GREEN}✓ 推送成功${NC}\n"
else
    echo -e "${RED}❌ 推送失败${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 发布完成！${NC}\n"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}您的博客正在部署中...${NC}"
echo ""
echo -e "  📍 网站地址: ${GREEN}https://wzh001create.github.io/${NC}"
echo -e "  ⏱️  部署时间: ${YELLOW}约 1-2 分钟${NC}"
echo ""
echo -e "${BLUE}查看部署状态:${NC}"
echo -e "  🔗 https://github.com/wzh001create/wzh001create.github.io/actions"
echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
