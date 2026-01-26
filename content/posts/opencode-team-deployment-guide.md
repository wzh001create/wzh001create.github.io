---
title: "OpenCode 团队快速部署指南"
date: 2026-01-26T19:30:00+08:00
draft: false
tags: ["OpenCode", "部署指南", "开发工具", "团队协作", "AI编程"]
categories: ["教程"]
author: "wzh001create"
description: "面向团队的一页式 OpenCode 部署文档：安装、网络配置、插件安装、连接 GPT Plus/Copilot/Antigravity、验证清单"
---

> 面向团队的一页式部署文档：安装、网络、必装插件、连接 GPT Plus / Copilot / Antigravity、验证清单。

---

## 1) 安装 OpenCode

### Windows（PowerShell）

第 1 步：允许运行脚本（只需执行一次）
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

第 2 步：安装 Scoop
```powershell
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

第 3 步：安装 Git（Scoop 需要 Git 来添加 bucket）
```powershell
scoop install git
```

第 4 步：安装 OpenCode
```powershell
scoop bucket add extras
scoop install extras/opencode
```

### Linux

```bash
curl -fsSL https://opencode.ai/install | bash
```

验证安装：看到 `Installation complete!` 就成功了。

重要：安装成功后需要重启终端。

---

## 2) 网络配置（代理）

参考（中文教程）：https://learnopencode.com/1-start/03-network.html

### Windows（临时配置）
```powershell
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
```

### Linux（临时配置）
```bash
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
```

提示：如果遇到"环境变量不生效"，按教程同时设置小写 `http_proxy/https_proxy` 并用 `curl` 验证。

---

## 3) 必装插件（推荐）

### 3.1 配额查询：opencode-mystatus

插件主页：https://github.com/vbgate/opencode-mystatus

用途：一键查询多个平台的配额/重置时间（OpenAI、GitHub Copilot、Google Cloud(Antigravity) 等）。

把下面这句"自然语言安装指令"粘贴到任意 LLM/Agent（OpenCode/Claude Code/Cursor 都行）执行：
```
Install the opencode-mystatus plugin by following: https://raw.githubusercontent.com/vbgate/opencode-mystatus/main/README.md
```

安装后使用（OpenCode 内）：
```
/mystatus
```

### 3.2 Google OAuth + Antigravity：opencode-antigravity-auth

插件主页：https://github.com/NoeFabris/opencode-antigravity-auth

用途：用 Google OAuth 接入 Antigravity 配额池，从而使用 `antigravity-gemini-3-pro/flash`、`antigravity-claude-...` 等模型。

风险提示：该插件 README 明确提示可能存在 ToS 风险/封号风险；请使用不影响工作的成熟账号，风险自担。

把下面这句"自然语言安装指令"粘贴到任意 LLM/Agent 执行（会同时把模型定义写入 `~/.config/opencode/opencode.json`）：
```
Install the opencode-antigravity-auth plugin and add the Antigravity model definitions to ~/.config/opencode/opencode.json by following: https://raw.githubusercontent.com/NoeFabris/opencode-antigravity-auth/dev/README.md
```

认证（通常在终端执行）：
```bash
opencode auth login
```

---

## 4) 连接账号与模型（GPT Plus / Copilot / Antigravity）

OpenCode 常用命令：
- `/connect`：连接提供商、登录/录入凭证
- `/models`：选择模型

凭证存储（常见）：
- OpenCode 本地凭证：`~/.local/share/opencode/auth.json`
- Antigravity 账号：`~/.config/opencode/antigravity-accounts.json`

### 4.1 OpenAI（ChatGPT Plus/Pro 登录，推荐）

参考（中文教程）：https://learnopencode.com/1-start/04h-openai.html

步骤：
1. 启动 OpenCode：`opencode`
2. 输入 `/connect`，选择 **OpenAI**
3. 选择 **ChatGPT Plus/Pro（推荐）**，浏览器完成授权
4. 回到 OpenCode，用 `/models` 选择需要的 OpenAI 模型

### 4.2 GitHub Copilot

步骤：
1. 启动 OpenCode：`opencode`
2. 输入 `/connect`，搜索并选择 **GitHub Copilot**
3. 按提示访问 `github.com/login/device` 输入设备码完成授权
4. 用 `/models` 选择 Copilot 可用模型

### 4.3 Google（Antigravity）

前提：已安装 `opencode-antigravity-auth` 并完成 `opencode auth login`。

完成后：
- `/models` 中应能看到 `google/antigravity-...` 相关模型
- `/mystatus` 应能显示 Google Cloud(Antigravity) 的配额

---

## 5) 验证清单（装完就跑）

### 5.1 版本检查
```bash
opencode --version
```

### 5.2 重启原则

以下情况务必重启 OpenCode / 终端：
- 刚安装 OpenCode
- 改了 `~/.config/opencode/opencode.json`
- 安装/更新插件后

### 5.3 插件与额度验证

在 OpenCode 内：
```
/mystatus
```

---

## 6) 常见故障（最短路径排查）

- 连接超时/打不开登录页：优先检查代理（见网络教程），必要时同时设置大小写代理变量。
- 插件装了但没生效：确认已重启 OpenCode；再检查 `~/.config/opencode/opencode.json` 是否包含对应 plugin。
- `/mystatus` 里 OpenAI 报 socket closed：多为网络/代理问题；不影响 Copilot/Google 的查询时可先继续排查网络。
