---
name: uni-cross-platform
description: "uni-app 跨端适配规则。适用于同时编译到 H5、小程序、App 的代码编写和审查。"
alwaysApply: true
---

# uni-app 跨端适配规则

uni-app 一次开发多端运行，以下差异必须处理。

## 条件编译

```vue
<!-- 模板 -->
<!-- #ifdef H5 -->
<view>H5 only</view>
<!-- #endif -->

<!-- #ifndef H5 -->
<view>非 H5</view>
<!-- #endif -->
```

```js
// JS
// #ifdef H5
console.log('H5 only')
// #endif
```

```scss
/* CSS 条件编译示例 */
/* #ifdef H5 */
.uni-nav-menu { height: 100%; }  /* H5 也推荐用 % 而非 vh */
/* #endif */
/* #ifndef H5 */
.uni-nav-menu { height: 100%; }
/* #endif */
```

## 平台标识

| 标识 | 含义 |
|------|------|
| `H5`（别名 `WEB`） | 网页 |
| `APP-PLUS` | App（nvue 和 vue 都用这个） |
| `APP-HARMONY` | 鸿蒙 App |
| `MP-WEIXIN` | 微信小程序 |
| `MP-ALIPAY` | 支付宝小程序 |
| `MP-KUAISHOU` | 快手小程序 |
| `MP-JD` | 京东小程序 |
| `MP-XHS` | 小红书小程序 |
| `MP` | 所有小程序 |
| `MP-HARMONY` | 鸿蒙小程序 |

## 关键差异

### CSS 差异

| 特性 | H5 | 小程序 | App |
|------|-----|--------|-----|
| `vh`/`vw` | ✅ | ❌ | ❌ |
| `rem` | ✅ | ❌ | ❌ |
| 伪元素 `::before` | ✅ | ⚠️ 部分 | ⚠️ 部分 |
| `nth-child` | ✅ | ❌ | ❌ |
| rpx | ✅ | ✅ | ✅ |

**结论：只用 rpx 和 px，不用 rem/vh/vw。伪元素和 nth-child 少用。**

### API 差异

| 场景 | H5 | 小程序 | App |
|------|-----|--------|-----|
| DOM 操作 | ✅ | ❌ | ❌ |
| `localStorage` | ✅ | ❌ | ❌ |
| `document.*` | ✅ | ❌ | ❌ |
| `window.*` | ✅ | ❌ | ❌ |
| `uni.*` API | ✅ | ✅ | ✅ |

**结论：只用 `uni.*` API，不用任何 Web 专有 API。**

### 导航差异

```js
// tabBar 页面必须用 switchTab，navigateTo 不行
uni.switchTab({ url: '/pages/index/index' })

// 小程序不支持 navigateTo 嵌套超过 10 层
// 复杂跳转用 reLaunch 或 redirectTo
uni.redirectTo({ url: '/pages/xxx/xxx' })
```

### 组件差异

| 组件 | H5 | 微信小程序 | App |
|------|-----|-----------|-----|
| `<web-view>` | ✅ | ✅ | ✅ |
| `<map>` | ✅ | ✅ | ✅ |
| `<camera>` | ❌ | ✅ | ✅ |
| 原生导航栏 | ✅ | ✅ | ✅ |
| 自定义导航栏 | ✅ | ✅ | ✅ |

### 样式穿透

```scss
// ✅ 推荐（dart-sass 已废弃 /deep/）
::v-deep .uni-forms-item__label { color: $uni-text-color; }

// ⚠️ 仅在 node-sass 环境下使用 /deep/
/deep/ .uni-forms-item__label { color: $uni-text-color; }
```

**注意：** HBuilderX 4.56+ Vue 2 项目默认使用 dart-sass 替代 node-sass，此时 `/deep/` 会报错，必须用 `::v-deep`。

## 跨端 Checklist

- [ ] 没有 Web 专有 API（document、window、localStorage）
- [ ] 没有 vue-router（用 uni.navigateTo）
- [ ] CSS 只用 rpx/px
- [ ] 没有伪元素或 nth-child（或有条件编译保护）
- [ ] tabBar 页面用 switchTab
- [ ] 平台差异代码有条件编译
- [ ] 测试过至少两个平台（H5 + 一个小程序或 App）
