# 高端组件参考

每个组件提供**基础版**和**高端版**两种模板。基础版满足功能，高端版兼顾视觉品质。

## 一、卡片

### 基础版

```vue
<view class="card">
  <text class="card-title">标题</text>
  <text class="card-desc">描述信息</text>
</view>
```

```scss
.card {
  background: $uni-bg-color;
  border-radius: $uni-radius-base;
  padding: $uni-space-4;
  border: 1px solid $uni-border-color;
}
.card-title {
  font-size: $uni-font-size-lg;
  font-weight: 600;
  color: $uni-text-color;
}
.card-desc {
  font-size: $uni-font-size-sm;
  color: $uni-text-color-secondary;
  margin-top: $uni-space-1;
}
```

### 高端版

```vue
<view class="card-premium" hover-class="card-premium--hover">
  <view class="card-premium__header">
    <view class="card-premium__icon">
      <uni-icons type="wallet" size="20" color="#6366f1" />
    </view>
    <view class="card-premium__meta">
      <text class="card-premium__title">总收入</text>
      <text class="card-premium__subtitle">本月</text>
    </view>
    <uni-tag text="+12%" type="success" size="small" />
  </view>
  <text class="card-premium__value">¥ 128,450</text>
  <view class="card-premium__footer">
    <text class="card-premium__trend">较上月增长 12.5%</text>
  </view>
</view>
```

```scss
.card-premium {
  background: $uni-bg-color;
  border-radius: $uni-radius-lg;
  padding: $uni-space-5;
  border: 1px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
  transition: all $uni-duration-fast ease;

  &--hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    transform: translateY(-2px);
  }

  &__header {
    display: flex;
    align-items: center;
    margin-bottom: $uni-space-4;
  }

  &__icon {
    width: 72rpx;
    height: 72rpx;
    border-radius: $uni-radius-base;
    background: rgba(99, 102, 241, 0.08);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: $uni-space-3;
  }

  &__meta {
    flex: 1;
  }

  &__title {
    font-size: $uni-font-size-base;
    font-weight: 500;
    color: $uni-text-color;
  }

  &__subtitle {
    font-size: $uni-font-size-sm;
    color: $uni-text-color-grey;
    margin-top: 4rpx;
  }

  &__value {
    font-size: 48rpx;
    font-weight: 700;
    color: $uni-text-color;
    letter-spacing: -1rpx;
  }

  &__footer {
    margin-top: $uni-space-3;
    padding-top: $uni-space-3;
    border-top: 1px solid rgba(0, 0, 0, 0.04);
  }

  &__trend {
    font-size: $uni-font-size-sm;
    color: #059669;
  }
}
```

## 二、列表项

### 基础版

```vue
<view class="list-item" @click="goDetail">
  <text>{{ item.name }}</text>
  <text>{{ item.time }}</text>
</view>
```

### 高端版

```vue
<view class="list-item-pro" hover-class="list-item-pro--hover" @click="goDetail">
  <image class="list-item-pro__avatar" :src="item.avatar" mode="aspectFill" />
  <view class="list-item-pro__content">
    <view class="list-item-pro__row">
      <text class="list-item-pro__name">{{ item.name }}</text>
      <text class="list-item-pro__time">{{ item.time }}</text>
    </view>
    <text class="list-item-pro__desc">{{ item.desc }}</text>
    <view class="list-item-pro__tags" v-if="item.tags">
      <uni-tag
        v-for="tag in item.tags" :key="tag"
        :text="tag" size="small" type="primary"
        custom-style="margin-right: 8rpx;"
      />
    </view>
  </view>
  <uni-icons type="right" size="16" color="#c0c4cc" />
</view>
```

