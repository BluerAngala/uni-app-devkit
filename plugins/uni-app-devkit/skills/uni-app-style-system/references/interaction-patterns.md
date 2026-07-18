# 交互模式规范

本文件定义 uni-app 项目中常见的交互模式。遇到"这个功能怎么做"时先查本文件。

## 一、导航模式

### 1.1 侧边栏导航（管理系统 H5 端）

**⚠️ 侧边栏布局仅适用于 H5 端管理后台。** 小程序/App 端使用 TabBar + 页面内导航。

```
桌面：侧边栏常驻左侧
平板：折叠为图标模式
手机：隐藏，汉堡菜单唤出
```

```vue
<template>
  <view class="admin-layout">
    <!-- 侧边栏 -->
    <view class="sidebar" :class="{ 'sidebar--collapsed': sidebarCollapsed }">
      <view class="sidebar-logo">
        <image src="/static/logo.png" mode="aspectFit" class="sidebar-logo__img" />
        <text v-if="!sidebarCollapsed" class="sidebar-logo__text">管理系统</text>
      </view>
      <scroll-view scroll-y class="sidebar-menu">
        <view
          v-for="item in menuList" :key="item.path"
          class="menu-item"
          :class="{ 'menu-item--active': currentPath === item.path }"
          @click="navigateTo(item.path)"
        >
          <uni-icons :type="item.icon" size="20" />
          <text v-if="!sidebarCollapsed" class="menu-item__text">{{ item.title }}</text>
          <view v-if="item.badge && !sidebarCollapsed" class="menu-item__badge">
            <text>{{ item.badge }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 主内容区 -->
    <view class="admin-main">
      <view class="admin-header">
        <uni-icons type="menu" size="24" @click="toggleSidebar" />
        <view class="header-right">
          <uni-icons type="notification" size="22" />
          <image :src="userInfo.avatar" class="header-avatar" />
        </view>
      </view>
      <view class="admin-content">
        <slot />
      </view>
    </view>
  </view>
</template>
```

### 1.2 Tab 导航（移动端）

```vue
<template>
  <view class="tab-nav">
    <view
      v-for="tab in tabs" :key="tab.id"
      class="tab-item"
      :class="{ 'tab-item--active': activeTab === tab.id }"
      @click="switchTab(tab.id)"
    >
      <view class="tab-item__icon-wrap">
        <uni-icons :type="activeTab === tab.id ? tab.iconActive : tab.icon" size="24" />
        <view v-if="tab.badge" class="tab-item__badge">
          <text>{{ tab.badge > 99 ? '99+' : tab.badge }}</text>
        </view>
      </view>
      <text class="tab-item__label">{{ tab.label }}</text>
    </view>
  </view>
</template>

<style>
.tab-nav {
  display: flex;
  background: $uni-bg-color;
  border-top: 1px solid $uni-border-color-light;
  padding-bottom: env(safe-area-inset-bottom);
}
.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8rpx 0 4rpx;
  &--active .tab-item__label { color: $primary-color; }
}
.tab-item__icon-wrap { position: relative; }
.tab-item__badge {
  position: absolute;
  top: -8rpx;
  right: -16rpx;
  background: #e43d33;
  border-radius: 999rpx;
  min-width: 32rpx;
  height: 32rpx;
  padding: 0 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20rpx;
  color: #fff;
}
.tab-item__label {
  font-size: 22rpx;
  color: $uni-text-color-grey;
  margin-top: 4rpx;
}
</style>
```

### 1.3 面包屑导航

```vue
<view class="breadcrumb">
  <text class="breadcrumb-item" @click="navigateTo('/pages/index/index')">首页</text>
  <text class="breadcrumb-sep">/</text>
  <text class="breadcrumb-item" @click="navigateTo('/pages/product/list')">商品管理</text>
  <text class="breadcrumb-sep">/</text>
  <text class="breadcrumb-item breadcrumb-item--current">商品详情</text>
</view>
```

### 1.4 返回行为

```js
// 统一的返回处理
onBackPress() {
  if (this.hasUnsavedChanges) {
    uni.showModal({
      title: '提示',
      content: '有未保存的修改，确定离开吗？',
      success: (res) => {
        if (res.confirm) uni.navigateBack()
      }
    })
    return true  // 阻止默认返回
  }
}
```

## 二、搜索与筛选模式

### 2.1 搜索栏

