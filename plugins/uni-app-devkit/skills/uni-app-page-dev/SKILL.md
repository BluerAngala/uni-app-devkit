---
name: uni-app-page-dev
description: "Use when creating or modifying pages in uni-admin projects — list pages, add/edit forms, table layouts, search, pagination. Covers the full page development workflow from template to route registration."
tags: [uni-app, page, crud, admin, cross-platform]
---

# uni-app 页面开发规范

本 skill 覆盖 uni-admin 项目中管理页面的完整开发流程。新建或修改页面前，先读本文件。

## 页面开发全流程

```
1. 确定页面类型（列表/表单/详情）
2. 创建 .vue 文件
3. 注册路由（pages.json）
4. 添加菜单（opendb-admin-menus）
5. 配置权限（uni-id-permissions，如需要）
6. 添加 i18n 文本
```

## 核心约束

### 标签替换

| Web 标签 | uni-app 标签 |
|----------|-------------|
| `<div>` | `<view>` |
| `<span>` | `<text>` |
| `<img>` | `<image src="..." mode="aspectFit" />` |
| `<a href>` | `<navigator url>` |
| `<ul>/<li>` | `<view>` + `v-for` |

### API 替换

| Web API | uni-app API |
|---------|------------|
| `this.$router.push()` | `uni.navigateTo()` |
| `this.$route.query` | `onLoad(options)` |
| `document.getElementById()` | `uni.createSelectorQuery()` |
| `localStorage` | `uni.setStorageSync()` |
| `axios` / `fetch` | `uni.request()` 或 `$request` |

### 生命周期

页面用 `onLoad` / `onShow` / `onReady` / `onHide`，不用 `created` / `mounted`。
路由参数在 `onLoad(options)` 中获取。

### CSS

- 单位：`rpx`（响应式）或 `px`（固定），禁止 `rem` / `vh` / `vw`
- 颜色：引用 `uni.scss` 变量或 `getTheme()`，禁止硬编码
- 详见 `skill://uni-app-style-system`

## 列表页模板

```vue
<template>
  <fix-top-window>
    <template #header>
      <uni-stat-breadcrumb />
      <view class="uni-stat--btn-group">
        <input class="uni-search" type="text" v-model="query" @confirm="search"
          :placeholder="$t('common.placeholder.query')" />
        <button class="uni-button" type="default" size="mini" @click="search">
          {{ $t('common.button.search') }}
        </button>
        <button class="uni-button" type="primary" size="mini" @click="navigateTo('./add')">
          {{ $t('common.button.add') }}
        </button>
        <button class="uni-button" type="warn" size="mini"
          :disabled="!selectedIndexs.length" @click="delTable">
          {{ $t('common.button.batchDelete') }}
        </button>
      </view>
    </template>
    <unicloud-db ref="udb" v-slot:default="{ data, pagination, loading, error }"
      collection="opendb-xxx" :where="where" orderby="create_date desc"
      :getcount="true" :page-size="20" :page-current="options.pageCurrent"
      loadtime="manual" @load="onqueryload">
      <uni-table ref="table" :loading="loading"
        :emptyText="error.message || $t('common.empty')" border stripe type="selection"
        @selection-change="selectionChange">
        <uni-tr>
          <uni-th>名称</uni-th>
          <uni-th>状态</uni-th>
          <uni-th>创建时间</uni-th>
          <uni-th>操作</uni-th>
        </uni-tr>
        <uni-tr v-for="(item, index) in data" :key="index">
          <uni-td>{{ item.name }}</uni-td>
          <uni-td>
            <uni-tag :text="item.status === 1 ? '启用' : '禁用'"
              :type="item.status === 1 ? 'primary' : 'default'" />
          </uni-td>
          <uni-td>{{ item.create_date }}</uni-td>
          <uni-td>
            <text class="link-btn" @click="navigateTo('./edit?id=' + item._id)">
              {{ $t('common.button.edit') }}
            </text>
            <text class="link-btn" @click="udb.remove(item._id)">
              {{ $t('common.button.delete') }}
            </text>
          </uni-td>
        </uni-tr>
      </uni-table>
      <view class="uni-pagination-box">
        <uni-pagination :current="pagination.current" :total="pagination.total"
          :page-size="pagination.size" @change="onPageChange" />
      </view>
    </unicloud-db>
  </fix-top-window>
</template>

<script>
export default {
  data() {
    return {
      query: '',
      where: '',
      selectedIndexs: [],
      options: { pageSize: 20, pageCurrent: 1 },
    }
  },
  methods: {
    search() {
      const q = this.query.trim()
      // 使用 JQL 对象语法 + RegExp 防注入，不要拼接 where 字符串
      this.where = q ? { name: new RegExp(q, 'i') } : ''
      this.$nextTick(() => this.$refs.udb.loadData())
    },
    onqueryload(data) {},
    selectionChange(e) { this.selectedIndexs = e.detail.index },
    onPageChange(e) {
      this.options.pageCurrent = e.current
      this.$refs.udb.loadData()
    },
    delTable() {
      this.selectedIndexs.forEach(i => this.$refs.udb.remove(this.$refs.udb.data[i]._id))
      this.selectedIndexs = []
    },
  },
}
</script>
```

## 新增/编辑页模板

```vue
<template>
  <fix-top-window>
    <template #header>
      <uni-stat-breadcrumb />
    </template>
    <view class="uni-container">
      <uni-forms ref="form" :model="formData" :rules="rules"
        label-position="left" label-width="80px">
        <uni-forms-item label="名称" required name="name">
          <uni-easyinput v-model="formData.name" placeholder="请输入名称" />
        </uni-forms-item>
        <uni-forms-item label="状态" name="status">
          <uni-data-select v-model="formData.status"
            :localdata="[{value:1,text:'启用'},{value:0,text:'禁用'}]" />
        </uni-forms-item>
      </uni-forms>
      <view class="uni-button-group">
        <button type="primary" size="mini" @click="submit">
          {{ $t('common.button.submit') }}
        </button>
      </view>
    </view>
  </fix-top-window>
</template>
```

编辑页额外需要：
- `onLoad(options)` 接收 `id` 参数
- 加载已有数据填充表单
- 提交时调用 `update` 而非 `add`

## 权限检查

```js
// 在模板中
<button v-if="$hasPermission('system_user_add')">新增</button>

// 在 script 中
if (!this.$hasRole('admin')) { /* 限制操作 */ }
```

## 页面 Checklist

- [ ] `<fix-top-window>` 包裹
- [ ] 标签全部是 uni-app 标签（view/text/image/navigator）
- [ ] 跳转用 `uni.navigateTo`，不用 vue-router
- [ ] CSS 用 rpx，无 rem/vh/vw
- [ ] 颜色用变量，无硬编码
- [ ] 生命周期用 `onLoad`/`onShow`
- [ ] `pages.json` 中已注册路由
- [ ] `opendb-admin-menus` 中已添加菜单
- [ ] i18n 文本用 `$t()` 包裹