```scss
.list-item-pro {
  display: flex;
  align-items: center;
  padding: $uni-space-4 $uni-space-5;
  background: $uni-bg-color;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);
  transition: background $uni-duration-fast ease;

  &--hover {
    background: rgba(0, 0, 0, 0.02);
  }

  &__avatar {
    width: 96rpx;
    height: 96rpx;
    border-radius: $uni-radius-base;
    margin-right: $uni-space-3;
    flex-shrink: 0;
  }

  &__content {
    flex: 1;
    min-width: 0;
  }

  &__row {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  &__name {
    font-size: $uni-font-size-lg;
    font-weight: 500;
    color: $uni-text-color;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__time {
    font-size: $uni-font-size-sm;
    color: $uni-text-color-grey;
    flex-shrink: 0;
    margin-left: $uni-space-2;
  }

  &__desc {
    font-size: $uni-font-size-base;
    color: $uni-text-color-secondary;
    margin-top: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__tags {
    display: flex;
    margin-top: 12rpx;
    flex-wrap: wrap;
  }
}
```

## 三、数据统计

### 高端版

```vue
<view class="stats-grid">
  <view class="stats-item" v-for="item in stats" :key="item.label">
    <view class="stats-item__icon" :style="{ background: item.bg }">
      <uni-icons :type="item.icon" size="20" :color="item.color" />
    </view>
    <text class="stats-item__value">{{ item.value }}</text>
    <text class="stats-item__label">{{ item.label }}</text>
  </view>
</view>
```

```scss
.stats-grid {
  display: flex;
  flex-wrap: wrap;
  gap: $uni-space-3;
}

.stats-item {
  flex: 0 0 calc(50% - #{$uni-space-3} / 2);
  background: $uni-bg-color;
  border-radius: $uni-radius-lg;
  padding: $uni-space-4;
  border: 1px solid rgba(0, 0, 0, 0.04);

  &__icon {
    width: 72rpx;
    height: 72rpx;
    border-radius: $uni-radius-base;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: $uni-space-3;
  }

  &__value {
    font-size: 40rpx;
    font-weight: 700;
    color: $uni-text-color;
    display: block;
  }

  &__label {
    font-size: $uni-font-size-sm;
    color: $uni-text-color-grey;
    margin-top: 4rpx;
    display: block;
  }
}
```

## 四、操作按钮组

### 基础版

```vue
<view class="btn-group">
  <button type="primary" size="mini">新增</button>
  <button type="default" size="mini">导出</button>
</view>
```

### 高端版

```vue
<view class="action-bar">
  <view class="action-bar__left">
    <button class="btn-pro btn-pro--primary" @click="add">
      <uni-icons type="plusempty" size="16" color="#fff" />
      <text>新增</text>
    </button>
    <button class="btn-pro btn-pro--ghost" @click="exportData">
      <uni-icons type="download" size="16" color="#6366f1" />
      <text>导出</text>
    </button>
  </view>
  <view class="action-bar__right">
    <view class="action-bar__search">
      <uni-icons type="search" size="16" color="#c0c4cc" />
      <input
        class="action-bar__input"
        v-model="keyword"
        placeholder="搜索..."
        @confirm="search"
      />
    </view>
  </view>
</view>
```

```scss
.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: $uni-space-3 $uni-space-5;
  background: $uni-bg-color;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);

  &__left {
    display: flex;
    gap: $uni-space-2;
  }

  &__right {
    flex: 1;
    margin-left: $uni-space-4;
    display: flex;
    justify-content: flex-end;
  }

  &__search {
    display: flex;
    align-items: center;
    background: $uni-bg-color-secondary;
    border-radius: $uni-radius-full;
    padding: 0 $uni-space-3;
    height: 64rpx;
    width: 360rpx;
  }

  &__input {
    flex: 1;
    font-size: $uni-font-size-base;
    margin-left: $uni-space-2;
  }
}

.btn-pro {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  height: 64rpx;
  padding: 0 28rpx;
  border-radius: $uni-radius-base;
  font-size: $uni-font-size-base;
  font-weight: 500;
  transition: all $uni-duration-fast ease;

  &--primary {
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
    color: #fff;
    border: none;
    box-shadow: 0 2px 8px rgba(99, 102, 241, 0.25);

    &:active {
      transform: scale(0.97);
      box-shadow: 0 1px 4px rgba(99, 102, 241, 0.25);
    }
  }

  &--ghost {
    background: transparent;
    color: #6366f1;
    border: 1.5px solid rgba(99, 102, 241, 0.3);

    &:active {
      background: rgba(99, 102, 241, 0.06);
    }
  }
}
```

