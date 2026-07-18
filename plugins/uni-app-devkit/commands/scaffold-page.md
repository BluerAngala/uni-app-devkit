---
name: scaffold-page
description: "为 uni-admin 项目生成管理页面骨架（list/add/edit），自动注册路由和菜单。"
---

# Scaffold Page

为 uni-admin 项目生成标准管理页面。用法：`/scaffold-page <模块名> [选项]`

## 参数

- **模块名**（必填）：如 `user`、`product`、`order`
- **字段列表**（可选）：`--fields name,status,created_at`
- **集合名**（可选）：`--collection opendb-xxx`，默认 `opendb-<模块名>`

## 执行步骤

### 1. 收集信息

如果用户没有提供完整参数，询问：

```
模块名: <用户提供或询问>
集合名: opendb-<模块名>  (确认或修改)
字段列表: name,status,created_at  (确认或修改)
```

### 2. 生成 list.vue

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
      collection="<集合名>" :where="where" orderby="create_date desc"
      :getcount="true" :page-size="20" :page-current="options.pageCurrent"
      loadtime="manual" @load="onqueryload">
      <uni-table ref="table" :loading="loading"
        :emptyText="error.message || $t('common.empty')" border stripe type="selection"
        @selection-change="selectionChange">
        <uni-tr>
          <!-- 按字段生成表头 -->
          <uni-th>名称</uni-th>
          <uni-th>操作</uni-th>
        </uni-tr>
        <uni-tr v-for="item in data" :key="item._id">
          <!-- 按字段生成列 -->
          <uni-td>{{ item.name }}</uni-td>
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
      options: {
        pageSize: 20,
        pageCurrent: 1,
      },
    }
  },
  methods: {
    search() {
      const query = this.query.trim()
      if (query) {
        // 使用 JQL 对象语法 + RegExp 防注入，不要拼接 where 字符串
        // ⚠️ db.RegExp 是服务端 API，客户端 unicloud-db 的 :where 用 new RegExp()
        this.where = {
          name: new RegExp(query, 'i'),
        }
      } else {
        this.where = ''
      }
      this.$nextTick(() => {
        this.$refs.udb.loadData()
      })
    },
    onqueryload(data) {},
    selectionChange(e) {
      this.selectedIndexs = e.detail.index
    },
    onPageChange(e) {
      this.options.pageCurrent = e.current
      this.$refs.udb.loadData()
    },
    delTable() {
      this.selectedIndexs.forEach((index) => {
        this.$refs.udb.remove(this.$refs.udb.data[index]._id)
      })
      this.selectedIndexs = []
    },
  },
}
</script>
```

### 3. 生成 add.vue

```vue
<template>
  <fix-top-window>
    <template #header>
      <uni-stat-breadcrumb />
    </template>
    <view class="uni-container">
      <uni-forms ref="form" :model="formData" :rules="rules"
        label-position="left" label-width="80px">
        <!-- 按字段生成表单项 -->
        <uni-forms-item label="名称" required name="name">
          <uni-easyinput v-model="formData.name" placeholder="请输入名称" />
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

<script>
const db = uniCloud.database()
const dbCmd = db.command

export default {
  data() {
    return {
      formData: {
        name: '',
      },
      rules: {
        name: { rules: [{ required: true, errorMessage: '请输入名称' }] },
      },
    }
  },
  methods: {
    submit() {
      if (this.submitting) return  // 防重复提交
      this.$refs.form.validate().then((res) => {
        this.submitting = true
        db.collection('<集合名>').add(this.formData).then(() => {
          uni.showToast({ title: '新增成功' })
          setTimeout(() => uni.navigateBack(), 500)
        }).catch((e) => {
          uni.showToast({ title: e.message || '新增失败', icon: 'none' })
        }).finally(() => {
          this.submitting = false
        })
      })
    },
  },
}
</script>
```

### 4. 生成 edit.vue

基于 add.vue，增加 `onLoad(options)` 加载已有数据：

```vue
<script>
export default {
  onLoad(options) {
    if (options.id) {
      this.id = options.id
      this.loadData()
    }
  },
  data() {
    return {
      id: '',
      formData: { name: '' },
      // ...rules 同 add.vue
    }
  },
  methods: {
    loadData() {
      db.collection('<集合名>').doc(this.id).get().then((res) => {
        if (res.result.data.length) {
          this.formData = res.result.data[0]
        }
      })
    },
    submit() {
      this.$refs.form.validate().then((res) => {
        db.collection('<集合名>').doc(this.id).update(this.formData).then(() => {
          uni.showToast({ title: '修改成功' })
          setTimeout(() => uni.navigateBack(), 500)
        })
      })
    },
  },
}
</script>
```

### 5. 注册路由

在 `pages.json` 中添加：

```json
{
  "path": "pages/<模块名>/list",
  "style": { "navigationBarTitleText": "<模块名>列表" }
},
{
  "path": "pages/<模块名>/add",
  "style": { "navigationBarTitleText": "新增<模块名>" }
},
{
  "path": "pages/<模块名>/edit",
  "style": { "navigationBarTitleText": "编辑<模块名>" }
}
```

### 6. 输出清单

完成后告知用户：

```
已生成:
  pages/<模块名>/list.vue   — 列表页
  pages/<模块名>/add.vue    — 新增页
  pages/<模块名>/edit.vue   — 编辑页

已修改:
  pages.json                — 注册路由

待办:
  - 在 opendb-admin-menus 中添加菜单记录
  - 按实际字段修改表单和表格列
  - 添加 i18n 文本到 i18n/*.json
```
