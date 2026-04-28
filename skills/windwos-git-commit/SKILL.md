---
name: git-commit
description: Generate or execute Git commits on Windows with a required emoji prefix, conventional commit type, and short Chinese summary. Use when the user asks to write a commit message, create a commit, submit local changes, or "帮我提交/生成 git commit". Apply this skill when Codex needs to inspect changed files, choose a commit type, build a message in the required `emoji + type + 描述` format, commit with Windows-side Git in PowerShell, and then ask whether to review the patch quality for patch-on-patch cleanup or refactoring.
---

# Git Commit

## Core Rules

- Use Windows-side Git in PowerShell for actual commits.
- Use non-interactive Git commands.
- Follow the exact subject format: `emoji type: 简短中文描述`
- Keep the description short, concrete, and scoped to the actual change.
- After a successful commit, ask whether the user wants a review to check for patch-on-patch changes and refactor toward a cleaner solution.

## Workflow

1. Inspect the current changes before proposing a commit message.
2. Decide whether the user asked for:
   - only a commit message
   - an actual local commit
   - both a message and a commit
3. Choose one primary commit type based on the dominant intent of the change.
4. If the work mixes unrelated changes, prefer suggesting split commits instead of forcing one vague summary.
5. Build the commit subject in the required format.
6. If the user asked to commit, run the commit from Windows PowerShell with `git`.
7. After the commit succeeds, ask:
   `是否需要 Review 一下这些修改，看看是不是补丁叠补丁式的修改，如果是的话，重构成最优解。`

## Commit Format

Always use:

```text
emoji type: 简短中文描述
```

Examples:

```text
✨ feat: 新增用户登录功能
🐞 fix: 修复导出报表空指针 bug
📃 docs: 更新安装说明文档
```

Do not add extra prefixes, ticket numbers, or English summaries unless the user explicitly asks for them.

## Type Mapping

- `✨ feat`: 新增 XXX 功能
- `🐞 fix`: 修复 XXX bug
- `📃 docs`: 增加/更新 XXX 文档
- `🌈 style`: 代码格式调整
- `🦄 refactor`: 重构 XXX
- `🎈 perf`: 优化 XXX 性能
- `🧪 test`: 增加 XXX 测试
- `🔧 build`: 依赖或构建相关
- `🐎 ci`: CI 配置相关
- `🐳 chore`: 其他杂项
- `↩️ revert`: 回滚 XXX

## Type Selection Rules

- Prefer the dominant user-facing intent, not the noisiest file count.
- Use `feat` only for new capability, not for revisions to existing behavior.
- Use `fix` for bug fixes and incorrect behavior corrections.
- Use `refactor` when behavior stays materially the same but structure improves.
- Use `style` only for formatting or non-functional presentation cleanup.
- Use `chore` only when no better type fits.
- Use `revert` only when the change actually reverts a prior commit or patch.

If two intents are equally strong and unrelated, recommend separate commits.

## Windows Git Requirement

When executing a commit:

- Use PowerShell on Windows.
- Use the Windows `git` executable available in the current environment.
- Do not switch to WSL, Bash, or Linux-side Git.
- Prefer a direct command such as:

```powershell
git commit -m "🐞 fix: 修复登录状态丢失 bug"
```

If staging is required, stage deliberately based on the files that belong in the commit.

## Response Rules

- If the user asks only for a commit message, provide the message and a one-line rationale if useful.
- If the user asks to commit, inspect the diff first, then commit.
- If the workspace is dirty with unrelated edits, avoid bundling them blindly; separate scope or explain the issue.
- Never invent scope that is not supported by the actual diff.
- Keep Chinese wording natural and short. Avoid padded phrases like "完善相关逻辑能力" or "优化整体处理流程机制".

## Post-Commit Follow-up

After a successful commit, always ask exactly or near-exactly:

```text
是否需要 Review 一下这些修改，看看是不是补丁叠补丁式的修改，如果是的话，重构成最优解。
```
