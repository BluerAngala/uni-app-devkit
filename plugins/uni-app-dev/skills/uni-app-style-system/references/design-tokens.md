# Design Tokens 完整参考

## rpx 换算

| 设计稿宽度 | 1px = | 750rpx = |
|-----------|-------|----------|
| 750px | 1rpx | 屏幕宽度 |
| 375px | 2rpx | 屏幕宽度 |

## 颜色 Token 全表

### 行为色

| Token | default | green | 用途 |
|-------|---------|-------|------|
| `primary` | `#2979ff` | `#42b983` | 主操作、链接、激活态 |
| `primary-light` | `#e8f0fe` | `#e8f8f0` | 浅色背景、hover |
| `success` | `#18bc37` | `#18bc37` | 成功状态 |
| `warning` | `#f3a73f` | `#f3a73f` | 警告状态 |
| `danger` | `#e43d33` | `#e43d33` | 错误、删除 |
| `info` | `#8f939c` | `#8f939c` | 信息、禁用 |

### 文字色

| Token | 值 | 场景 |
|-------|-----|------|
| `$uni-text-color` | `#333` | 标题、正文 |
| `$uni-text-color-grey` | `#999` | 辅助信息 |
| `$uni-text-color-placeholder` | `#808080` | 输入框 placeholder |
| `$uni-text-color-disable` | `#c0c0c0` | 禁用态 |
| `$uni-text-color-inverse` | `#fff` | 深色背景上 |

### 背景色

| Token | 值 | 场景 |
|-------|-----|------|
| `$uni-bg-color` | `#fff` | 页面背景 |
| `$uni-bg-color-grey` | `#f8f8f8` | 灰色区域背景 |
| `$uni-bg-color-hover` | `#f1f1f1` | 点击态 |
| `$uni-bg-color-mask` | `rgba(0,0,0,0.4)` | 遮罩层 |

### 边框色

| Token | 值 | 场景 |
|-------|-----|------|
| `$uni-border-color` | `#c8c7cc` | 默认边框 |
| `$uni-table-border-color` | `#e6ebf5` | 表格边框 |

### 菜单色

| Token | 默认值 | 用途 |
|-------|--------|------|
| `$menu-bg-color` | `#fff` | 一级菜单背景 |
| `$sub-menu-bg-color` | `darken(#fff, 8%)` | 子菜单背景 |
| `$menu-bg-color-hover` | `darken(#fff, 15%)` | 菜单 hover |
| `$menu-text-color` | `#333` | 菜单文字 |
| `$menu-text-color-actived` | `#409eff` | 菜单激活色 |

## 间距 Token

| Token | 值 | 建议用途 |
|-------|-----|----------|
| `$uni-spacing-col-sm` | `5px` | 列表项内间距 |
| `$uni-spacing-col-base` | `10px` | 表单项间距 |
| `$uni-spacing-col-lg` | `15px` | 区块间距 |
| `$uni-spacing-row-sm` | `10px` | 按钮组间距 |
| `$uni-spacing-row-base` | `15px` | 容器内边距 |
| `$uni-spacing-row-lg` | `20px` | 大区块间距 |

## 字号 Token

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-font-size-sm` | `12px` | 标签、辅助 |
| `$uni-font-size-base` | `14px` | 正文 |
| `$uni-font-size-lg` | `16px` | 小标题 |
| `$uni-font-size-title` | `20px` | 页面标题 |
| `$uni-font-size-subtitle` | `18px` | 副标题 |

## 圆角 Token

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-border-radius-sm` | `3px` | tag、badge |
| `$uni-border-radius-base` | `5px` | 按钮、输入框 |
| `$uni-border-radius-lg` | `10px` | 卡片、弹窗 |
| `$uni-border-radius-circle` | `50%` | 头像 |

## 图片尺寸 Token

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-img-size-sm` | `20px` | 图标 |
| `$uni-img-size-base` | `26px` | 列表缩略图 |
| `$uni-img-size-lg` | `40px` | 头像 |
