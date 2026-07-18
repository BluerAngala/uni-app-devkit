# Changelog

## 0.3.0 (2026-07-18)

### 修复
- **scaffold-page** 模板 SQL 注入风险：`search()` 改为 `new RegExp()` 安全查询（JQL 对象语法）
- **uni-app-page-dev** skill 模板同步修复 SQL 注入（与 scaffold-page 一致）
- **scaffold-cloud** schema 默认读权限从 `true` 改为 `auth.uid != null`
- **scaffold-cloud** 云对象 `_before()` 改为 `createInstance()` + `checkToken()` 完整校验
- **scaffold-cloud** Schema 权限表达式 `auth.role.includes()` 改为 `auth.role.indexOf()`
- **check-theme** 硬编码颜色扫描误报：改进正则排除 URL 锚点和非颜色 `#` 值
- **uni-cloud-security** `this.getBodyParams()` 修正为 `this.getParams()`
- **uni-cloud-security** `uniID.checkToken()` 改为 `createInstance()` + `checkToken()` 流程
- **uni-cloud-security** 限流器内存 Map 警告移至函数内部
- **uni-app-conventions** 补充 Vue 3 目标策略声明
- **uni-app-conventions** section 6 标记为 uni-admin 专属
- **uni-app-conventions** `uni.createSelectorQuery()` 补充 `.in(this)`
- **uni-app-conventions** 补充组件 vs 页面生命周期区分
- **uni-cross-platform** 补充新平台标识（APP-HARMONY、MP-KUAISHOU 等）
- **uni-cross-platform** `::v-deep` 修正（dart-sass 废弃 `/deep/`）
- **uni-cross-platform** CSS 示例修正（移除 `100vh`）
- **uni-performance** 删除错误的 `this.setData()` 写法
- **uni-state-management** Pinia 初始化改为 `createSSRApp` + `return { app, pinia }`
- **uni-state-management** 组件中使用改为 `mapStores()`
- **uni-http** 环境变量区分 webpack/Vite（简化，不用条件编译）
- **uni-typescript** `Vue.extend()` 改为 `defineComponent()`（Vue 3）
- **uni-typescript** `alwaysApply` 改为 `true`
- **uni-i18n** 流程步骤复制粘贴错误修正
- **uni-i18n** `$i18n.locale` 说明改为区分 vue-i18n 和 uni-app 内置方案
- **uni-testing** 测试框架从 Vitest 改为 Jest
- **uni-testing** 测试体系从 uni-automator 改为 `uni-test` + `@dcloudio/hbuilderx-cli`
- **uni-testing** jest.config.js 路径修正为项目根目录
- **uni-testing** 补充 `cli logcat` 运行时日志捕获
- **uni-app-style-system** 重写：深色模式、10 角色色、排版/阴影/动效体系
- **uni-app-style-system** 拆分为通用 + 三端专属文件
- **uni-app-style-system** 修复 h5-design.md 中 `rgba(getTheme())` 编译错误

### 新增
- **rule:** `uni-http` — 网络请求封装规范
- **rule:** `uni-state-management` — 状态管理规范
- **rule:** `uni-typescript` — TypeScript 规范
- **rule:** `uni-i18n` — 国际化规范
- **rule:** `uni-git` — Git 规范
- **rule:** `uni-performance` — 性能规范
- **skill:** `uni-testing` — 测试策略（Jest + uni-test + logcat）
- **skill:** `uni-hbuilderx-cli` — HBuilderX CLI 操作
- **reference:** `h5-design.md` — H5 端专属设计规范
- **reference:** `h5-advanced-effects.md` — H5 高级视觉效果（毛玻璃/Grid/滚动动画/渐变/裁切）
- **reference:** `miniprogram-design.md` — 小程序端专属设计规范
- **reference:** `app-design.md` — App 端专属设计规范
- **reference:** `visual-quality.md` — 视觉品质基准（间距节奏/颜色品质/排版层级/卡片/按钮/状态设计）
- **reference:** `premium-components.md` — 高端组件参考（卡片/列表/统计/按钮组/表单/标签栏 基础版 vs 高端版）
- **reference:** `icon-upgrade.md` — 图标升级方案（iconfont 接入/SVG 组件/风格规范）
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
