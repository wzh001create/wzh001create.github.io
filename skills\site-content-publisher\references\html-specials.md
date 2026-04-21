# HTML 专题页

用于处理交互式或独立 HTML 页面，并把它们接入站点的 `专题` 栏目，同时保留原始 HTML 资源。

## 关键路径

- 原始 HTML：`static/<slug>.html`
- 包装页：`content/specials/<slug>/index.md`
- 专题列表：`/specials/`

## 新增流程

1. 先确定 `slug`，默认取 HTML 文件名去掉 `.html`。
2. 把原始 HTML 放进 `static/<slug>.html`。
3. 在 `content/specials/<slug>/index.md` 创建或更新 Hugo 包装页。
4. 对 iframe 型专题，默认保持 `showtoc: false`，除非用户明确想要普通长文页。
5. 包装页里写一段简短介绍，保留一个打开原始 HTML 的直链，再用 `iframe` 嵌入页面。

## 推荐的包装页 Front Matter

```yaml
---
title: "专题标题"
date: 2026-04-21T12:00:00+08:00
draft: false
showtoc: false
description: "专题说明"
summary: "显示在 /specials/ 列表中的摘要"
tags: ["专题", "HTML"]
categories: ["专题"]
aliases: ["/old-path/"]
---
```

## 推荐的包装页正文

```markdown
这里写专题简介。

如果你想单独打开原始页面，也可以点击这里：[打开独立版](/slug.html)。

<div class="special-embed">
  <iframe src="/slug.html" title="专题标题" loading="lazy"></iframe>
</div>

<style>
  .special-embed iframe {
    width: 100%;
    height: 80vh;
    border: 0;
  }
</style>
```

## 编辑规则

- 如果问题是站点接入、标题、摘要、嵌入方式、页面包装层，优先改包装页。
- 如果问题在交互页面本身，再改原始 HTML。
- 保证正文里的直链和 `iframe src` 与原始 HTML 文件名一致。

## 删除规则

- 如果用户要把专题从网站移除，同时删掉包装目录和原始 HTML 文件。
- 所有删除动作都先确认。

## 校验清单

- `static/<slug>.html` 已存在。
- `content/specials/<slug>/index.md` 已存在。
- 包装页引用的原始 HTML URL 正确。
- 如果已发布，确认 `/specials/<slug>/` 和 `/<slug>.html` 都能访问。
