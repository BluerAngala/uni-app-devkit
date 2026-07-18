# Changelog

## 0.3.0 (2026-07-18)

### 修复
- **scaffold-page** 模板 SQL 注入风险：`search()` 改为 `new RegExp()` 安全查询（JQL 对象语法）
- **scaffold-cloud** schema 默认读权限从 `true` 改为 `auth.uid != null`
- **scaffold-cloud** 云对象 `_before()` 改为 `uniID.createInstance()` + `checkToken()`（符合 uni-id-common 规范）
- **scaffold-cloud** Schema 权限表达式 `auth.role.includes()` 改为 `auth.role.indexOf()`（兼容性更好）
- **check-theme** 硬编码颜色扫描误报：改进正则排除 URL 锚点和非颜色 `#` 值
- **uni-cloud-security** `this.getBodyParams()` 修正为 `this.getParams()`（官方 API）
- **uni-cloud-security** `uniID.checkToken()` 改为 `uniID.createInstance()` + `uniIDIns.checkToken()` 流程
- **uni-app-conventions** `uni.createSelectorQuery()` 补充 `.in(this)` 调用
- **uni-app-conventions** 补充组件生命周期说明（组件不能用 onLoad 等页面钩子）
- **uni-cross-platform** 补充新平台标识（APP-HARMONY、MP-KUAISHOU 等）
- **uni-cross-platform** `::v-deep` 修正（dart-sass 已废弃 `/deep/`）
- **uni-performance** 删除错误的 `this.setData()` 写法，改为 uni-app 的直接赋值
- **uni-state-management** Pinia 初始化改为 `createSSRApp` + `return { app, pinia }`
- **uni-state-management** 组件中使用改为 `mapStores` / `mapState`（避免每次 computed 创建新引用）
- **uni-http** 环境变量区分 webpack（`VUE_APP_*`）和 Vite（`VITE_*`）
- **uni-testing** 测试框架从 Vitest 改为 Jest（uni-automator 底层是 Jest）
- **uni-testing** 测试体系从 uni-automator 改为 `uni-test`（HBuilderX 插件体系）
- **uni-testing** 补充 `cli logcat` / `uni-logcat` 运行时日志捕获（AI 开发核心能力）
- **uni-testing** 补充 `@dcloudio/hbuilderx-cli` npm 桥接包和完整 CI 流程

### 新增
- **rule:** `uni-http` — 网络请求封装规范（$request、uniCloud 调用、错误处理、Loading）
- **rule:** `uni-state-management` — 状态管理规范（Pinia、Store vs Storage 边界、模块拆分）
- **rule:** `uni-typescript` — TypeScript 规范（类型定义、云对象类型、Store 类型）
- **rule:** `uni-i18n` — 国际化规范（Key 命名、翻译文件、日期/货币格式化）
- **rule:** `uni-git` — Git 规范（Conventional Commits、分支策略、PR 模板）
- **rule:** `uni-performance` — 性能规范（分包、图片、长列表、setData、首屏优化）
- **skill:** `uni-testing` — 测试策略（Jest + uni-test + logcat）
- **skill:** `uni-hbuilderx-cli` — HBuilderX CLI 操作（编译、运行、日志捕获、发布）
- **skill:** `uni-app-style-system` 重写 — 完整设计系统（深色模式、10 角色色、排版体系、阴影/动效、禁用清单、交付 Checklist）
- **check-theme** 支持 `.check-theme-ignore.json` 白名单配置
- **cloud-security** 完整的频率限制代码示例和阈值建议

## 0.2.0 (2026-07-18)

### 新增
- **skill:** `uni-app-style-system` — 设计系统规范（token 体系、`getTheme()`、`$themes` map）
- **skill:** `uni-app-page-dev` — 页面开发全流程（列表页、表单页、权限、路由注册）
- **skill:** `uni-app-cloud-dev` — 云开发全流程（云对象、云函数、Schema、JQL）
- **rules:** `uni-app-conventions` — 编码约定（Options API、标签、生命周期、样式、i18n）
- **rules:** `uni-cloud-security` — 安全规则（权限校验、数据校验、JQL 安全）
- **rules:** `uni-cross-platform` — 跨端适配（条件编译、CSS/API/导航差异）
- **command:** `/scaffold-page` — 页面脚手架（list/add/edit 三页 + 注册路由）
- **command:** `/scaffold-cloud` — 云对象脚手架（CRUD + Schema 三文件）
- **command:** `/check-theme` — 扫描硬编码颜色、不合规单位、DOM 操作
- **prompt:** `uni-code-review` — 代码审查（规范、安全、跨端、性能四维）
- **setup.sh** — 交互式安装，支持按需选择工具和全局/项目级范围
- 多工具适配：OMP、Claude Code、Agents、Codex、Pi Agent、OpenCode、GitHub Copilot
- OMP marketplace plugin
- Claude Code marketplace 兼容

## 0.1.0 (2026-07-18)

- 初始版本
