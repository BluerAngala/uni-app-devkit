---
name: uni-app-conventions
description: "uni-app 项目编码约定。适用于所有 .vue、.js、.scss 文件的编写和审查。section 6 为 uni-admin 专属。"
alwaysApply: true
---

# uni-app 编码约定

本文件是硬约束，违反即为错误。

## 1. Vue API

- **仅 Options API**，禁止 Composition API（`setup()`、`<script setup>`、`ref()`、`computed()` 等）
- **目标 Vue 3**：新项目必须用 Vue 3 + `createSSRApp`。Vue 2 为遗留模式，不新增 Vuex 等 Vue 2 专属功能
- Vue 2/3 兼容：所有 Vue API 必须用条件编译
  ```js
  // #ifdef VUE3
  import { createSSRApp } from 'vue'
  // #endif
  // #ifndef VUE3
  import Vue from 'vue'
  // #endif
  ```

## 2. 标签与 API

| 禁止 | 替代 |
|------|------|
| `<div>` / `<span>` / `<img>` / `<a>` / `<ul>` / `<li>` | `<view>` / `<text>` / `<image>` / `<navigator>` |
| `this.$router.push()` | `uni.navigateTo()` |
| `this.$route.query` | `onLoad(options)` 参数 |
| `document.getElementById()` | `uni.createSelectorQuery().in(this)` |
| `localStorage` / `sessionStorage` | `uni.setStorageSync()` / `uni.getStorageSync()` |
| `axios` / `fetch` | `uni.request()` 或项目 `$request` |
| `window` / `document` | uni-app API |

## 3. 生命周期

- **页面**用 `onLoad` / `onShow` / `onReady` / `onHide`，不用 `created` / `mounted`
- **组件**只能用 Vue 标准生命周期（`created` / `mounted` 等），不能用页面级钩子
- 路由参数在 `onLoad(options)` 中获取

## 4. 样式

- 单位用 `rpx`（响应式）或 `px`（固定），**禁止** `rem` / `vh` / `vw`
- 颜色必须引用 `uni.scss` 变量或 `themeify` mixin，**禁止硬编码十六进制颜色值**
- 不操作 DOM 样式，用数据驱动 `:class` / `v-if` / `:style`
- 新增主题色：在 `uni.scss` 的 `$themes` map 中添加

## 5. 平台条件编译

```vue
<!-- #ifdef H5 -->
<view>H5 only</view>
<!-- #endif -->

<!-- #ifndef H5 -->
<view>非 H5</view>
<!-- #endif -->
```

常用：`H5`、`APP-PLUS`、`MP-WEIXIN`、`MP-ALIPAY`

## 6. 管理页面结构（uni-admin 专属）

**以下规则仅适用于 uni-admin 项目**，普通 uni-app 项目跳过此节。

所有管理页面必须用 `<fix-top-window>` 包裹：

```vue
<template>
  <fix-top-window>
    <template #header>
      <uni-stat-breadcrumb />
      <view class="uni-stat--btn-group">...</view>
    </template>
    <unicloud-db ref="udb" v-slot:default="{data, pagination, loading, error}"
      collection="集合名" :where="where">
      <uni-table :loading="loading" :border="true">...</uni-table>
    </unicloud-db>
  </fix-top-window>
</template>
```

## 7. i18n

- 所有用户可见文本必须用 `$t('key')` 包裹
- key 命名：`模块.语义`，如 `common.button.add`、`system.user.name`
- 新增文本必须同步到 `i18n/zh-Hans.json`、`i18n/zh-Hant.json`、`i18n/en.json`

## 8. 权限

- 操作权限检查：`$hasPermission('permission_name')`
- 角色检查：`$hasRole('admin')`
- admin 角色自动跳过权限检查

## 9. 格式化

- Prettier：行宽 180、单引号、2 空格缩进、ES5 尾逗号
- 不要手动调整格式，交给 Prettier
