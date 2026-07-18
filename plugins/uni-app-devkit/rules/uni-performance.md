---
name: uni-performance
description: "uni-app 性能规范。适用于分包加载、图片优化、长列表、小程序 setData、包体积控制的编写和审查。"
alwaysApply: true
---

# 性能规范

## 1. 分包加载

主包只放启动必需的页面和公共代码，业务页面必须分包。

### 包体积限制

| 平台 | 主包 | 单个分包 | 总计 |
|------|------|---------|------|
| 微信小程序 | 2MB | 2MB | 20MB |
| 支付宝小程序 | 2MB | 2MB | 8MB |
| H5 | 无限制 | — | — |
| App | 无限制 | — | — |

### 分包配置

```json
{
  "pages": [
    { "path": "pages/index/index" },
    { "path": "pages/login/login" },
    { "path": "pages/error/404" }
  ],
  "subPackages": [
    {
      "root": "pages-sub/user",
      "pages": [
        { "path": "list", "style": { "navigationBarTitleText": "用户列表" } },
        { "path": "add", "style": { "navigationBarTitleText": "新增用户" } }
      ]
    },
    {
      "root": "pages-sub/product",
      "pages": [
        { "path": "list" },
        { "path": "detail" }
      ]
    }
  ],
  "preloadRule": {
    "pages/index/index": {
      "network": "all",
      "packages": ["pages-sub/user"]
    }
  }
}
```

### 分包原则

- 主包：登录页、首页、404、公共组件/工具
- 分包：按业务模块划分（用户、商品、订单等）
- 公共依赖放主包，避免重复打包
- 使用 `preloadRule` 预加载即将访问的分包

## 2. 图片优化

| 要求 | 说明 |
|------|------|
| 格式优先级 | WebP > PNG > JPG，不用 BMP/TIFF |
| 单图上限 | 200KB（小程序严格控制） |
| 大图上 CDN | 不放本地，用网络地址 |
| 指定尺寸 | `<image>` 必须设 `width` 和 `height`，防布局抖动 |
| 懒加载 | 列表图片用 `lazy-load` 属性 |

```vue
<!-- ✅ -->
<image :src="item.cover" mode="aspectFill" lazy-load
  style="width: 200rpx; height: 200rpx;" />

<!-- ❌ 不指定尺寸，导致 CLS -->
<image :src="item.cover" />
```

## 3. 长列表优化

### 虚拟滚动

超过 100 条的列表必须用虚拟滚动或分页加载。

```vue
<!-- 使用 uni-ui 的虚拟列表组件（需安装: npm install @dcloudio/uni-ui） -->
<virtual-list :height="800" :item-height="80" :list="list">
  <template #default="{ item }">
    <view class="list-item">{{ item.name }}</view>
  </template>
</virtual-list>
```

### 分页加载

```js
// ✅ 分页加载，不一次性拉取全部
async loadData(page = 1) {
  const res = await productCo.list({ page, pageSize: 20 })
  if (page === 1) {
    this.list = res.data
  } else {
    this.list = [...this.list, ...res.data]  // 追加
  }
  this.hasMore = this.list.length < res.total
}

// ✅ 触底加载更多
onReachBottom() {
  if (this.hasMore && !this.loading) {
    this.loadData(this.page + 1)
  }
}
```

### 禁止

```js
// ❌ 一次性加载全部数据
const res = await productCo.list({ page: 1, pageSize: 99999 })
this.list = res.data
```

## 4. 小程序数据更新优化

uni-app 中直接赋值 `this.xxx = value` 即可，框架自动转换为小程序 `setData` 并做 diff。**禁止直接调用 `this.setData()`**（那是微信原生 API，uni-app 中不需要）。

```js
// ❌ 频繁赋值触发多次 setData
this.list.forEach((item, i) => {
  setTimeout(() => {
    item.checked = true
  }, i * 10)
})

// ✅ 合并一次赋值，框架只触发一次 setData
this.list = this.list.map(item => ({ ...item, checked: true }))
```

