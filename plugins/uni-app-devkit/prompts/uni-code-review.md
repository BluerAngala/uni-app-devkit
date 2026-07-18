---
name: uni-code-review
description: "审查 uni-app 代码的质量、规范合规性和跨端兼容性。用在提交代码前或 PR 审查时。"
---

# uni-app 代码审查

审查 uni-app 项目的代码变更，检查以下维度。

## 审查维度

### 1. 规范合规

- [ ] 全部使用 Options API，无 Composition API
- [ ] 标签用 uni-app 标签（view/text/image/navigator），无 HTML 标签
- [ ] 跳转用 `uni.navigateTo`，无 vue-router
- [ ] 生命周期用 `onLoad`/`onShow`，无 `created`/`mounted`
- [ ] 样式用 rpx/px，无 rem/vh/vw
- [ ] 颜色用变量，无硬编码十六进制值
- [ ] 不操作 DOM（无 document/window/localStorage）
- [ ] i18n 文本用 `$t()` 包裹

### 2. 安全

- [ ] 云函数/云对象有权限校验
- [ ] 外部输入有类型校验
- [ ] 敏感数据未写入日志
- [ ] Schema 权限规则已配置
- [ ] 无 SQL 注入风险（JQL where 条件未直接拼接用户输入）

### 3. 跨端兼容

- [ ] 平台差异代码有条件编译
- [ ] tabBar 页面用 `switchTab`
- [ ] CSS 选择器兼容小程序（无 nth-child、伪元素）
- [ ] 样式穿透用 `::v-deep` 或 `/deep/`

### 4. 性能

- [ ] 列表页用分页，未一次性加载全部数据
- [ ] 大量数据用 `loadtime="manual"` 手动控制加载
- [ ] 搜索用防抖（`debounce`）
- [ ] 图片用 `mode="aspectFit"` 或 `mode="aspectFill"`
- [ ] `v-for` 必须加 `:key`（用唯一 ID，不用 index）
- [ ] 不频繁切换的用 `v-if`，频繁切换的用 `v-show`

### 5. 状态管理

- [ ] 使用 Pinia，无 Vuex
- [ ] Store 按业务域拆分，无巨型单一 store
- [ ] 组件中用 `mapStores` / `mapState`，不在 computed 中直接调 `useStore()`
- [ ] 组件内不直接读 `uni.getStorageSync` 判断状态，用 Store getter

### 6. 网络请求

- [ ] HTTP 请求通过 `$request` 封装，无裸 `uni.request()`
- [ ] uniCloud 调用通过 `uniCloud.importObject()`，无 `uni.request` 调用云函数
- [ ] 所有请求有 `try/catch` 或 `.catch`
- [ ] 提交按钮有防重复提交逻辑

### 7. TypeScript（如项目使用 TS）

- [ ] 无 `any` 滥用
- [ ] 无 `@ts-ignore`（用 `@ts-expect-error` + 说明）
- [ ] 云对象有入参/出参类型定义
- [ ] Store 有 state 类型定义

### 8. 主题系统

- [ ] 颜色用 `$uni-*` 变量或 `getTheme()`，无硬编码
- [ ] 未混用 `getTheme()` 和 CSS `var()`
- [ ] 新颜色已加入 `$themes` 的所有主题（light + dark）

### 9. 代码质量

- [ ] 组件职责单一，无上帝组件
- [ ] 方法命名清晰
- [ ] 无未使用的变量或导入
- [ ] 错误处理完善（try/catch 或 .catch）

## 输出格式

```
📋 代码审查报告

❌ 严重问题 (必须修复)
  1. pages/xxx.vue:15 — 使用了 document.getElementById，应改用 uni.createSelectorQuery
  2. cloudfunctions/xxx-co.obj.js — _before() 中未校验 token

⚠️ 建议修复
  1. pages/xxx.vue:30 — 颜色 #555 建议改为 $uni-text-color
  2. pages/xxx.vue:45 — font-size: 14px 建议改为 $uni-font-size-base

✅ 通过项
  - 标签规范 ✅
  - 路由规范 ✅
  - i18n ✅
  - 状态管理 ✅
  - 网络请求 ✅
  - 主题系统 ✅
```
