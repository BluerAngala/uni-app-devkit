# App 端设计规范

本文件是 App 端（iOS / Android）的专属设计规范。
修改 App 相关样式前先读本文件。通用规则见 `SKILL.md`。

## 一、架构选择：vue 文件 vs nvue 文件

uni-app App 端有两种页面文件：

| 类型 | 渲染引擎 | CSS 支持 | 性能 |
|------|---------|---------|------|
| `.vue` | WebView 渲染 | 完整 CSS | 接近 H5 |
| `.nvue` | Weex 原生渲染 | **受限 CSS** | 原生级 |

**默认用 `.vue`**。只有需要原生级性能时才用 `.nvue`。

### nvue CSS 限制

| 特性 | nvue | 替代 |
|------|------|------|
| `box-shadow` | ⚠️ 仅 iOS | 用 `<view>` + 边框模拟 |
| `border-radius` | ⚠️ 仅 `<view>` | 用 `<view>` 包裹 |
| `position: sticky` | ❌ | 用 `scroll` + 固定定位 |
| CSS `transition` | ❌ | 用 `animation` 模块 |
| `::before` / `::after` | ❌ | 用 `<view>` 替代 |
| 百分比宽度 | ❌ | 用 flex 或 `rpx` |
| `z-index` | ⚠️ 仅同级 | 用 DOM 顺序控制 |
| `overflow: hidden` | ⚠️ 需配合 `border-radius` | — |

## 二、安全区

### 系统信息获取

```js
const systemInfo = uni.getSystemInfoSync()

// 状态栏高度
const statusBarHeight = systemInfo.statusBarHeight

// 安全区域
const safeArea = systemInfo.safeArea
// { top, bottom, left, right, width, height }

// 安全区 insets（部分机型）
const safeAreaInsets = systemInfo.safeAreaInsets
// { top, bottom, left, right }
```

### 安全区适配模板

```vue
<template>
  <view class="page">
    <!-- 状态栏占位 -->
    <view :style="{ height: statusBarHeight + 'px' }" />

    <!-- 导航栏 -->
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <uni-icons type="back" size="22" />
      </view>
      <text class="nav-title">{{ title }}</text>
      <view class="nav-right">
        <slot name="right" />
      </view>
    </view>

    <!-- 内容区 -->
    <view class="content">
      <slot />
    </view>

    <!-- 底部安全区（无 tabbar 页面） -->
    <view class="safe-area-bottom" />
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

<style>
.nav-bar {
  display: flex;
  align-items: center;
  height: 88rpx;
  padding: 0 24rpx;
  background-color: $uni-bg-color;
}

.safe-area-bottom {
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
}
</style>
```

### 沉浸式状态栏

```json
// pages.json — App 页面配置
{
  "style": {
    "app-plus": {
      "titleNView": false,
      "bounce": "none"
    }
  }
}
```

```js
// 沉浸式页面需要手动处理状态栏
// #ifdef APP-PLUS
plus.navigator.setStatusBarStyle('light')  // 深色背景用白色状态栏
plus.navigator.setStatusBarStyle('dark')   // 浅色背景用黑色状态栏
// #endif
```

## 三、原生导航栏

### titleNView 配置

```json
{
  "path": "pages/detail/detail",
  "style": {
    "navigationBarTitleText": "详情",
    "app-plus": {
      "titleNView": {
        "backgroundColor": "#ffffff",
        "titleColor": "#333333",
        "buttons": [
          {
            "text": "编辑",
            "color": "#2979ff",
            "float": "right"
          }
        ]
      }
    }
  }
}
```

### 自定义导航栏（App）

```json
{
  "style": {
    "app-plus": {
      "titleNView": false
    }
  }
}
```

```vue
<!-- 自定义导航栏需要处理状态栏 + 导航栏高度 -->
<template>
  <view class="page">
    <view :style="{ height: systemInfo.statusBarHeight + 'px' }" />
    <view class="custom-nav" :style="{ height: navHeight + 'px' }">
      <!-- 导航内容 -->
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      systemInfo: {},
      navHeight: 44,
    }
  },
  onLoad() {
    this.systemInfo = uni.getSystemInfoSync()
    // #ifdef APP-PLUS
    this.navHeight = 44  // iOS 标准导航栏高度
    // #endif
  },
}
</script>
```

## 四、手势与返回

### iOS 左滑返回

iOS 系统级左滑返回手势，页面左侧约 20px 是热区。

```scss
// ❌ 左侧 20px 放按钮会被手势吞掉
.action-button {
  position: fixed;
  left: 10px;  // 会被 iOS 手势覆盖
}

// ✅ 给左侧留够空间
.action-button {
  position: fixed;
  left: 40px;  // 超出手势热区
}
```

### Android 返回键