### 减少数据量

```js
// ❌ 传输整个大对象（即使只改一个字段）
this.formData = { ...this.formData, name: '新名称' }

// ✅ 只更新变化的字段（uni-app 自动 diff）
this.formData.name = '新名称'
```

### 注意事项

- 不要调用 `this.setData()`，那是原生小程序 API，uni-app 已封装
- 批量修改多个字段时，合并到一次赋值中
- 对象/数组的深层修改需要用新引用触发响应（`this.list = [...this.list]`）

## 5. 网络请求优化

| 策略 | 说明 |
|------|------|
| 请求防抖 | 搜索输入用 `debounce`，300ms 延迟 |
| 并行请求 | 无依赖的请求用 `Promise.all` |
| 缓存策略 | 不常变的数据缓存到 `Storage`，设过期时间 |
| 取消重复请求 | 同一接口正在请求时跳过 |

```js
// ✅ 搜索防抖
import { debounce } from 'lodash-es'

export default {
  created() {
    this.debouncedSearch = debounce(this.doSearch, 300)
  },
  methods: {
    onInput(e) {
      this.query = e.detail.value
      this.debouncedSearch()
    },
    async doSearch() {
      if (!this.query.trim()) return
      const res = await productCo.list({ where: { name: this.query } })
      this.list = res.data
    },
  },
}
```

## 6. 组件优化

| 策略 | 说明 |
|------|------|
| `v-if` vs `v-show` | 不频繁切换的用 `v-if`，频繁切换的用 `v-show` |
| `v-for` 必加 `:key` | 用唯一 ID，不用 index |
| 组件懒加载 | 非首屏组件用异步组件 |
| 避免深层嵌套 | 组件嵌套不超过 5 层 |

```vue
<!-- ✅ 异步组件 -->
<script>
export default {
  components: {
    HeavyChart: () => import('@/components/HeavyChart.vue'),
  },
}
</script>
```

## 7. 首屏优化

| 策略 | 说明 |
|------|------|
| 骨架屏 | 加载中显示骨架屏，不让用户看白屏 |
| 关键 CSS 内联 | 首屏样式不走外部请求 |
| 按需引入组件 | 不引入整个组件库，只引入用到的 |
| 减少首屏数据请求 | 首屏只请求必要的接口 |

```vue
<!-- ✅ 骨架屏 -->
<view v-if="loading" class="skeleton">
  <view class="skeleton-item" v-for="i in 5" :key="i" />
</view>
<view v-else>
  <!-- 真实内容 -->
</view>
```

## 8. 内存管理

```js
// ✅ 页面卸载时清理
onUnload() {
  // 清除定时器
  if (this.timer) clearInterval(this.timer)
  // 取消未完成的请求
  if (this.requestTask) this.requestTask.abort()
  // 解除事件监听
  uni.$off('productUpdate', this.onProductUpdate)
}
```

## 9. 性能检测

### 微信开发者工具

- Audits 面板：一键检查性能问题
- Performance 面板：录制分析运行时性能
- 代码依赖分析：检查包体积构成

### 关键指标

| 指标 | 目标 | 说明 |
|------|------|------|
| 首屏渲染 | < 1.5s | 从页面加载到首屏内容可见 |
| 交互响应 | < 100ms | 用户操作到界面反馈 |
| 包体积（主包） | < 1.5MB | 留余量给后续功能 |
| 图片总大小 | < 500KB | 单页面所有图片之和 |

## 10. 禁止事项

| 禁止 | 替代 |
|------|------|
| 一次性加载全部数据 | 分页 + 虚拟滚动 |
| `v-for` 不加 `:key` | 必须加唯一 key |
| 大图放本地 | 上 CDN，用 WebP |
| `onLoad` 中串行请求多个接口 | `Promise.all` 并行 |
| 搜索不防抖 | `debounce` 300ms |
| 页面卸载不清定时器/事件 | `onUnload` 中清理 |
| 引入整个组件库 | 按需引入 |
