# 小程序端设计规范

本文件是小程序端（微信/支付宝/字节/QQ/快手等）的专属设计规范。
修改小程序相关样式前先读本文件。通用规则见 `SKILL.md`。

## 一、布局约束

### 不支持的 CSS 特性

| 特性 | 小程序 | 替代方案 |
|------|--------|---------|
| CSS Grid | ❌ | flex 布局 |
| `vh` / `vw` | ❌ | rpx / px |
| `rem` | ❌ | rpx / px |
| `::before` / `::after` | ⚠️ 部分支持 | 用 `<view>` 替代 |
| `nth-child` | ❌ | 用数据驱动 `:class` |
| `box-shadow` spread | ❌ | 用边框模拟 |
| `calc()` 混合 rpx+px | ⚠️ 不稳定 | 统一用 rpx |
| flex `gap` | ❌ | 用 `margin` 替代 |
| CSS 变量 `var()` | ⚠️ 基础库 2.x+ | 用 SCSS 变量更安全 |
| `backdrop-filter` | ❌ | 用半透明背景色 |
| `position: sticky` | ⚠️ 部分支持 | 用 `scroll-view` + 固定定位 |

### flex 布局（小程序唯一布局方案）

```scss
// 2 列
.grid-2 {
  display: flex;
  flex-wrap: wrap;
  > .grid-item {
    width: 50%;
    box-sizing: border-box;
    padding: $uni-space-2;
  }
}

// 3 列
.grid-3 {
  display: flex;
  flex-wrap: wrap;
  > .grid-item {
    width: 33.333%;
    box-sizing: border-box;
    padding: $uni-space-2;
  }
}

// 水平居中
.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

// 两端对齐
.flex-between {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
```

### 阴影替代方案

```scss
// ❌ 小程序不支持 spread-radius
// box-shadow: 0 2px 8px 2px rgba(0,0,0,0.08);  // 第 4 个参数不生效

// ✅ 用边框模拟阴影
.card {
  border: 1px solid $uni-border-color-light;
  // 或者用多层 box-shadow（不含 spread）
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
```

## 二、单位规范

### rpx 使用规则

| 场景 | 单位 | 示例 |
|------|------|------|
| 宽度/高度 | rpx | `width: 200rpx` |
| 内边距/外边距 | rpx | `padding: 24rpx` |
| 字号 | rpx 或 px | `font-size: 28rpx` |
| 边框 | px | `border: 1px solid #eee` |
| 圆角 | px 或 rpx | `border-radius: 8rpx` |
| 图标尺寸 | rpx | `width: 40rpx` |

**设计稿换算：** 750px 宽度设计稿，1px = 1rpx。

### 避免的问题

```scss
// ❌ rpx 和 px 混用导致不对齐
padding-left: 20rpx;
padding-right: 10px;  // 不一致

// ✅ 统一单位
padding-left: 20rpx;
padding-right: 20rpx;
```

## 三、导航与页面栈

### 页面栈限制

微信小程序页面栈上限 **10 层**，超出会自动关闭最早的页面。

```js
// 超过 5 层时用 redirectTo 替代 navigateTo
const pages = getCurrentPages()
if (pages.length >= 5) {
  uni.redirectTo({ url: '/pages/detail/detail?id=' + id })
} else {
  uni.navigateTo({ url: '/pages/detail/detail?id=' + id })
}
```

### tabBar 页面

```js
// tabBar 页面只能用 switchTab
uni.switchTab({ url: '/pages/index/index' })
// ❌ navigateTo 对 tabBar 页面无效
```

### 导航栏配置

```json
// pages.json
{
  "pages": [
    {
      "path": "pages/index/index",
      "style": {
        "navigationBarTitleText": "首页",
        "navigationBarBackgroundColor": "#ffffff",
        "navigationBarTextStyle": "black"
      }
    }
  ]
}
```

### 自定义导航栏

```json
{
  "style": {
    "navigationStyle": "custom"
  }
}
```

```vue
<template>
  <view>
    <!-- 手动处理状态栏高度 -->
    <view :style="{ height: statusBarHeight + 'px' }" />
    <view class="custom-nav">
      <view class="nav-back" @click="goBack">
        <uni-icons type="back" size="20" />
      </view>
      <text class="nav-title">{{ title }}</text>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      statusBarHeight: 0,
    }
  },
  onLoad() {
    this.statusBarHeight = uni.getSystemInfoSync().statusBarHeight
  },
}
</script>
```

## 四、表单与键盘

### 键盘弹出