```vue
<view class="search-bar">
  <view class="search-input">
    <uni-icons type="search" size="18" color="#c0c4cc" />
    <input
      v-model="keyword"
      placeholder="搜索商品名称、编号..."
      confirm-type="search"
      @confirm="doSearch"
      @input="onInput"
    />
    <uni-icons
      v-if="keyword"
      type="clear" size="18" color="#c0c4cc"
      @click="clearSearch"
    />
  </view>
  <text class="search-btn" @click="doSearch">搜索</text>
</view>
```

```scss
.search-bar {
  display: flex;
  align-items: center;
  gap: $uni-space-3;
  padding: $uni-space-3 $uni-space-4;
}
.search-input {
  flex: 1;
  display: flex;
  align-items: center;
  gap: $uni-space-2;
  background: $uni-bg-color-secondary;
  border-radius: $uni-radius-full;
  padding: 0 $uni-space-3;
  height: 72rpx;
  input { flex: 1; font-size: $uni-font-size-base; }
}
.search-btn {
  font-size: $uni-font-size-base;
  color: $primary-color;
  font-weight: 500;
}
```

### 2.2 筛选器

```vue
<view class="filter-bar">
  <!-- 筛选标签 -->
  <scroll-view scroll-x class="filter-tags">
    <view
      v-for="tag in filterOptions" :key="tag.value"
      class="filter-tag"
      :class="{ 'filter-tag--active': activeFilters.includes(tag.value) }"
      @click="toggleFilter(tag.value)"
    >
      <text>{{ tag.label }}</text>
      <uni-icons v-if="activeFilters.includes(tag.value)" type="clear" size="14" />
    </view>
  </scroll-view>

  <!-- 高级筛选按钮 -->
  <view class="filter-advanced" @click="showAdvancedFilter">
    <uni-icons type="filter" size="16" />
    <text>筛选</text>
    <view v-if="advancedFilterCount" class="filter-advanced__badge">
      <text>{{ advancedFilterCount }}</text>
    </view>
  </view>
</view>
```

### 2.3 搜索防抖

```js
// 搜索输入防抖 300ms
import { debounce } from 'lodash-es'

export default {
  created() {
    this.debouncedSearch = debounce(this.doSearch, 300)
  },
  methods: {
    onInput() {
      this.debouncedSearch()
    },
    doSearch() {
      const q = this.keyword.trim()
      this.where = q ? { name: new RegExp(q, 'i') } : ''
      this.$nextTick(() => this.$refs.udb.loadData())
    },
    clearSearch() {
      this.keyword = ''
      this.where = ''
      this.$nextTick(() => this.$refs.udb.loadData())
    }
  }
}
```

## 三、表单模式

### 3.1 基础表单

```vue
<view class="form-page">
  <view class="form-section">
    <text class="form-section__title">基本信息</text>
    <view class="form-item">
      <text class="form-label">名称 <text class="form-required">*</text></text>
      <input v-model="form.name" placeholder="请输入名称" />
      <text v-if="errors.name" class="form-error">{{ errors.name }}</text>
    </view>
  </view>

  <view class="form-section">
    <text class="form-section__title">详细信息</text>
    <view class="form-item">
      <text class="form-label">描述</text>
      <textarea v-model="form.desc" placeholder="请输入描述" />
    </view>
  </view>

  <!-- 底部操作栏 -->
  <view class="form-actions">
    <button class="btn-ghost" @click="cancel">取消</button>
    <button class="btn-primary" :loading="submitting" @click="submit">提交</button>
  </view>
</view>
```

```scss
.form-section {
  background: $uni-bg-color;
  border-radius: $uni-radius-lg;
  padding: $uni-space-5;
  margin-bottom: $uni-space-4;
}
.form-section__title {
  font-size: $uni-font-size-lg;
  font-weight: 600;
  margin-bottom: $uni-space-4;
  padding-bottom: $uni-space-3;
  border-bottom: 1px solid rgba(0,0,0,0.04);
}
.form-item {
  margin-bottom: $uni-space-4;
}
.form-label {
  font-size: $uni-font-size-base;
  font-weight: 500;
  margin-bottom: $uni-space-1;
  display: block;
}
.form-required { color: #e43d33; }
.form-error {
  font-size: $uni-font-size-sm;
  color: #e43d33;
  margin-top: 8rpx;
  display: block;
}
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: $uni-space-3;
  padding: $uni-space-4;
  background: $uni-bg-color;
  border-top: 1px solid $uni-border-color-light;
  position: sticky;
  bottom: 0;
}
```

