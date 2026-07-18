---
name: uni-app-style-system
description: "Use when modifying CSS/SCSS, adding themes, adjusting layouts, or creating new components in uni-app projects. Provides the design token system, theme architecture, and component style conventions."
tags: [uni-app, design-system, scss, theme, cross-platform]
---

# uni-app 设计系统规范

本 skill 定义 uni-app 项目的完整设计 token 体系、主题架构和组件样式约定。
修改任何样式文件前，先读本文件；新建组件前，先读 `references/design-tokens.md`。

## 快速规则

1. **禁止硬编码颜色值** — 所有颜色必须引用 `uni.scss` 变量或 `getTheme()` 函数
2. **单位用 rpx** — 响应式布局用 rpx，固定尺寸用 px，禁止 rem/vh/vw
3. **数据驱动样式** — 用 `:class` / `:style` / `v-if`，禁止 DOM 操作
4. **深色模式兼容** — 所有颜色必须通过 `$themes` map 支持主题切换

## 核心文件

| 文件 | 作用 | 何时编辑 |
|------|------|----------|
| `uni.scss` | 全局 SCSS 变量 + `$themes` map | 新增颜色 token、新增主题 |
| `common/theme.scss` | `themeify` mixin + `getTheme()` 函数 | 修改主题切换逻辑 |
| `common/uni.css` | 全局布局 class | 新增通用布局 class |
| `App.vue` | `@import` 上述三个文件 | 不需要编辑 |

## 设计 Token 体系

### 颜色层级

```
语义层（$themes map）        → primary-color / success-color / warn-color / warning-color / error-color
基础层（$uni-* 变量）        → $uni-text-color / $uni-bg-color / $uni-border-color
组件层（getTheme() 函数）    → getTheme('primary-color')
```

**使用优先级：** 语义层 > 基础层 > 组件层

### 何时用哪个

| 场景 | 用法 | 示例 |
|------|------|------|
| 需要随主题切换 | `@include themeify` + `getTheme()` | 按钮背景、链接色、激活态 |
| 不随主题切换 | `$uni-*` 变量 | 正文色、边框色、背景色 |
| 全新颜色 | 加入 `$themes` map 的每个主题 | 新增 brand 色 |

### 主题切换的实际用法

```scss
// ✅ 正确 — 需要随主题切换的颜色
.my-button {
  @include themeify {
    $primary-color: getTheme('primary-color');
    background-color: $primary-color;
    border-color: $primary-color;
  }
}

// ✅ 正确 — 不随主题切换的颜色，直接用 $uni-* 变量
.my-box {
  border: 1px solid $uni-border-color;
  color: $uni-text-color;
  background-color: $uni-bg-color;
}

// ❌ 错误 — 硬编码颜色值
.my-text {
  color: #333;           // 应该用 $uni-text-color
  background: #2979ff;   // 应该用 getTheme('primary-color')
}
```

### getTheme() 可用的 key

这些 key 在 `$themes` map 中定义，每个主题都有对应值：

| Key | default 主题色值 | 用途 |
|-----|-----------------|------|
| `primary-color` | `#2979ff` | 主操作、链接、激活态 |
| `success-color` | `#18bc37` | 成功状态 |
| `warn-color` | `#e43d33` | 警告/危险（按钮 type="warn"） |
| `warning-color` | `#f3a73f` | 警告状态（tag 等） |
| `error-color` | `#e43d33` | 错误状态 |

### 文字色规范

| 语义 | 变量 | 色值 | 用途 |
|------|------|------|------|
| 主文字 | `$uni-text-color` | `#333` | 标题、正文 |
| 辅助文字 | `$uni-text-color-grey` | `#999` | 次要信息、placeholder |
| 禁用文字 | `$uni-text-color-disable` | `#c0c0c0` | 禁用态 |
| 反色文字 | `$uni-text-color-inverse` | `#fff` | 深色背景上 |

### 间距体系

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-spacing-col-sm` | `5px` | 紧凑间距 |
| `$uni-spacing-col-base` | `10px` | 默认垂直间距 |
| `$uni-spacing-col-lg` | `15px` | 宽松垂直间距 |
| `$uni-spacing-row-sm` | `10px` | 紧凑水平间距 |
| `$uni-spacing-row-base` | `15px` | 默认水平间距 |
| `$uni-spacing-row-lg` | `20px` | 宽松水平间距 |

### 字号体系

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-font-size-sm` | `12px` | 辅助文本、标签 |
| `$uni-font-size-base` | `14px` | 正文 |
| `$uni-font-size-lg` | `16px` | 小标题 |
| `$uni-font-size-title` | `20px` | 页面标题 |

### 圆角体系

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-border-radius-sm` | `3px` | tag、badge |
| `$uni-border-radius-base` | `5px` | 按钮、输入框 |
| `$uni-border-radius-lg` | `10px` | 卡片、弹窗 |
| `$uni-border-radius-circle` | `50%` | 头像 |

## 主题架构

### 添加新主题

在 `uni.scss` 的 `$themes` map 中为每个现有主题添加新 key：

```scss
$themes: (
  default: (
    primary-color: $uni-color-primary,
    success-color: $uni-color-success,
    warn-color: $uni-color-error,
    warning-color: $uni-color-warning,
    error-color: $uni-color-error,
    brand-color: #ff6b35,        // ← 新增
  ),
  green: (
    primary-color: #42b983,
    success-color: $uni-color-success,
    warn-color: $uni-color-error,
    warning-color: $uni-color-warning,
    error-color: $uni-color-error,
    brand-color: #42b983,        // ← 新增，每个主题都要有
  ),
);
```

**关键：每个新 key 必须在所有主题中都有值，否则 `getTheme()` 会返回 null。**

### 在组件中使用新 token

```scss
.my-brand-element {
  @include themeify {
    $brand-color: getTheme('brand-color');
    color: $brand-color;
    border-color: $brand-color;
  }
}
```

### 添加全新主题

```scss
// 1. 在 $themes map 中添加
dark: (
  primary-color: #4d9fff,
  success-color: #2dd47b,
  warn-color: #f87171,
  warning-color: #fbbf24,
  error-color: #f87171,
  brand-color: #ff8c5a,
),

// 2. 运行时切换（store/modules/app.js）
document.body.dataset.theme = 'dark'

// 3. 持久化
uni.setStorageSync('uni_admin_theme', 'dark')
```

## 组件样式约定

### 按钮

- 主操作：`type="primary"` → 对应 `getTheme('primary-color')`
- 危险操作：`type="warn"` → 对应 `getTheme('warn-color')`
- 次要操作：`type="default"`
- 尺寸统一：`size="mini"`

### 表格

- 使用 `<uni-table>` 组件，`border` + `stripe`
- 操作列用 `link-btn` class（已自动跟随主题色）

### 表单

- 使用 `<uni-forms>` 组件
- label 位置统一：`label-position="left"`

### 弹窗

- 使用 `<uni-popup>` 组件
- 宽度：信息确认类 `400px`，表单类 `600px`

## 样式 Checklist

修改或新建组件时，逐项检查：

- [ ] 颜色用 `$uni-*` 变量或 `getTheme()`，无硬编码十六进制值
- [ ] 单位用 rpx/px，无 rem/vh/vw
- [ ] 不操作 DOM class/style
- [ ] 新增颜色已加入 `$themes` 的**所有主题**
- [ ] i18n 文本用 `$t()` 包裹

## 参考文件

- `references/design-tokens.md` — 完整 token 列表和换算表
- `references/component-guide.md` — 各组件的样式用法示例
