# 🚀 个人技术博客一键部署 Prompt

将以下内容直接发送给 AI 助手（如 Claude、ChatGPT、OpenCode 等），它会帮你从零搭建一个与 wzh001create 相同风格的技术博客。

---

## 📝 完整 Prompt

```
我想搭建一个个人技术博客，要求如下：

【技术栈】
- 使用 Hugo 静态博客生成器
- 使用 PaperMod 主题（简洁现代风格）
- 部署到 GitHub Pages（免费托管）
- 自动化 CI/CD（GitHub Actions）

【功能需求】
1. 博客基础功能：
   - 首页展示最新文章
   - 文章列表页（支持分页）
   - 标签和分类系统
   - 全文搜索功能
   - 深色/浅色主题切换
   - 响应式设计（支持移动端）

2. 内容管理：
   - 支持 Markdown 格式写作
   - 支持从 Word 文档转换
   - 文章支持图片、代码高亮、数学公式
   - 自动生成 RSS 订阅

3. 发布工具：
   - 创建一个 `new-post.sh` 脚本：交互式创建新文章，自动生成 front matter
   - 创建一个 `word2md.sh` 脚本：将 Word 文档转为 Markdown，自动提取图片
   - 创建一个 `publish.sh` 脚本：一键发布到 GitHub，支持预览选项

4. 个性化配置：
   - 网站标题：[你的名字] 的技术博客
   - 作者名：[你的 GitHub 用户名]
   - GitHub 用户名：[填写你的]
   - Email：[填写你的]
   - 副标题：分享技术，记录成长

【关键配置】
- 使用中文语言（zh-cn）
- 文章文件名保持中文（不转拼音）
- 代码高亮主题：monokai
- 默认显示目录（TOC）
- 显示阅读时间和分享按钮
- 启用代码复制按钮

【部署要求】
1. 自动配置 GitHub Actions 工作流
2. 推送到 main 分支自动部署
3. 提供 SSH 密钥配置指导
4. 提供完整的使用文档（中文）

【输出要求】
1. 完整的项目结构和配置文件
2. 三个发布脚本（new-post.sh、word2md.sh、publish.sh）
3. 详细的使用指南（BLOG_GUIDE.md）
4. 包含图片管理的完整方案
5. 测试所有功能并确保可用

【参考站点】
风格参考：https://wzh001create.github.io/
要求功能和外观与此站点一致。

请帮我完成整个搭建过程，包括所有配置和脚本，并提供详细的后续使用说明。
```

---

## 🎯 使用说明

### 第 1 步：准备信息

在发送 prompt 前，准备好以下信息：

- **GitHub 用户名**：你的 GitHub 账号名称
- **Email 地址**：用于显示在博客上的联系邮箱
- **博客名称**：比如"张三的技术博客"

### 第 2 步：替换占位符

将上面 prompt 中的占位符替换为你的信息：

```
[你的名字] → 张三
[你的 GitHub 用户名] → zhangsan
[填写你的 GitHub 用户名] → zhangsan
[填写你的 Email] → zhangsan@example.com
```

### 第 3 步：发送给 AI

将修改后的完整 prompt 发送给 AI 助手，它会：

1. ✅ 检查系统环境
2. ✅ 安装必要工具（Hugo、pandoc）
3. ✅ 初始化 Hugo 博客项目
4. ✅ 配置 PaperMod 主题
5. ✅ 创建发布脚本
6. ✅ 配置 GitHub Actions
7. ✅ 设置 SSH 密钥
8. ✅ 完成首次部署
9. ✅ 生成使用文档

### 第 4 步：跟随指引

AI 会逐步引导你完成：
- GitHub 仓库创建
- SSH 密钥配置
- 首次推送
- GitHub Pages 设置

### 第 5 步：开始写作

搭建完成后，你会得到：
- 一个可以访问的博客网站
- 三个便捷的发布脚本
- 详细的使用指南

---

## 📚 简化版 Prompt（适合快速部署）

如果你想要更简洁的版本：

```
帮我搭建一个与 https://wzh001create.github.io/ 相同风格的个人技术博客。

使用：
- Hugo + PaperMod 主题
- GitHub Pages 部署
- 中文界面

我的信息：
- GitHub 用户名：[填写]
- Email：[填写]
- 博客名称：[填写]

需要：
1. 创建 new-post.sh、word2md.sh、publish.sh 三个发布脚本
2. 支持 Markdown 和 Word 文档
3. 自动化 CI/CD
4. 提供完整使用文档

请完成搭建并给出使用说明。
```

---

## ⚡ 常见 AI 助手推荐

### OpenCode（推荐）
- 位置：VS Code 插件
- 优点：直接操作文件系统，全自动化
- 适合：开发者，想要完全自动化

### Claude
- 位置：https://claude.ai
- 优点：理解能力强，指导详细
- 适合：需要逐步指导的用户

### ChatGPT（GPT-4）
- 位置：https://chat.openai.com
- 优点：通用性强，响应快
- 适合：快速获取方案

### Cursor
- 位置：https://cursor.sh
- 优点：编辑器集成，代码生成强
- 适合：喜欢在编辑器内操作

---

## 🔍 验证清单

搭建完成后，检查以下功能是否正常：

- [ ] 网站可以访问（https://用户名.github.io）
- [ ] 首页正常显示
- [ ] 文章列表可以打开
- [ ] 搜索功能可用
- [ ] 深色模式切换正常
- [ ] 手机端显示正常
- [ ] new-post.sh 可以创建文章
- [ ] word2md.sh 可以转换 Word
- [ ] publish.sh 可以发布文章
- [ ] GitHub Actions 自动部署成功

---

## 💡 额外建议

### 个性化定制

搭建完成后，可以让 AI 帮你：

1. **更换配色**：
   ```
   帮我把博客主色调改为蓝色系，保持简洁风格
   ```

2. **添加功能**：
   ```
   帮我添加一个"项目展示"页面，展示我的开源项目
   ```

3. **优化 SEO**：
   ```
   帮我优化博客的 SEO 配置，提升搜索引擎收录
   ```

### 内容准备

在正式发布前：

1. **修改"关于"页面**：介绍你自己
2. **准备 2-3 篇文章**：填充内容
3. **添加社交链接**：GitHub、Twitter 等
4. **自定义 favicon**：个性化图标

---

## 🆘 遇到问题？

如果 AI 助手搭建过程中遇到问题，可以尝试：

1. **提供更多上下文**：
   ```
   我的系统是 Ubuntu 22.04，Hugo 版本是 0.120.0
   ```

2. **分步执行**：
   ```
   先帮我完成 Hugo 安装和初始化，其他功能稍后再添加
   ```

3. **参考现有博客**：
   ```
   请参考 https://wzh001create.github.io/ 的配置
   ```

4. **查看错误日志**：
   ```
   我遇到了这个错误：[粘贴错误信息]，怎么解决？
   ```

---

## 🎓 学习资源

推荐在搭建完成后学习：

- **Hugo 文档**：https://gohugo.io/documentation/
- **Markdown 教程**：https://www.markdownguide.org/
- **Git 基础**：https://git-scm.com/book/zh/v2
- **PaperMod 文档**：https://github.com/adityatelange/hugo-PaperMod/wiki

---

## ✅ 成功案例

使用此 prompt 成功搭建的博客示例：
- wzh001create: https://wzh001create.github.io/

---

**祝你搭建顺利！如有问题，随时向 AI 助手求助。🚀**
