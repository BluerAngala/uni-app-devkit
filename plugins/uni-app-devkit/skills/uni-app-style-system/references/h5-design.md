# H5 端设计规范

本文件是 H5（Web）端的专属设计规范。修改 H5 相关样式前先读本文件。
通用规则见 `SKILL.md`，token 表见 `design-tokens.md`。

## 一、布局能力

H5 端拥有最完整的 CSS 能力。

### CSS Grid（H5 独有优势）

```scss
// ✅ H5 可以用 CSS Grid，小程序/App 不行
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: $uni-space-4;
}

// 12 列栅格
.grid-12 {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: $uni-space-4;
}
```

### 响应式断点

| 断点 | 宽度 | 场景 |
|------|------|------|
| `xs` | < 576px | 手机竖屏 |
| `sm` | 576-767px | 手机横屏 |
| `md` | 768-991px | 平板 |
| `lg` | 992-1199px | 小桌面 |
| `xl` | ≥ 1200px | 大桌面 |

```scss
// 响应式写法（条件编译 + 媒体查询）
/* #ifdef H5 */
@media (min-width: 768px) {
  .page-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: $uni-space-6;
  }
}
/* #endif */
```

### 容器最大宽度

```scss
/* #ifdef H5 */
.page-content {
  max-width: 1200px;    // 内容区
  margin: 0 auto;
  padding: 0 $uni-space-6;
}
.page-content--narrow {
  max-width: 800px;     // 文章/表单
}
/* #endif */
```

## 二、单位与响应式

### 可用单位

| 单位 | H5 | 说明 |
|------|-----|------|
| `rpx` | ✅ | 响应式，推荐 |
| `px` | ✅ | 固定尺寸 |
| `%` | ✅ | 百分比 |
| `rem` | ✅ | **可用但不推荐**（小程序不支持，跨端不一致） |
| `vh` / `vw` | ✅ | **可用但不推荐**（小程序不支持） |
| `dvh` | ✅ | 动态视口高度（iOS Safari 地址栏适配） |

**统一用 rpx + px，不用 rem/vh/vw** — 即使 H5 支持，跨端一致性更重要。

### 视口高度处理

```scss
/* #ifdef H5 */
// iOS Safari 地址栏收缩会导致 100vh 跳动
// 用 dvh（dynamic viewport height）替代
.full-screen {
  min-height: 100dvh;  // 不用 100vh
}
/* #endif */
```

## 三、交互特性

### Hover 状态（H5 独有）

```scss
/* #ifdef H5 */
// H5 支持 :hover 伪类
.list-item {
  transition: background-color $uni-duration-fast ease;
  &:hover {
    background-color: $uni-bg-color-hover;
  }
}

.button {
  cursor: pointer;  // H5 必须加
  transition: all $uni-duration-fast ease;
  &:hover {
    opacity: 0.9;
    transform: translateY(-1px);
  }
  &:active {
    transform: translateY(0);
  }
}
/* #endif */
```

### 滚动行为

```scss
/* #ifdef H5 */
// H5 的滚动容器
.scroll-container {
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;  // iOS 惯性滚动
  overscroll-behavior: contain;       // 防止滚动穿透
}
/* #endif */
```

### 阴影（完整支持）

```scss
/* #ifdef H5 */
// H5 支持完整的 box-shadow（含 spread-radius）
.card {
  box-shadow: $uni-shadow-base;  // 完整 4 参数阴影
  transition: box-shadow $uni-duration-fast ease;
  &:hover {
    box-shadow: $uni-shadow-lg;  // hover 加深
  }
}
/* #endif */
```

## 四、导航栏

H5 没有系统导航栏，需要自己实现。

```vue
<!-- #ifdef H5 -->
<view class="h5-header">
  <view class="h5-header__left">
    <uni-icons type="back" @click="goBack" />
  </view>
  <view class="h5-header__title">{{ title }}</view>
  <view class="h5-header__right">
    <slot name="right" />
  </view>
</view>
<!-- #endif -->
```

```scss
/* #ifdef H5 */
.h5-header {
  display: flex;
  align-items: center;
  height: 56px;
  padding: 0 $uni-space-4;
  background-color: $uni-bg-color;
  border-bottom: 1px solid $uni-border-color;
  position: sticky;
  top: 0;
  z-index: 100;
}
/* #endif */
```

## 五、表单

### 输入框自动缩放

iOS Safari 在输入框字号 < 16px 时会自动放大页面。

```scss
/* #ifdef H5 */
input, textarea {
  font-size: 16px;  // 最小 16px，防止 iOS 自动缩放
}
/* #endif */
```

### 表单验证

```scss
/* #ifdef H5 */
// H5 可以用 CSS 验证状态
input:invalid {
  border-color: getTheme('danger-color');
}
input:focus:invalid {
  box-shadow: 0 0 0 3px rgba(getTheme('danger-color'), 0.2);
}
/* #endif */
```

## 六、字体

### 自定义字体加载

```js
// #ifdef H5
// H5 可以用 @font-face 或 Google Fonts
// 但要控制加载性能
const font = new FontFace('CustomFont', 'url(/fonts/custom.woff2)')
font.load().then(() => {
  document.fonts.add(font)
})
// #endif
```

### 字体栈

```scss
// H5 端可以用更丰富的字体栈
$uni-font-family-h5: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
  Roboto, 'Helvetica Neue', Arial, sans-serif;
```

## 七、动画

### CSS Transition（完整支持）

```scss
/* #ifdef H5 */
// H5 支持完整的 CSS transition
.page-enter-active, .page-leave-active {
  transition: opacity $uni-duration-base $uni-ease-out,
              transform $uni-duration-base $uni-ease-out;
}
.page-enter-from {
  opacity: 0;
  transform: translateX(20px);
}
.page-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}
/* #endif */
```

### will-change（性能优化）

```scss
/* #ifdef H5 */
.animated-element {
  will-change: transform, opacity;
}
/* #endif */
```

## 八、H5 专属 Checklist

- [ ] `cursor: pointer` 加到所有可点击元素
- [ ] `min-height: 100dvh`（不用 `100vh`）
- [ ] 输入框字号 ≥ 16px（防 iOS 缩放）
- [ ] `overscroll-behavior: contain`（防滚动穿透）
- [ ] 容器有 `max-width`（大屏不撑满）
- [ ] `sticky` 导航栏有 `z-index`
- [ ] 响应式断点已覆盖（768px / 1024px / 1200px）
