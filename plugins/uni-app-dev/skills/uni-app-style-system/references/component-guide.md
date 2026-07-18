# 组件样式指南

## 按钮

```vue
<!-- 主操作（新增、提交） -->
<button type="primary" size="mini" @click="submit">新增</button>

<!-- 危险操作（删除） -->
<button type="warn" size="mini" :disabled="!selected.length" @click="del">批量删除</button>

<!-- 次要操作（搜索、取消） -->
<button type="default" size="mini" @click="search">搜索</button>

<!-- 链接式按钮 -->
<text class="link-btn" @click="navigateTo('./edit?id=' + item._id)">编辑</text>
```

## 表格

```vue
<uni-table :loading="loading" :border="true" stripe type="selection" @selection-change="onSelect">
  <uni-tr>
    <uni-th>名称</uni-th>
    <uni-th width="200px">操作</uni-th>
  </uni-tr>
  <uni-tr v-for="item in data" :key="item._id">
    <uni-td>{{ item.name }}</uni-td>
    <uni-td>
      <text class="link-btn" @click="navigateTo('./edit?id=' + item._id)">编辑</text>
      <text class="link-btn" @click="udb.remove(item._id)">删除</text>
    </uni-td>
  </uni-tr>
</uni-table>
```

## 表单

```vue
<uni-forms ref="form" :model="formData" :rules="rules" label-position="left" label-width="80px">
  <uni-forms-item label="名称" required name="name">
    <uni-easyinput v-model="formData.name" placeholder="请输入名称" />
  </uni-forms-item>
  <uni-forms-item label="状态" name="status">
    <uni-data-select v-model="formData.status" :localdata="statusOptions" />
  </uni-forms-item>
</uni-forms>
```

## 弹窗

```vue
<uni-popup ref="popup" type="center">
  <view class="modal">
    <view class="modal-header">标题</view>
    <view class="modal-content">内容</view>
    <view class="modal-footer">
      <button type="default" size="mini" @click="close">取消</button>
      <button type="primary" size="mini" @click="confirm">确定</button>
    </view>
  </view>
</uni-popup>
```

弹窗宽度：信息确认类 `400px`，表单类 `600px`。

## 分页

```vue
<view class="uni-pagination-box">
  <uni-pagination :current="pagination.current" :total="pagination.total"
    :page-size="pagination.size" @change="onPageChange" />
</view>
```

## 搜索栏

```vue
<view class="uni-group">
  <input class="uni-search" type="text" v-model="query" @confirm="search" placeholder="请输入关键词" />
  <button class="uni-button" type="default" size="mini" @click="search">搜索</button>
  <button class="uni-button" type="primary" size="mini" @click="navigateTo('./add')">新增</button>
</view>
```

## 面包屑

```vue
<uni-stat-breadcrumb />
```

放在页面头部 `#header` 插槽内。

## 常用布局 class

| Class | 用途 |
|-------|------|
| `uni-container` | 页面主容器 |
| `uni-header` | 页面头部区域 |
| `uni-group` | 按钮/搜索组 |
| `uni-button-group` | 按钮组 |
| `uni-pagination-box` | 分页容器 |
| `fix-top-window` | 适配顶部窗口的页面根容器 |
| `link-btn` | 链接式按钮（带主题色） |
| `modal` / `modal-header` / `modal-content` / `modal-footer` | 弹窗结构 |
