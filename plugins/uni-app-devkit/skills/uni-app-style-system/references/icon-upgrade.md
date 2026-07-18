# 图标升级方案

uni-app 默认的 `uni-icons` 图标数量少且风格陈旧。
本文件指导如何接入高质量图标库。

## 方案一：iconfont（推荐，三端通用）

### 1. 选择图标库

推荐从以下平台选择图标，导出为 iconfont 项目：

| 平台 | 特点 | 地址 |
|------|------|------|
| iconfont.cn | 国内最大，中文搜索方便 | https://www.iconfont.cn |
| IconPark | 字节出品，风格统一 | https://iconpark.oceanengine.com |
| Tabler Icons | 开源免费，2000+ 图标 | https://tabler-icons.io |
| Phosphor Icons | 风格精致，6000+ 图标 | https://phosphoricons.com |

### 2. 导出 iconfont

1. 在 iconfont.cn 创建项目
2. 添加需要的图标到项目
3. 下载项目，得到 `iconfont.css` + `iconfont.ttf`
4. 将文件放入 `static/fonts/` 目录

### 3. 全局引入

```js
// App.vue
<style>
@import './static/fonts/iconfont.css';
</style>
```

### 4. 使用

```vue
<!-- 基础用法 -->
<text class="iconfont icon-home"></text>
<text class="iconfont icon-search"></text>
<text class="iconfont icon-user"></text>

<!-- 带大小和颜色 -->
<text class="iconfont icon-home" style="font-size: 40rpx; color: #6366f1;"></text>
```

### 5. 封装组件

```vue
<!-- components/app-icon.vue -->
<template>
  <text
    class="iconfont"
    :class="'icon-' + name"
    :style="{ fontSize: size + 'rpx', color: color }"
  />
</template>

<script>
export default {
  props: {
    name: { type: String, required: true },
    size: { type: [Number, String], default: 40 },
    color: { type: String, default: '' },
  },
}
</script>
```

```vue
<!-- 使用 -->
<app-icon name="home" :size="48" color="#6366f1" />
<app-icon name="search" :size="36" />
```

## 方案二：SVG 图标组件（H5 端推荐）

### 1. 下载 SVG 文件

从 Tabler Icons 或 Phosphor Icons 下载 SVG 文件，放入 `static/icons/` 目录。

### 2. 封装 SVG 图标组件

```vue
<!-- components/svg-icon.vue -->
<!-- #ifdef H5 -->
<template>
  <view class="svg-icon" :style="{ width: size + 'rpx', height: size + 'rpx' }">
    <svg v-html="iconContent" :viewBox="viewBox" />
  </view>
</template>

<script>
// 预导入常用图标（避免运行时 fetch）
const icons = {
  home: '<path d="M5 12l-2 0l9-9l9 9l-2 0..." />',
  search: '<circle cx="11" cy="11" r="7" /><path d="M21 21l-4.35-4.35" />',
  // ... 更多图标
}

export default {
  props: {
    name: { type: String, required: true },
    size: { type: [Number, String], default: 40 },
  },
  computed: {
    iconContent() {
      return icons[this.name] || ''
    },
    viewBox() {
      return '0 0 24 24'
    },
  },
}
</script>

<style>
.svg-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.svg-icon svg {
  width: 100%;
  height: 100%;
  fill: none;
  stroke: currentColor;
  stroke-width: 2;
  stroke-linecap: round;
  stroke-linejoin: round;
}
</style>
<!-- #endif -->
```

## 方案三：自定义图标字体 + uni-icons 混用

渐进迁移方案，不一次性替换所有图标。

```vue
<!-- 新页面用 iconfont -->
<app-icon name="dashboard" :size="48" />

<!-- 旧页面暂不改，继续用 uni-icons -->
<uni-icons type="home" size="48" />
```

## 图标风格规范

### 线性 vs 面性

| 风格 | 特点 | 适用场景 |
|------|------|---------|
| 线性（Outlined） | 轻盈、现代 | 导航、工具类、管理后台 |
| 面性（Filled） | 饱和、醒目 | TabBar、强调操作、移动端 |

**规则：** 同一项目统一用一种风格，不要混用。

### 图标尺寸

| 场景 | 尺寸 | 说明 |
|------|------|------|
| TabBar 图标 | 48rpx | 系统 TabBar |
| 导航栏图标 | 40rpx | 返回、菜单、更多 |
| 列表图标 | 36rpx | 列表项前缀 |
| 表单图标 | 36rpx | 输入框内图标 |
| 按钮图标 | 28-32rpx | 按钮内配合文字 |
| 标签图标 | 24rpx | Tag、Badge 内 |

### 图标颜色

- 默认色：`$uni-text-color-secondary`
- 激活色：主色（如 `#6366f1`）
- 禁用色：`$uni-text-color-disable`
- 不要用纯黑 `#000` 做图标色

## Checklist

- [ ] 图标风格统一（全线性或全面性）
- [ ] 同场景图标尺寸一致
- [ ] 图标颜色来自 token 系统
- [ ] iconfont 文件已放入项目（不依赖 CDN）
- [ ] 封装了图标组件（统一调用方式）
