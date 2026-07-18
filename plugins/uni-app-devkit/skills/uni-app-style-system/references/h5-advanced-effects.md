# H5 端高级视觉效果

H5 端拥有完整的 CSS 能力，可以做到接近 React 生态的视觉品质。
本文件收集 H5 端可用的高级视觉效果，全部用条件编译保护。

## 一、毛玻璃效果

```scss
/* #ifdef H5 */
.glass-card {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: $uni-radius-lg;
}

// 深色模式毛玻璃
.theme-dark .glass-card {
  background: rgba(17, 24, 39, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.08);
}
/* #endif */
```

用途：导航栏、浮层、卡片叠加在图片上时。

## 二、CSS Grid 高级布局

### Bento Grid（错落网格）

```scss
/* #ifdef H5 */
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: 200px;
  gap: 16px;
}

.bento-item--wide { grid-column: span 2; }
.bento-item--tall { grid-row: span 2; }
.bento-item--featured {
  grid-column: span 2;
  grid-row: span 2;
}
/* #endif */
```

### Dashboard 网格

```scss
/* #ifdef H5 */
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
}
/* #endif */
```

## 三、滚动驱动动画

### 元素进入视口时淡入

```vue
<!-- #ifdef H5 -->
<view class="fade-in-section" ref="section">
  <slot />
</view>
<!-- #endif -->
```

```scss
/* #ifdef H5 */
.fade-in-section {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease-out, transform 0.6s ease-out;

  &.is-visible {
    opacity: 1;
    transform: translateY(0);
  }
}
/* #endif */
```

```js
// #ifdef H5
onReady() {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible')
          observer.unobserve(entry.target)
        }
      })
    },
    { threshold: 0.1 }
  )

  this.$nextTick(() => {
    document.querySelectorAll('.fade-in-section').forEach((el) => {
      observer.observe(el)
    })
  })
}
// #endif
```

### 交错动画（stagger）

```scss
/* #ifdef H5 */
.stagger-list {
  .stagger-item {
    opacity: 0;
    transform: translateY(20px);
    transition: opacity 0.4s ease-out, transform 0.4s ease-out;

    @for $i from 1 through 10 {
      &:nth-child(#{$i}) {
        transition-delay: #{$i * 0.08}s;
      }
    }
  }

  &.is-visible .stagger-item {
    opacity: 1;
    transform: translateY(0);
  }
}
/* #endif */
```

## 四、渐变与纹理

### 高级渐变背景

```scss
/* #ifdef H5 */
// 网格渐变
.hero-gradient {
  background:
    radial-gradient(at 20% 80%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
    radial-gradient(at 80% 20%, rgba(139, 92, 246, 0.1) 0%, transparent 50%),
    radial-gradient(at 50% 50%, rgba(236, 72, 153, 0.05) 0%, transparent 50%);
}

// 噪点纹理叠加
.noise-overlay {
  position: relative;
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background-image: url("data:image/svg+xml,...");  // SVG 噪点
    opacity: 0.03;
    pointer-events: none;
  }
}

// 网格线背景
.grid-pattern {
  background-image:
    linear-gradient(rgba(0,0,0,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,0,0,0.03) 1px, transparent 1px);
  background-size: 40px 40px;
}
/* #endif */
```

## 五、高级阴影

### 多层阴影（真实感）

```scss
/* #ifdef H5 */
.shadow-realistic {
  box-shadow:
    0 1px 1px rgba(0,0,0,0.02),
    0 2px 2px rgba(0,0,0,0.02),
    0 4px 4px rgba(0,0,0,0.02),
    0 8px 8px rgba(0,0,0,0.02),
    0 16px 16px rgba(0,0,0,0.02);
}

// 悬浮效果
.shadow-hover {
  transition: box-shadow $uni-duration-base ease, transform $uni-duration-base ease;
  &:hover {
    box-shadow:
      0 4px 4px rgba(0,0,0,0.02),
      0 8px 8px rgba(0,0,0,0.02),
      0 16px 16px rgba(0,0,0,0.04),
      0 32px 32px rgba(0,0,0,0.04);
    transform: translateY(-4px);
  }
}

// 彩色阴影
.shadow-colored {
  box-shadow: 0 8px 24px rgba(99, 102, 241, 0.25);
}
/* #endif */
```

## 六、裁切与形状

### `clip-path` 形状

```scss
/* #ifdef H5 */
// 斜切背景
.skew-section {
  clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
}

// 圆形头像带边框
.avatar-ring {
  clip-path: circle(50%);
  border: 3px solid #6366f1;
  padding: 3px;
}

// 六边形
.hexagon {
  clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
}
/* #endif */
```

## 七、文字效果

### 渐变文字

```scss
/* #ifdef H5 */
.text-gradient {
  background: linear-gradient(135deg, #6366f1 0%, #ec4899 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
/* #endif */
```

### 文字描边

```scss
/* #ifdef H5 */
.text-outline {
  -webkit-text-stroke: 1px #6366f1;
  -webkit-text-fill-color: transparent;
}
/* #endif */
```

## 八、自定义滚动条

```scss
/* #ifdef H5 */
::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.15);
  border-radius: 3px;

  &:hover {
    background: rgba(0, 0, 0, 0.25);
  }
}
/* #endif */
```

## 九、平滑滚动

```scss
/* #ifdef H5 */
html {
  scroll-behavior: smooth;
}
/* #endif */
```

## 十、使用原则

| 原则 | 说明 |
|------|------|
| **条件编译保护** | 所有效果必须 `#ifdef H5` 包裹 |
| **性能优先** | 只动画 `transform` 和 `opacity` |
| **`will-change` 谨慎** | 只加在即将动画的元素上，动画结束后移除 |
| **尊重用户** | `prefers-reduced-motion` 时禁用动画 |
| **不过度使用** | 每个页面最多 2-3 个高级效果，不要全部堆上 |
