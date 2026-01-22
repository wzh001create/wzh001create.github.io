---
title: "Git 常用命令速查手册"
date: 2025-01-22T19:30:00+08:00
draft: false
tags: ["Git", "版本控制", "命令速查", "开发工具"]
categories: ["教程"]
author: "wzh001create"
---

> 基于 CSDN 博客文章整理  
> 原文链接：https://blog.csdn.net/a18307096730/article/details/124586216

---

## 📋 目录

- [基础配置](#基础配置)
- [本地仓库操作](#本地仓库操作)
- [文件状态管理](#文件状态管理)
- [分支管理](#分支管理)
- [远程仓库操作](#远程仓库操作)
- [版本控制](#版本控制)
- [常用别名配置](#常用别名配置)

---

## 基础配置

### 用户信息设置

```bash
# 设置用户名
git config --global user.name "your_name"

# 设置邮箱
git config --global user.email "your_email@example.com"

# 查看配置信息
git config --global user.name
git config --global user.email
```

### 配置别名（可选）

在 `~/.bashrc` 文件中添加：

```bash
# 用于输出 git 提交日志
alias git-log='git log --pretty=oneline --all --graph --abbrev-commit'

# 用于输出当前目录所有文件及基本信息
alias ll='ls -al'
```

执行生效：`source ~/.bashrc`

---

## 本地仓库操作

### 初始化仓库

```bash
# 在当前目录创建 Git 仓库
git init
```

### 查看状态

```bash
# 查看工作区和暂存区的状态
git status
```

---

## 文件状态管理

### 添加到暂存区

```bash
# 添加单个文件
git add <file_name>

# 添加所有修改的文件
git add .

# 添加所有文件（包括 .gitignore 和隐藏文件）
git add --all
```

### 提交到本地仓库

```bash
# 提交暂存区的所有内容
git commit -m "commit message"

# 提交时显示具体修改信息
git commit -v
```

### 忽略文件

创建 `.gitignore` 文件，添加要忽略的文件模式：

```
# 忽略所有 .a 文件
*.a

# 忽略所有 .log 文件
*.log

# 忽略 build/ 目录下的所有文件
build/

# 忽略 doc 目录下的 .txt 文件，但不包括子目录
doc/*.txt
```

---

## 分支管理

### 查看分支

```bash
# 查看本地分支
git branch

# 查看所有分支（包括远程）
git branch -a

# 查看分支详细信息（包括关联的远程分支）
git branch -vv
```

### 创建分支

```bash
# 创建新分支
git branch <branch_name>

# 创建并切换到新分支
git checkout -b <branch_name>
```

### 切换分支

```bash
# 切换到指定分支
git checkout <branch_name>
```

### 合并分支

```bash
# 将指定分支合并到当前分支
git merge <branch_name>
```

### 删除分支

```bash
# 删除已合并的分支
git branch -d <branch_name>

# 强制删除分支（未合并也删除）
git branch -D <branch_name>
```

---

## 远程仓库操作

### 配置 SSH 公钥

```bash
# 生成 SSH 公钥
ssh-keygen -t rsa

# 查看公钥内容
cat ~/.ssh/id_rsa.pub

# 验证 SSH 连接（以 Gitee 为例）
ssh -T git@gitee.com
```

### 添加远程仓库

```bash
# 添加远程仓库
git remote add origin <repository_url>

# 示例
git remote add origin git@gitee.com:username/repo.git
```

### 查看远程仓库

```bash
# 查看远程仓库列表
git remote

# 查看远程仓库详细信息
git remote -v
```

### 推送到远程仓库

```bash
# 推送到远程仓库（首次推送需要 -u 参数）
git push -u origin master

# 推送到远程仓库（已建立关联后）
git push

# 强制推送（覆盖远程仓库）
git push -f origin master
```

### 克隆远程仓库

```bash
# 克隆远程仓库到本地
git clone <repository_url>

# 克隆到指定目录
git clone <repository_url> <directory_name>
```

### 拉取和抓取

```bash
# 从远程仓库抓取更新（不自动合并）
git fetch origin

# 从远程仓库拉取更新（自动合并）
git pull origin master

# 拉取所有分支并更新当前分支
git pull
```

---

## 版本控制

### 查看提交日志

```bash
# 查看提交历史
git log

# 查看简洁的提交历史（一行显示）
git log --pretty=oneline

# 查看所有分支的提交历史（图形化）
git log --all --graph --abbrev-commit

# 使用别名（需要先配置）
git-log
```

### 查看提交记录（包括已删除的）

```bash
# 查看所有操作记录
git reflog
```

### 版本回退

```bash
# 回退到指定版本（commitID 可通过 git log 查看）
git reset --hard <commitID>

# 回退到上一个版本
git reset --hard HEAD^

# 回退到上上个版本
git reset --hard HEAD^^

# 回退到前 n 个版本
git reset --hard HEAD~n
```

### 查看文件差异

```bash
# 查看工作区和暂存区的差异
git diff

# 查看暂存区和本地仓库的差异
git diff --cached

# 查看工作区和本地仓库的差异
git diff HEAD

# 查看两个版本之间的差异
git diff <commitID1> <commitID2>
```

---

## 常用别名配置

在 `~/.bashrc` 或 `~/.bash_profile` 中添加：

```bash
# Git 日志别名
alias git-log='git log --pretty=oneline --all --graph --abbrev-commit'

# Git 状态别名
alias gs='git status'

# Git 添加别名
alias ga='git add'

# Git 提交别名
alias gc='git commit -m'

# Git 推送别名
alias gp='git push'

# Git 拉取别名
alias gl='git pull'

# Git 分支别名
alias gb='git branch'

# Git 检出别名
alias gco='git checkout'
```

执行 `source ~/.bashrc` 使配置生效。

---

## 🔥 高频使用命令

```bash
# 查看状态
git status

# 添加所有更改
git add .

# 提交更改
git commit -m "描述信息"

# 推送到远程
git push

# 拉取最新代码
git pull

# 查看日志
git log --oneline --graph

# 创建并切换分支
git checkout -b feature-branch

# 合并分支
git merge feature-branch

# 查看远程仓库
git remote -v
```

---

## 💡 Git 工作流程

```
工作区 → (git add) → 暂存区 → (git commit) → 本地仓库 → (git push) → 远程仓库
       ← (git pull) ←                                     ← 
```

**核心概念：**

1. **工作区**：你正在编辑的文件所在目录
2. **暂存区**：临时存放即将提交的修改
3. **本地仓库**：你的本地版本库
4. **远程仓库**：托管在服务器上的版本库（如 GitHub、Gitee）

---

## 📌 分支使用原则

- **master**：主分支，线上运行的代码
- **develop**：开发分支，主要开发工作在此进行
- **feature/xxx**：功能分支，开发新功能时创建，完成后合并到 develop
- **hotfix/xxx**：热修复分支，修复线上 bug，修复后合并到 master 和 develop

---

## ⚠️ 注意事项

1. **切换分支前先提交本地修改**
2. **代码及时提交，提交过就不会丢**
3. **遇到问题不要删除文件目录**
4. **推送前先拉取最新代码**：`git pull` → 解决冲突 → `git push`
5. **不要在 master 分支直接开发**

---

## 🛠️ 解决冲突

当多人修改同一文件的同一位置时，会产生冲突：

```bash
# 1. 拉取最新代码
git pull

# 2. 打开冲突文件，手动解决冲突标记
# <<<<<<<< HEAD
# 当前分支的内容
# ========
# 其他分支的内容
# >>>>>>>> branch-name

# 3. 删除冲突标记，保留需要的内容

# 4. 添加到暂存区
git add <conflict_file>

# 5. 提交
git commit -m "解决冲突"

# 6. 推送
git push
```

---

## 📚 常用场景示例

### 场景 1：开始新功能开发

```bash
git checkout develop
git pull
git checkout -b feature/new-function
# ... 开发代码 ...
git add .
git commit -m "feat: 添加新功能"
git checkout develop
git merge feature/new-function
git push
git branch -d feature/new-function
```

### 场景 2：修复线上 bug

```bash
git checkout master
git pull
git checkout -b hotfix/fix-bug
# ... 修复 bug ...
git add .
git commit -m "fix: 修复登录问题"
git checkout master
git merge hotfix/fix-bug
git push
git checkout develop
git merge hotfix/fix-bug
git push
git branch -d hotfix/fix-bug
```

### 场景 3：协同开发

```bash
# A 用户推送代码
git add .
git commit -m "update: 更新功能"
git push

# B 用户拉取代码
git pull  # 如果有冲突，解决后再提交
```

---

## 🔗 参考资料

- Git 官方文档：https://git-scm.com/doc
- GitHub：https://github.com
- Gitee（码云）：https://gitee.com
- GitLab：https://about.gitlab.com

---
