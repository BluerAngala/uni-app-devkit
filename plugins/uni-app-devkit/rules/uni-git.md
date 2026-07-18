---
name: uni-git
description: "uni-app 项目 Git 规范。适用于 commit message、分支策略、PR 模板的编写和审查。"
alwaysApply: true
---

# Git 规范

## 1. Commit Message 格式

采用 Conventional Commits，中文描述。

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

| type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(user): 新增用户导入功能` |
| `fix` | 修复 bug | `fix(order): 修复列表分页偏移` |
| `style` | 样式调整（不影响逻辑） | `style(product): 调整表格列宽` |
| `refactor` | 重构（不新增功能/不修 bug） | `refactor(auth): 统一 token 刷新逻辑` |
| `perf` | 性能优化 | `perf(list): 虚拟滚动优化` |
| `test` | 测试相关 | `test(user): 补充登录 store 单测` |
| `docs` | 文档 | `docs: 更新 README 安装说明` |
| `chore` | 构建/工具/依赖 | `chore: 升级 uni-ui 到 1.4.x` |
| `ci` | CI/CD | `ci: 添加微信小程序自动上传` |

### Scope

可选，标注影响范围：

- 模块名：`user`、`product`、`order`、`system`
- 通用：`common`、`auth`、`i18n`、`style`
- 工具：`setup`、`build`、`ci`

### Subject

- 中文描述，动词开头
- 不超过 50 字
- 不加句号

### Body（可选）

说明改动的原因和上下文，不是改了什么（代码本身就是证据）。

### Footer（可选）

- 关联 issue：`Closes #123`
- 破坏性变更：`BREAKING CHANGE: login() 参数格式变更`

## 2. 分支策略

```
main                ← 生产环境，只接受 PR 合并
├── develop         ← 开发主线，功能合入此分支
├── feat/xxx        ← 功能分支，从 develop 拉出
├── fix/xxx         ← 修复分支
└── release/x.x.x   ← 发布分支（可选）
```

### 分支命名

```
feat/user-import
fix/order-pagination
refactor/auth-token
hotfix/login-crash
```

### 工作流

1. 从 `develop` 创建功能分支：`git checkout -b feat/user-import develop`
2. 开发完成后提 PR 到 `develop`
3. Code Review + CI 通过后合并
4. `develop` 定期合并到 `main` 并打 tag

### AI Agent 协作

- Agent 生成的代码在功能分支上提交
- Commit message 以 `[ai]` 前缀标注来源
- 人类 reviewer 必须审查后才能合入 `develop`

```
[ai] feat(product): 新增商品批量导入页面
[ai] fix(auth): 修复 token 过期未刷新
```

## 3. PR 模板

```markdown
## 改动说明

<!-- 简要描述做了什么 -->

## 改动类型

- [ ] 新功能
- [ ] Bug 修复
- [ ] 重构
- [ ] 样式调整
- [ ] 文档更新
- [ ] 依赖更新

## 影响范围

- [ ] H5
- [ ] 微信小程序
- [ ] App
- [ ] uniCloud 后端

## 自测清单

- [ ] 本地 H5 运行正常
- [ ] 目标小程序平台运行正常（如适用）
- [ ] 无 console.error / console.warn
- [ ] i18n 文本已添加
- [ ] 权限检查已添加（如涉及新页面/操作）

## 截图/录屏

<!-- 如有 UI 改动请附图 -->
```

## 4. .gitignore

```gitignore
# 依赖
node_modules/
package-lock.json

# 构建产物
dist/
unpackage/
unpackage/

# IDE
.idea/
.vscode/
*.swp
*.swo

# 环境
.env.local
.env.*.local

# 系统
.DS_Store
Thumbs.db

# uni-app
.hbuilderx/
```

## 5. Tag 规范

语义化版本：`v主版本.次版本.修订号`

```bash
git tag -a v1.2.0 -m "release: 用户导入功能上线"
git push origin v1.2.0
```

| 变动 | 版本变更 | 示例 |
|------|---------|------|
| 破坏性变更 | 主版本 +1 | v1.x.x → v2.0.0 |
| 新功能 | 次版本 +1 | v1.1.x → v1.2.0 |
| Bug 修复 | 修订号 +1 | v1.2.0 → v1.2.1 |

## 6. 禁止事项

| 禁止 | 替代 |
|------|------|
| 直接 push 到 main/develop | 通过 PR 合并 |
| `fix bug`、`update` 等模糊 commit | 遵循 Conventional Commits |
| 一个 commit 混合多个不相关改动 | 每个逻辑改动一个 commit |
| 提交 `.env.local`、`node_modules` | .gitignore 排除 |
| force push 到 main | 只在个人功能分支 rebase |
