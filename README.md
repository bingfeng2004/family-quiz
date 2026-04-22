# 家庭竞答应用

基于 Supabase 云端同步的多人在线知识竞答游戏。

## 在线访问

访问地址：`https://你的用户名.github.io/家庭竞答应用/index-cloud.html`

## 部署说明

### 方式一：手动上传

将以下文件上传到 GitHub 仓库的 `main` 分支：
- `index-cloud.html` - 云端同步版（推荐）
- `index.html` - 本地版

### 方式二：GitHub Actions 自动部署（推荐）

1. **创建 GitHub 仓库**
   - 进入 https://github.com/new
   - Repository name: `family-quiz`
   - 选择 Private 或 Public
   - 点击 "Create repository"

2. **推送代码到仓库**
   ```bash
   cd 家庭竞答应用
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/你的用户名/family-quiz.git
   git push -u origin main
   ```

3. **启用 GitHub Pages**
   - 进入仓库 Settings → Pages
   - Source: Deploy from a branch
   - Branch: `gh-pages` / `/ (root)`
   - 点击 Save

4. **等待部署**
   - 切换到 Actions 标签页查看部署进度
   - 部署成功后访问 `https://你的用户名.github.io/family-quiz/index-cloud.html`

### 方式三：纯 GitHub Pages（无需 Actions）

1. 创建仓库并上传 `index-cloud.html` 和 `index.html`
2. Settings → Pages → Source: main branch
3. 访问 `https://你的用户名.github.io/仓库名/index-cloud.html`

## 功能说明

- **index.html**: 本地版，题目保存在本地
- **index-cloud.html**: 云端版，支持多人对战、实时同步、排行榜

## 自定义域名（可选）

在 Settings → Pages 中添加自定义域名即可。

## 技术栈

- 前端：原生 HTML + CSS + JavaScript
- 云端：Supabase (PostgreSQL + Realtime)
- 托管：GitHub Pages