## 五、表单

### 高端版

```vue
<view class="form-section">
  <text class="form-section__title">基本信息</text>
  <view class="form-item">
    <text class="form-item__label">商品名称</text>
    <view class="form-item__input-wrap">
      <input
        class="form-item__input"
        v-model="formData.name"
        placeholder="请输入商品名称"
      />
    </view>
    <text class="form-item__error" v-if="errors.name">{{ errors.name }}</text>
  </view>
</view>
```

```scss
.form-section {
  background: $uni-bg-color;
  border-radius: $uni-radius-lg;
  padding: $uni-space-5;
  margin-bottom: $uni-space-4;

  &__title {
    font-size: $uni-font-size-lg;
    font-weight: 600;
    color: $uni-text-color;
    margin-bottom: $uni-space-4;
    padding-bottom: $uni-space-3;
    border-bottom: 1px solid rgba(0, 0, 0, 0.04);
  }
}

.form-item {
  margin-bottom: $uni-space-4;

  &__label {
    font-size: $uni-font-size-base;
    font-weight: 500;
    color: $uni-text-color;
    margin-bottom: $uni-space-2;
    display: block;
  }

  &__input-wrap {
    background: $uni-bg-color-secondary;
    border-radius: $uni-radius-base;
    border: 1.5px solid transparent;
    padding: 0 $uni-space-3;
    transition: all $uni-duration-fast ease;

    &:focus-within {
      border-color: #6366f1;
      background: $uni-bg-color;
      box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
    }
  }

  &__input {
    height: 80rpx;
    font-size: $uni-font-size-base;
  }

  &__error {
    font-size: $uni-font-size-sm;
    color: #e43d33;
    margin-top: 8rpx;
    display: block;
  }
}
```

## 六、导航标签栏

### 高端版

```vue
<scroll-view class="tab-bar" scroll-x>
  <view
    v-for="tab in tabs" :key="tab.id"
    class="tab-bar__item"
    :class="{ 'tab-bar__item--active': activeTab === tab.id }"
    @click="switchTab(tab.id)"
  >
    <text class="tab-bar__text">{{ tab.name }}</text>
    <view class="tab-bar__badge" v-if="tab.count">
      <text class="tab-bar__badge-text">{{ tab.count }}</text>
    </view>
  </view>
</scroll-view>
```

```scss
.tab-bar {
  display: flex;
  white-space: nowrap;
  background: $uni-bg-color;
  padding: 0 $uni-space-4;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);

  &__item {
    display: inline-flex;
    align-items: center;
    padding: $uni-space-3 $uni-space-4;
    position: relative;
    transition: color $uni-duration-fast ease;

    &--active {
      .tab-bar__text {
        color: #6366f1;
        font-weight: 600;
      }
      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: $uni-space-4;
        right: $uni-space-4;
        height: 4rpx;
        background: #6366f1;
        border-radius: 2rpx;
      }
    }
  }

  &__text {
    font-size: $uni-font-size-base;
    color: $uni-text-color-secondary;
    transition: all $uni-duration-fast ease;
  }

  &__badge {
    background: #e43d33;
    border-radius: $uni-radius-full;
    min-width: 32rpx;
    height: 32rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 8rpx;
    padding: 0 8rpx;
  }

  &__badge-text {
    font-size: 20rpx;
    color: #fff;
    font-weight: 600;
  }
}
```

## 七、使用原则

| 原则 | 说明 |
|------|------|
| **基础版用于内部工具** | 员工用的后台、调试页面 |
| **高端版用于面向用户** | C 端页面、客户演示、品牌展示 |
| **渐进升级** | 先用基础版跑通功能，再逐个升级为高端版 |
| **保持一致** | 同一页面不要混用基础版和高端版 |