### 3.2 表单校验

```js
methods: {
  validate() {
    const errors = {}
    if (!this.form.name?.trim()) {
      errors.name = '请输入名称'
    } else if (this.form.name.length > 50) {
      errors.name = '名称不能超过50个字符'
    }
    if (this.form.price && isNaN(Number(this.form.price))) {
      errors.price = '价格必须为数字'
    }
    this.errors = errors
    return Object.keys(errors).length === 0
  },

  async submit() {
    if (!this.validate()) return
    if (this.submitting) return
    this.submitting = true
    try {
      await productCo.add(this.form)
      uni.showToast({ title: '新增成功' })
      setTimeout(() => uni.navigateBack(), 500)
    } catch (e) {
      uni.showToast({ title: e.message || '提交失败', icon: 'none' })
    } finally {
      this.submitting = false
    }
  }
}
```

### 3.3 防重复提交

```js
async submit() {
  if (this.submitting) return  // 关键：防止重复点击
  this.submitting = true
  try {
    // ... 提交逻辑
  } finally {
    this.submitting = false
  }
}
```

## 四、列表与分页模式

### 4.1 分页加载

```js
export default {
  data() {
    return {
      list: [],
      page: 1,
      pageSize: 20,
      total: 0,
      loading: false,
      hasMore: true,
    }
  },
  onShow() {
    this.loadData(1)
  },
  onReachBottom() {
    if (this.hasMore && !this.loading) {
      this.loadData(this.page + 1)
    }
  },
  onPullDownRefresh() {
    this.loadData(1).then(() => uni.stopPullDownRefresh())
  },
  methods: {
    async loadData(page) {
      this.loading = true
      try {
        const res = await productCo.list({ page, pageSize: this.pageSize })
        this.list = page === 1 ? res.data : [...this.list, ...res.data]
        this.total = res.total
        this.page = page
        this.hasMore = this.list.length < res.total
      } catch (e) {
        uni.showToast({ title: '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    }
  }
}
```

### 4.2 下拉刷新 + 上拉加载组合

```vue
<template>
  <view class="list-page">
    <search-bar @search="onSearch" />

    <view v-if="loading && !list.length" class="skeleton-list">
      <view v-for="i in 5" :key="i" class="skeleton-item" />
    </view>

    <view v-else-if="!list.length" class="empty-state">
      <image src="/static/empty.png" class="empty-icon" />
      <text class="empty-title">暂无数据</text>
    </view>

    <view v-else>
      <view v-for="item in list" :key="item._id" class="list-item">
        <!-- 列表内容 -->
      </view>
      <view v-if="loading" class="loading-more">
        <text>加载中...</text>
      </view>
      <view v-if="!hasMore && list.length" class="no-more">
        <text>没有更多了</text>
      </view>
    </view>
  </view>
</template>
```

## 五、反馈模式

### 5.1 确认操作

```js
// 删除确认
confirmDelete(item) {
  uni.showModal({
    title: '确认删除',
    content: `确定删除「${item.name}」吗？此操作不可恢复。`,
    confirmColor: '#e43d33',
    success: async (res) => {
      if (res.confirm) {
        await productCo.remove(item._id)
        uni.showToast({ title: '删除成功' })
        this.loadData(1)
      }
    }
  })
}

// 批量删除确认
confirmBatchDelete() {
  uni.showModal({
    title: '确认批量删除',
    content: `确定删除选中的 ${this.selectedIds.length} 条记录吗？`,
    confirmColor: '#e43d33',
    success: async (res) => {
      if (res.confirm) {
        await productCo.batchRemove(this.selectedIds)
        uni.showToast({ title: '删除成功' })
        this.selectedIds = []
        this.loadData(1)
      }
    }
  })
}
```

### 5.2 成功反馈

```js
// 轻量反馈（Toast）
uni.showToast({ title: '保存成功' })

// 带跳转的反馈
uni.showToast({ title: '新增成功' })
setTimeout(() => uni.navigateBack(), 500)

// 重量反馈（确认后跳转）
uni.showModal({
  title: '提交成功',
  content: '您的申请已提交，预计1-3个工作日内审核。',
  showCancel: false,
  success: () => uni.navigateBack()
})
```

### 5.3 错误反馈

