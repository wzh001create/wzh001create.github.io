# 全局规则

## 语言规则
- 所有回复必须使用中文（包括解释、步骤、提示、错误信息）。
- 不要切换到英文或中英文混合，除非用户明确要求使用英文。
- 代码、命令、文件路径保持原样，不需要翻译。

## 博客操作规则（Token 优化）

当用户请求博客相关操作时，**必须先读取对应的 skill 定义并严格遵循其优化策略**：

### 导入文章操作
触发词：`导入文章`、`添加文章`、`发布文章`、`import`、`把...添加到博客`

**强制步骤**：
1. **必须先读取** `.opencode/skills/blog-import-post/SKILL.md`
2. **只读取文件前 50 行**判断是否有 front matter（不要读取整个文件）
3. **有完整 front matter（含 title）**：
   - 使用 `cp` + `sed` 命令复制和修改（节省 70% token）
   - 不使用 Write 工具
4. **无 front matter 或无 title**：
   - 询问用户提供元数据
   - 使用 Write 工具创建新文件
5. 自动处理图片（检测源目录，复制到 static/images/）
6. 询问是否发布

**禁止**：直接读取完整文件并用 Write 重写（浪费 token）

### 删除文章操作
触发词：`删除文章`、`移除文章`、`delete`、`remove`

**强制步骤**：
1. **必须先读取** `.opencode/skills/blog-delete-post/SKILL.md`
2. **总是先列出所有文章**（即使用户指定了关键词）
3. 匹配用户选择（序号/标题/文件名/关键词）
4. 确认后删除文件和图片目录
5. 自动提交并推送（不询问）

### 编辑文章操作
触发词：`编辑文章`、`修改文章`、`更新文章`、`edit`、`update`

**强制步骤**：
1. **必须先读取** `.opencode/skills/blog-edit-post/SKILL.md`
2. **总是先列出所有文章**
3. 匹配用户选择
4. **只读取需要修改的部分**（如只修改 front matter，就只读前 40 行）
5. 使用 Edit 工具进行精准替换（不要重写整个文件）
6. 询问是否发布

### Token 优化原则
- ✅ 优先使用 Bash 命令（cp, sed, grep）而不是 Read + Write
- ✅ 使用 Read 时总是指定 `limit` 参数，只读必要的行数
- ✅ 使用 Edit 工具进行局部修改，而不是重写整个文件
- ✅ 用 `grep` 提取标题，不要读取整个文件
- ❌ 避免读取完整的文章内容（除非绝对必要）

## 博客项目信息

- **项目路径**: `~/wzh_blog/my-blog/`
- **文章目录**: `content/posts/`
- **图片目录**: `static/images/`
- **作者名称**: `wzh001create`
- **博客 URL**: `https://wzh001create.github.io/`
- **仓库**: `git@github.com:wzh001create/wzh001create.github.io.git`

## Git 提交规范

- 导入文章: `feat: 添加文章《标题》`
- 删除文章: `chore: 删除文章《标题》`
- 编辑文章: `chore: 更新文章《标题》`