```js
export default {
  methods: {
    // 拦截 Android 返回键
    onBackPress() {
      if (this.hasUnsavedChanges) {
        uni.showModal({
          title: '提示',
          content: '有未保存的修改，确定离开吗？',
          success: (res) => {
            if (res.confirm) {
              uni.navigateBack()
            }
          },
        })
        return true  // 阻止默认返回
      }
      // return false 或不 return → 执行默认返回
    },
  },
}
```

### 返回行为统一

| 场景 | iOS 行为 | Android 行为 | 统一方案 |
|------|---------|-------------|---------|
| 无未保存数据 | 左滑返回 | 返回键 | 默认行为 |
| 有未保存数据 | 弹确认框 | 弹确认框 | `onBackPress` 返回 `true` |
| 首页/最后一页 | 无操作 | 退出 App | `onBackPress` 处理 |

## 五、字体加载

```js
// App 端加载自定义字体
// #ifdef APP-PLUS
uni.loadFontFace({
  family: 'CustomFont',
  source: 'url("https://cdn.example.com/fonts/custom.ttf")',
  success: () => {
    console.log('字体加载成功')
  },
  fail: (err) => {
    console.error('字体加载失败', err)
  },
})
// #endif
```

**注意：**
- App 端字体文件建议放在 CDN
- `.ttf` 格式兼容性最好
- 加载失败时用系统字体 fallback

## 六、动画

### CSS Transition（vue 文件）

```scss
// .vue 文件中可用 CSS transition
.fade-enter-active, .fade-leave-active {
  transition: opacity $uni-duration-base $uni-ease-out;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
```

### Animation 模块（nvue 文件）

```js
// nvue 不支持 CSS transition，用 animation 模块
const animation = uni.createAnimation({
  duration: 250,
  timingFunction: 'ease-out',
})

animation.translateY(0).step()
animation.translateY(100).step()

this.animationData = animation.export()
```

### App 端原生动画

```js
// #ifdef APP-PLUS
// 使用 native.js 调用原生动画（高性能）
const view = plus.nativeObj.View.getViewById('myView')
view.animate({
  transform: { translateX: '100px' },
  duration: 250,
})
// #endif
```

## 七、原生组件

### nvue 原生组件

nvue 文件中的组件是原生渲染，性能更好：

```vue
<!-- nvue 文件 -->
<template>
  <list>
    <cell v-for="item in list" :key="item.id">
      <text>{{ item.name }}</text>
    </cell>
  </list>
</template>
```

### 原生导航栏按钮回调

```js
// #ifdef APP-PLUS
onReady() {
  const currentWebview = this.$scope.$getAppWebview()
  const titleNView = currentWebview.getStyle().titleNView
  // 监听导航栏按钮点击
  currentWebview.addEventListener('titleNViewButtonPressed', (e) => {
    if (e.index === 0) {
      this.handleEdit()
    }
  })
}
// #endif
```

## 八、App 专属交互

### 震动反馈

```js
// 轻触反馈
uni.vibrateShort({
  type: 'light',
  success: () => {},
})

// 长按反馈
uni.vibrateLong({
  success: () => {},
})
```

### 原生对话框

```js
// App 端的原生对话框比小程序更丰富
// #ifdef APP-PLUS
plus.nativeUI.actionSheet(
  {
    title: '选择操作',
    cancel: '取消',
    buttons: [{ title: '拍照' }, { title: '从相册选择' }],
  },
  (e) => {
    if (e.index === 1) this.takePhoto()
    if (e.index === 2) this.chooseFromAlbum()
  }
)
// #endif
```

### 剪贴板

```js
uni.setClipboardData({
  data: '要复制的内容',
  success: () => {
    uni.showToast({ title: '已复制' })
  },
})
```

## 九、性能优化

### 原生渲染加速

```json
// pages.json — 使用 nvue 原生渲染
{
  "path": "pages-heavy/list",
  "style": {
    "app-plus": {
      "renderingMode": "native"
    }
  }
}
```

### 分包预加载

```json
{
  "preloadRule": {
    "pages/index/index": {
      "network": "all",
      "packages": ["pages-sub/heavy"]
    }
  }
}
```

### 内存管理

```js
// 页面卸载时清理
onUnload() {
  // 清除定时器
  if (this.timer) clearInterval(this.timer)
  // 移除事件监听
  uni.$off('update', this.onUpdate)
  // 释放大对象
  this.bigList = null
}
```

## 十、App 专属 Checklist

- [ ] 安全区适配（状态栏 + 底部安全区）
- [ ] 自定义导航栏处理了状态栏高度
- [ ] Android 返回键已处理（`onBackPress`）
- [ ] iOS 左侧 20px 无交互元素冲突
- [ ] 有未保存数据时拦截返回
- [ ] 沉浸式页面设置了正确的状态栏颜色
- [ ] nvue 页面用了原生组件（list/cell/waterfall）
- [ ] 字体加载有 fallback
- [ ] 大页面已分包或预加载
- [ ] 页面卸载时清理了定时器/事件/大对象