```js
// 网络错误
catch (e) {
  if (e.message.includes('timeout')) {
    uni.showToast({ title: '请求超时，请重试', icon: 'none' })
  } else if (e.message.includes('network')) {
    uni.showToast({ title: '网络异常，请检查网络', icon: 'none' })
  } else {
    uni.showToast({ title: e.message || '操作失败', icon: 'none' })
  }
}
```

### 5.4 骨架屏

```vue
<template>
  <view v-if="loading" class="skeleton">
    <view class="skeleton-header">
      <view class="skeleton-avatar skeleton-shimmer" />
      <view class="skeleton-lines">
        <view class="skeleton-line skeleton-line--long skeleton-shimmer" />
        <view class="skeleton-line skeleton-line--short skeleton-shimmer" />
      </view>
    </view>
    <view class="skeleton-body">
      <view class="skeleton-line skeleton-shimmer" />
      <view class="skeleton-line skeleton-shimmer" />
      <view class="skeleton-line skeleton-line--short skeleton-shimmer" />
    </view>
  </view>
  <view v-else>
    <slot />
  </view>
</template>

<style>
.skeleton-shimmer {
  background: linear-gradient(90deg, #f0f0f0 25%, #e8e8e8 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>
```

### 5.5 空状态

```vue
<view class="empty-state">
  <image src="/static/empty.png" mode="aspectFit" class="empty-icon" />
  <text class="empty-title">{{ title || '暂无数据' }}</text>
  <text class="empty-desc">{{ desc || '点击下方按钮添加' }}</text>
  <button v-if="actionText" class="btn-primary" @click="$emit('action')">
    {{ actionText }}
  </button>
</view>
```

## 六、批量操作模式

```vue
<view class="batch-bar" v-if="selectedIds.length">
  <view class="batch-info">
    <text>已选 {{ selectedIds.length }} 项</text>
    <text class="batch-select-all" @click="selectAll">全选</text>
    <text class="batch-clear" @click="clearSelection">取消</text>
  </view>
  <view class="batch-actions">
    <button class="btn-ghost btn-sm" @click="batchExport">导出</button>
    <button class="btn-danger btn-sm" @click="confirmBatchDelete">删除</button>
  </view>
</view>
```

## 七、选择器模式

### 7.1 底部弹起选择

```vue
<uni-popup ref="picker" type="bottom">
  <view class="picker-sheet">
    <view class="picker-header">
      <text @click="$refs.picker.close()">取消</text>
      <text class="picker-title">选择分类</text>
      <text class="picker-confirm" @click="confirmPick">确定</text>
    </view>
    <scroll-view scroll-y class="picker-body">
      <view
        v-for="item in options" :key="item.value"
        class="picker-item"
        :class="{ 'picker-item--active': selected === item.value }"
        @click="selected = item.value"
      >
        <text>{{ item.label }}</text>
        <uni-icons v-if="selected === item.value" type="checkmarkempty" color="#6366f1" />
      </view>
    </scroll-view>
  </view>
</uni-popup>
```

### 7.2 日期范围选择

```vue
<view class="date-range">
  <view class="date-range__item" @click="pickStartDate">
    <text class="date-range__label">开始日期</text>
    <text class="date-range__value">{{ startDate || '请选择' }}</text>
  </view>
  <text class="date-range__sep">至</text>
  <view class="date-range__item" @click="pickEndDate">
    <text class="date-range__label">结束日期</text>
    <text class="date-range__value">{{ endDate || '请选择' }}</text>
  </view>
</view>
```

## 八、模式选择指南

| 场景 | 推荐模式 | 说明 |
|------|---------|------|
| 全局导航 | 侧边栏（桌面）/ TabBar（移动端） | 管理系统用侧边栏 |
| 页面内导航 | 面包屑 + 返回按钮 | 层级 > 2 时显示面包屑 |
| 数据检索 | 搜索栏 + 筛选标签 + 高级筛选 | 3 个条件以内用标签，更多用高级筛选 |
| 数据录入 | 分组表单 + 底部操作栏 | 字段 > 6 个分组 |
| 数据展示 | 表格（桌面）/ 卡片列表（移动端） | 列 > 5 用表格 |
| 危险操作 | Modal 确认 + 红色确认按钮 | 删除/批量操作必须确认 |
| 加载状态 | 骨架屏（首屏）/ 底部 loading（翻页） | 首屏用骨架屏，翻页用文字 |
| 空状态 | 插图 + 引导文案 + 操作按钮 | 不要只显示"暂无数据" |
| 错误状态 | 图标 + 描述 + 重试按钮 | 区分网络错误/业务错误 |