```vue
<!-- 自动调整页面位置（键盘弹出时页面上推） -->
<input :adjust-position="true" />

<!-- 不需要页面上推（如搜索框在顶部） -->
<input :adjust-position="false" />
```

### confirm-type

```vue
<!-- 搜索框：键盘显示"搜索"按钮 -->
<input confirm-type="search" @confirm="doSearch" />

<!-- 下一步：键盘显示"下一个" -->
<input confirm-type="next" />

<!-- 发送：键盘显示"发送" -->
<input confirm-type="send" />
```

### 表单底部防遮挡

```vue
<template>
  <view class="form-page">
    <uni-forms>
      <!-- 表单项 -->
    </uni-forms>
    <!-- 底部留白，防止键盘遮挡 -->
    <view class="form-bottom-space" />
  </view>
</template>

<style>
.form-bottom-space {
  height: 300rpx; /* 键盘高度大概 500-700rpx，留够空间 */
}
</style>
```

## 五、滚动与列表

### 下拉刷新

```json
// pages.json
{
  "style": {
    "enablePullDownRefresh": true
  }
}
```

```js
export default {
  onPullDownRefresh() {
    this.loadData().then(() => {
      uni.stopPullDownRefresh()
    })
  },
}
```

### 上拉加载

```js
export default {
  onReachBottom() {
    if (this.hasMore && !this.loading) {
      this.loadMore()
    }
  },
}
```

### 滚动穿透

```vue
<!-- 弹窗打开时禁止背景滚动 -->
<view catchtouchmove="preventTouchMove">
  <!-- 弹窗内容 -->
</view>

<!-- 或者用 @touchmove.stop.prevent -->
<view @touchmove.stop.prevent>
```

## 六、图片

### 尺寸规范

```vue
<!-- 必须指定尺寸，防止布局抖动 -->
<image
  :src="item.cover"
  mode="aspectFill"
  lazy-load
  style="width: 200rpx; height: 200rpx;"
/>

<!-- ❌ 不指定尺寸 -->
<image :src="item.cover" />
```

### 图片模式

| mode | 用途 |
|------|------|
| `aspectFill` | 裁剪填充（头像、封面） |
| `aspectFit` | 完整显示（商品图） |
| `widthFix` | 宽度固定高度自适应（长图） |
| `heightFix` | 高度固定宽度自适应 |

### 图片优化

- 单图 ≤ 200KB
- 格式优先 WebP
- 大图上 CDN，不放本地
- 列表图必须 `lazy-load`

## 七、点击反馈

小程序没有 `:hover` 伪类，用 `hover-class` 替代。

```vue
<view
  class="list-item"
  hover-class="list-item--hover"
  :hover-stay-time="200"
  @click="handleClick"
>
  内容
</view>
```

```scss
.list-item {
  padding: $uni-space-3 $uni-space-4;
  transition: background-color $uni-duration-fast ease;
}

.list-item--hover {
  background-color: $uni-bg-color-hover;
}
```

## 八、安全区

```vue
<template>
  <!-- 底部安全区（无 tabbar 的页面） -->
  <view class="page">
    <!-- 页面内容 -->
    <view class="safe-area-bottom" />
  </view>
</template>

<style>
.safe-area-bottom {
  /* iOS 刘海屏底部安全区 */
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
}
</style>
```

## 九、setData 性能

小程序的 `setData` 是跨线程通信，数据量直接影响性能。

```js
// ❌ 大对象 setData
this.setData({ list: this.hugeList })  // 超过 256KB 会卡顿

// ✅ uni-app 直接赋值（框架自动 diff 优化）
this.list = newList  // 框架只传输 diff 部分
```

### 数据量控制

- 单次 setData 数据 < 256KB
- 避免频繁 setData（用 debounce 合并）
- 长列表用分页加载，不一次性拉取

## 十、小程序专属 Checklist

- [ ] 布局用 flex，不用 CSS Grid
- [ ] 单位用 rpx/px，不用 rem/vh/vw
- [ ] 阴影不含 spread-radius（或用边框模拟）
- [ ] 图片指定了 `width` + `height` + `lazy-load`
- [ ] 页面栈 < 10 层（超限用 `redirectTo`）
- [ ] tabBar 页面用 `switchTab`
- [ ] 弹窗打开时背景不可滚动
- [ ] 表单底部有防键盘遮挡的 padding
- [ ] 可点击元素用 `hover-class`
- [ ] 无 tabbar 页面有底部安全区 padding
- [ ] 自定义导航栏处理了状态栏高度
