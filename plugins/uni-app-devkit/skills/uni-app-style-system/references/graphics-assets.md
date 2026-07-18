# 图形资源规范

本文件定义 uni-app 项目中的图标、插图、图片处理和品牌图形标准。

## 一、图标系统

### 图标库选择

| 库 | 数量 | 风格 | 适用 | 接入方式 |
|------|------|------|------|---------|
| iconfont.cn | 海量 | 混合 | 通用 | CSS + TTF |
| IconPark | 2400+ | 统一线性 | 管理后台 | SVG / iconfont |
| Tabler Icons | 3000+ | 线性 2px | 现代风格 | SVG / iconfont |
| Phosphor | 6000+ | 6 种粗细 | 高品质 | SVG / iconfont |

### 图标风格统一

同一项目**只用一种风格**：

| 风格 | 特征 | 适用 |
|------|------|------|
| 线性（Outlined） | 1.5-2px 描边，无填充 | 管理后台、工具类 |
| 面性（Filled） | 实心填充 | 消费类 App、TabBar |
| 双色（Duotone） | 主色 + 辅色 | 品牌感强的产品 |

### 图标尺寸规范

| 场景 | 尺寸 | 说明 |
|------|------|------|
| TabBar 图标 | 48rpx | 系统 TabBar |
| 导航栏图标 | 40rpx | 返回、菜单、更多 |
| 列表前缀 | 36rpx | 列表项左侧图标 |
| 表单图标 | 36rpx | 输入框内辅助图标 |
| 按钮内图标 | 28-32rpx | 与文字对齐 |
| 标签/Badge | 24rpx | 小图标 |
| 空状态大图标 | 120-160rpx | 空状态页 |

### 图标颜色

```scss
// 图标颜色继承文字色
.icon-default { color: $uni-text-color-secondary; }  // 默认
.icon-active  { color: $primary-color; }               // 激活
.icon-disabled { color: $uni-text-color-disable; }     // 禁用
.icon-danger  { color: #e43d33; }                      // 危险
```

### 图标封装

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

## 二、空状态插图

### 风格要求

- **统一风格** — 所有空状态插图用同一风格（线性/面性/扁平/3D）
- **颜色协调** — 使用主题色的浅色变体（如 primary-10%）
- **尺寸一致** — 240-320rpx
- **带引导** — 不是纯装饰，要引导用户操作

### 必须准备的插图

| 场景 | 文件名 | 说明 |
|------|--------|------|
| 通用空状态 | `empty-default.png` | 默认兜底 |
| 无搜索结果 | `empty-search.png` | 搜索无结果 |
| 无订单 | `empty-order.png` | 订单列表为空 |
| 无消息 | `empty-message.png` | 消息列表为空 |
| 无收藏 | `empty-favorite.png` | 收藏列表为空 |
| 购物车空 | `empty-cart.png` | 购物车为空 |
| 网络异常 | `error-network.png` | 断网状态 |
| 服务器错误 | `error-server.png` | 500 错误 |
| 404 页面 | `error-404.png` | 页面不存在 |
| 无权限 | `error-permission.png` | 无权限访问 |

### 空状态模板

```vue
<template>
  <view class="empty-state">
    <image :src="imgSrc" mode="aspectFit" class="empty-state__img" />
    <text class="empty-state__title">{{ title }}</text>
    <text v-if="desc" class="empty-state__desc">{{ desc }}</text>
    <button v-if="actionText" class="btn-primary" @click="$emit('action')">
      {{ actionText }}
    </button>
  </view>
</template>

<script>
export default {
  props: {
    type: { type: String, default: 'default' },
    title: { type: String, default: '暂无数据' },
    desc: { type: String, default: '' },
    actionText: { type: String, default: '' },
  },
  computed: {
    imgSrc() {
      const map = {
        default: '/static/empty/empty-default.png',
        search: '/static/empty/empty-search.png',
        order: '/static/empty/empty-order.png',
        network: '/static/empty/error-network.png',
        server: '/static/empty/error-server.png',
      }
      return map[this.type] || map.default
    }
  }
}
</script>

<style>
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 64rpx;
}
.empty-state__img {
  width: 280rpx;
  height: 280rpx;
  margin-bottom: 32rpx;
}
.empty-state__title {
  font-size: 32rpx;
  font-weight: 600;
  color: $uni-text-color;
  margin-bottom: 12rpx;
}
.empty-state__desc {
  font-size: 26rpx;
  color: $uni-text-color-secondary;
  margin-bottom: 48rpx;
  text-align: center;
}
</style>
```

