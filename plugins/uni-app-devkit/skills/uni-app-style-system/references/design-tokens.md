# Design Tokens 完整参考

## rpx 换算

| 设计稿宽度 | 1px = | 750rpx = |
|-----------|-------|----------|
| 750px | 1rpx | 屏幕宽度 |
| 375px | 2rpx | 屏幕宽度 |

## 颜色 Token 全表

### 语义色（10 角色）

| Token | Light | Dark | 用途 |
|-------|-------|------|------|
| `primary-color` | `#2979ff` | `#4d9fff` | 主操作、链接、激活态 |
| `primary-light` | `#e8f0fe` | `#1a3a5c` | 浅色背景、hover |
| `on-primary` | `#ffffff` | `#ffffff` | 主色背景上的文字/图标 |
| `secondary-color` | `#6366f1` | `#818cf8` | 次要交互元素 |
| `accent-color` | `#f97316` | `#fb923c` | CTA 按钮、高亮强调 |
| `success-color` | `#18bc37` | `#2dd47b` | 成功状态 |
| `warning-color` | `#f3a73f` | `#fbbf24` | 警告状态 |
| `danger-color` | `#e43d33` | `#f87171` | 错误、删除 |
| `info-color` | `#8f939c` | `#6b7280` | 信息、禁用 |
| `ring-color` | `#2979ff` | `#4d9fff` | 焦点环、选中轮廓 |

### 文字色

| Token | Light | Dark | 场景 |
|-------|-------|------|------|
| `$uni-text-color` | `#333` | `#e5e7eb` | 标题、正文 |
| `$uni-text-color-secondary` | `#666` | `#9ca3af` | 次要信息 |
| `$uni-text-color-grey` | `#999` | `#6b7280` | 辅助信息 |
| `$uni-text-color-placeholder` | `#808080` | `#4b5563` | placeholder |
| `$uni-text-color-disable` | `#c0c0c0` | `#374151` | 禁用态 |
| `$uni-text-color-inverse` | `#fff` | `#111827` | 深色背景上 |

### 背景色

| Token | Light | Dark | 场景 |
|-------|-------|------|------|
| `$uni-bg-color` | `#fff` | `#111827` | 页面背景 |
| `$uni-bg-color-secondary` | `#f8f8f8` | `#1f2937` | 次级背景 |
| `$uni-bg-color-hover` | `#f1f1f1` | `#374151` | 点击态 |
| `$uni-bg-color-mask` | `rgba(0,0,0,0.4)` | `rgba(0,0,0,0.6)` | 遮罩层 |
| `$uni-bg-color-card` | `#fff` | `#1f2937` | 卡片背景 |

### 边框色

| Token | Light | Dark | 场景 |
|-------|-------|------|------|
| `$uni-border-color` | `#e5e5e5` | `#374151` | 默认边框 |
| `$uni-border-color-light` | `#f0f0f0` | `#1f2937` | 浅色分割线 |
| `$uni-table-border-color` | `#e6ebf5` | `#2d3748` | 表格边框 |

### 阴影

| Token | Light | Dark | 用途 |
|-------|-------|------|------|
| `$uni-shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | `0 1px 2px rgba(0,0,0,0.3)` | 按钮、输入框 |
| `$uni-shadow-base` | `0 2px 8px rgba(0,0,0,0.08)` | `0 2px 8px rgba(0,0,0,0.4)` | 卡片、下拉 |
| `$uni-shadow-lg` | `0 8px 24px rgba(0,0,0,0.12)` | `0 8px 24px rgba(0,0,0,0.5)` | 弹窗、浮层 |

## 排版 Token

### 字号

| Token | 值 | 用途 | 字重 |
|-------|-----|------|------|
| `$uni-font-size-xs` | `10px` | 角标、标签 | 400 |
| `$uni-font-size-sm` | `12px` | 辅助文本、时间 | 400 |
| `$uni-font-size-base` | `14px` | 正文 | 400 |
| `$uni-font-size-lg` | `16px` | 小标题、强调 | 500 |
| `$uni-font-size-xl` | `18px` | 列表标题 | 600 |
| `$uni-font-size-title` | `20px` | 页面标题 | 600 |
| `$uni-font-size-display` | `24px` | 数据展示、大标题 | 700 |

### 字重

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-font-weight-regular` | `400` | 正文 |
| `$uni-font-weight-medium` | `500` | 强调 |
| `$uni-font-weight-semibold` | `600` | 标题 |
| `$uni-font-weight-bold` | `700` | 数据展示 |

### 行高

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-line-height-tight` | `1.2` | 标题 |
| `$uni-line-height-base` | `1.5` | 正文 |
| `$uni-line-height-relaxed` | `1.75` | 长文本 |

### 字体栈

```scss
$uni-font-family-base: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
  'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji',
  'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';

$uni-font-family-mono: 'SF Mono', SFMono-Regular, Consolas, 'Liberation Mono',
  Menlo, Courier, monospace;

$uni-font-family-cjk: 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei',
  'WenQuanYi Micro Hei', sans-serif;
```

## 间距 Token（4px 网格）

| Token | px | rpx (750) | 用途 |
|-------|-----|-----------|------|
| `$uni-space-1` | `4px` | `8rpx` | 最小间距（图标与文字） |
| `$uni-space-2` | `8px` | `16rpx` | 紧凑间距（列表项内） |
| `$uni-space-3` | `12px` | `24rpx` | 表单项内间距 |
| `$uni-space-4` | `16px` | `32rpx` | 容器内边距 |
| `$uni-space-5` | `20px` | `40rpx` | 区块间距 |
| `$uni-space-6` | `24px` | `48rpx` | 页面内边距 |
| `$uni-space-8` | `32px` | `64rpx` | 大区块间距 |
| `$uni-space-10` | `40px` | `80rpx` | 页面顶部间距 |
| `$uni-space-12` | `48px` | `96rpx` | 区域分隔 |

## 圆角 Token

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-radius-none` | `0` | 无圆角 |
| `$uni-radius-sm` | `4px` | tag、badge |
| `$uni-radius-base` | `8px` | 按钮、输入框、卡片 |
| `$uni-radius-lg` | `12px` | 弹窗、大卡片 |
| `$uni-radius-xl` | `16px` | 底部弹窗 |
| `$uni-radius-full` | `9999px` | 胶囊按钮 |

## 动效 Token

### 时长

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-duration-fast` | `150ms` | 按钮反馈、开关 |
| `$uni-duration-base` | `250ms` | 弹窗、面板展开 |
| `$uni-duration-slow` | `350ms` | 页面转场 |

### 缓动

| Token | 值 | 用途 |
|-------|-----|------|
| `$uni-ease-default` | `ease` | 通用 |
| `$uni-ease-in` | `ease-in` | 退出动画 |
| `$uni-ease-out` | `ease-out` | 进入动画 |
| `$uni-ease-spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | 弹性效果 |

## 菜单色（admin 专用）

| Token | Light | Dark | 用途 |
|-------|-------|------|------|
| `$menu-bg-color` | `#fff` | `#1f2937` | 一级菜单背景 |
| `$sub-menu-bg-color` | `darken(#fff, 8%)` | `#111827` | 子菜单背景 |
| `$menu-bg-color-hover` | `darken(#fff, 15%)` | `#374151` | 菜单 hover |
| `$menu-text-color` | `#333` | `#e5e7eb` | 菜单文字 |
| `$menu-text-color-actived` | `#409eff` | `#4d9fff` | 菜单激活色 |
