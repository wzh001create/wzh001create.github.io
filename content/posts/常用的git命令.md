---
title: "常用 Git 命令速查"
date: 2025-05-09T10:00:00+08:00
draft: false
tags: ["Git", "版本控制", "开发工具"]
categories: ["教程"]
author: "wzh001create"
---

Git 是开发中必不可少的版本控制工具。本文整理了常用的 Git 命令和使用场景，帮助你快速查阅和上手。

<!--more-->

## 1. 连接远程仓库

#### 1.连接远程仓库

```python
# 添加远程仓库并命名为 origin（常用名称），我这命名的Rebot
git remote add origin https://github.com/user/repo.git
```

##### 	验证远程仓库配置

```python
# 验证远程仓库配置
git remote -v
```

![image-20250509100233175](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509100233175.png)

##### 	修改或删除远程仓库

```python
# 修改远程仓库 URL
git remote set-url origin https://new-url.git

# 删除远程仓库关联
git remote remove origin
```

#### 2.常用 Git 命令速查表

##### 	基础操作

|      命令      |                             作用                             |            示例             |
| :------------: | :----------------------------------------------------------: | :-------------------------: |
|   `git init`   |                         初始化新仓库                         |         `git init`          |
|  `git status`  |                         查看文件状态                         |        `git status`         |
|   `git add`    |                       添加文件到暂存区                       | `git add .`（添加所有文件） |
|  `git commit`  |                           提交更改                           | `git commit -m "提交说明"`  |
|   `git push`   |    推送本地提交到远程（最好创建合并请求，而不是直接推送）    |   `git push origin main`    |
|   `git pull`   |             拉取远程最新代码（会与本地代码合并）             |    `git pull origin dev`    |
| .gitignore文件 | 用于指定 Git **忽略跟踪的文件或目录**，避免将临时文件、编译产物、敏感信息等提交到仓库中。 |    *.log忽略所有日志文件    |

​	比如我现在修改了一个文件connect_engine.py，我的本地分支是dev，关联了远程分支Rebot/dev（关联后我可以快速推送到该分支）。

   - 通过git add 方法加到暂存区

     ![image-20250509101251923](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509101251923.png)

   - 通过git commit -m 方法提交

     ![image-20250509102420746](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509102420746.png)

- 通过git push方法推送到远程，已关联分支直接push就行

  ![image-20250509102619989](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509102619989.png)

- 远程仓库已经推送成功了，访问网站发起 **合并请求**。

![image-20250509102651487](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509102651487.png)

##### 分支管理

|       命令       |     作用      |                    示例                    |
| :--------------: | :-----------: | :----------------------------------------: |
|   `git branch`   |   查看分支    |       `git branch -a`（含远程分支）        |
|  `git checkout`  | 切换/创建分支 |        `git checkout -b new-branch`        |
|   `git merge`    |   合并分支    | `git merge dev`（将 `dev` 合并到当前分支） |
|   `git rebase`   |   变基分支    |             `git rebase main`              |
|  `git checkout`  | 创建本地分支  |           `git checkout -b dev`            |
| `git branch - u` | 关联远程分支  |         `git branch -u origin/dev`         |

​	这里我本地有三个分支，其中dev关联了Rebot/dev，dev-cyw关联了远程的Rebot/dev

![image-20250509101652508](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509101652508.png)

​	这是远程分支

![image-20250509101843793](C:\Users\cyw\AppData\Roaming\Typora\typora-user-images\image-20250509101843793.png)

#### 3.其他不太常用的git操作

##### 	版本控制

|    命令     |     作用     |                     示例                      |
| :---------: | :----------: | :-------------------------------------------: |
|  `git log`  | 查看提交历史 |        `git log --oneline`（简洁模式）        |
| `git diff`  | 比较文件差异 |      `git diff HEAD~1`（与上一版本对比）      |
| `git reset` |   回退提交   | `git reset --soft HEAD~1`（撤销最后一次提交） |
|  `git tag`  |   管理标签   |         `git tag v1.0.0`（创建标签）          |

------

##### 	高级操作

|       命令        |       作用       |               示例               |
| :---------------: | :--------------: | :------------------------------: |
|    `git stash`    |   暂存当前修改   | `git stash`（保存未提交的改动）  |
| `git cherry-pick` | 选择某次提交合并 |     `git cherry-pick abc123`     |
|   `git reflog`    | 查看所有操作记录 | `git reflog`（用于恢复误删提交） |

#### 4.一些git使用示例

```
比如现在要提交代码，但是你的代码修改过了（你的最新版），远程的代码也被提交更新过了（他人的最新版），你这时候push，会告诉你你的代码落后远程分支。

其中一个解决方法：
	本地创建一个新的临时分支，拉取远程的最新代码然后在本地合并到当前（你的最新版）的分支上，再提交远程。
```