## 三、图片处理

### 图片比例

| 场景 | 推荐比例 | mode | 说明 |
|------|---------|------|------|
| 商品封面 | 1:1 | `aspectFill` | 正方形裁剪 |
| 文章封面 | 16:9 | `aspectFill` | 横向裁剪 |
| 头像 | 1:1 | `aspectFill` | 圆形或圆角 |
| 轮播图 | 750:400 | `aspectFill` | 宽屏横图 |
| 详情长图 | 自适应 | `widthFix` | 宽度固定高度自适应 |

### 图片占位

```vue
<!-- 加载中占位 -->
<image
  :src="src"
  mode="aspectFill"
  :lazy-load="true"
  class="img-cover"
  @error="onImgError"
/>
```

```scss
.img-cover {
  background: $uni-bg-color-secondary;
  // 加载失败时显示灰色背景
}
```

```js
onImgError() {
  // 加载失败时替换为默认图
  this.src = '/static/placeholder.png'
}
```

### 图片优化

| 规则 | 说明 |
|------|------|
| 必须指定尺寸 | 防止布局抖动（CLS） |
| 列表图 lazy-load | 减少首屏加载量 |
| 格式优先 WebP | 体积更小 |
| 单图 ≤ 200KB | 小程序严格控制 |
| 大图上 CDN | 不放本地 |
| 缩略图 + 原图 | 列表用缩略图，点击查看原图 |

## 四、Logo 与品牌

### Logo 尺寸

| 场景 | 尺寸 | 格式 |
|------|------|------|
| 导航栏 Logo | 高度 32-40px | PNG（透明底） |
| 启动页 Logo | 200×200px | PNG |
| 侧边栏 Logo（展开） | 宽度 120-160px | PNG / SVG |
| 侧边栏 Logo（折叠） | 32×32px | PNG（图标版） |
| 分享图标 | 200×200px | PNG |

### 品牌色使用

```scss
// Logo 区域背景色
.sidebar-logo {
  background: $primary-color;  // 品牌主色
  // 或
  background: #fff;            // 白底 + 彩色 Logo
}
```

## 五、Favicon

```html
<!-- index.html -->
<link rel="icon" href="/favicon.ico" />
<link rel="apple-touch-icon" href="/static/icons/apple-touch-icon.png" />
```

| 规格 | 用途 |
|------|------|
| `favicon.ico` | 浏览器标签（16×16, 32×32） |
| `apple-touch-icon.png` | iOS 桌面图标（180×180） |
| `icon-192.png` | PWA 图标 |
| `icon-512.png` | PWA 大图标 |

## 六、资源目录结构

```
static/
├── icons/                  # 图标字体
│   ├── iconfont.css
│   ├── iconfont.ttf
│   └── iconfont.json
├── empty/                  # 空状态插图
│   ├── empty-default.png
│   ├── empty-search.png
│   ├── empty-order.png
│   ├── error-network.png
│   ├── error-server.png
│   └── error-404.png
├── images/                 # 通用图片
│   ├── logo.png
│   ├── logo-white.png
│   └── placeholder.png
└── fonts/                  # 自定义字体（如有，用 .ttf 格式兼容性最好）
    └── custom.ttf
```

## 七、图形资源 Checklist

- [ ] 图标风格统一（全线性或全面性）
- [ ] 图标尺寸按场景统一
- [ ] 空状态插图风格统一
- [ ] 图片全部指定尺寸（防抖动）
- [ ] 列表图用 lazy-load
- [ ] 图片加载失败有兜底图
- [ ] Logo 有展开/折叠两个版本
- [ ] Favicon 和 PWA 图标已配置
- [ ] 资源目录结构清晰
