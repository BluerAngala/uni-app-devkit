---
name: scaffold-cloud
description: "为 uni-admin 项目生成云对象/云函数骨架，包含 CRUD 方法和权限校验。"
---

# Scaffold Cloud

为 uni-admin 项目生成云对象或云函数骨架。用法：`/scaffold-cloud <名称> [选项]`

## 参数

- **名称**（必填）：如 `product-co`、`order-co`
- **类型**（可选）：`--type object`（默认）或 `--type function`
- **集合名**（可选）：`--collection opendb-xxx`，默认 `opendb-<名称去掉-co后缀>`

## 执行步骤

### 1. 收集信息

```
名称: <用户提供>
类型: 云对象 (推荐) / 传统云函数
集合名: opendb-<名称>
```

### 2. 生成云对象

创建 `uniCloud-alipay/cloudfunctions/<名称>/<名称>.obj.js`：

```js
const db = uniCloud.database()
const dbCmd = db.command
const uniID = require('uni-id-common')

module.exports = {
  _before() {
    // 权限校验
    const token = this.getUniIdToken()
    if (!token) throw new Error('未登录')
  },

  _after(error, result) {
    if (error) throw error
    return result
  },

  /**
   * 分页查询
   * @param {Object} { page, pageSize, where, orderby }
   */
  async list({ page = 1, pageSize = 20, where = '', orderby = 'create_date desc' } = {}) {
    let query = db.collection('<集合名>')
    if (where) query = query.where(where)
    const countRes = await query.count()
    const total = countRes.total
    const data = await query
      .skip((page - 1) * pageSize)
      .limit(pageSize)
      .orderBy(orderby.split(' ')[0], orderby.split(' ')[1] || 'desc')
      .get()
    return { data: data.data, total, page, pageSize }
  },

  /**
   * 查询单条
   */
  async get(id) {
    if (!id) return { code: 400, message: '缺少 id' }
    const res = await db.collection('<集合名>').doc(id).get()
    return res.data[0] || null
  },

  /**
   * 新增
   */
  async add(data) {
    if (!data || typeof data !== 'object') {
      return { code: 400, message: '参数错误' }
    }
    data.create_date = Date.now()
    data.update_date = Date.now()
    const res = await db.collection('<集合名>').add(data)
    return { id: res.id }
  },

  /**
   * 更新
   */
  async update(id, data) {
    if (!id) return { code: 400, message: '缺少 id' }
    delete data._id
    delete data.create_date  // 不允许修改创建时间
    data.update_date = Date.now()
    await db.collection('<集合名>').doc(id).update(data)
    return { updated: true }
  },

  /**
   * 删除
   */
  async remove(id) {
    if (!id) return { code: 400, message: '缺少 id' }
    await db.collection('<集合名>').doc(id).remove()
    return { removed: true }
  },

  /**
   * 批量删除
   */
  async batchRemove(ids) {
    if (!Array.isArray(ids) || !ids.length) {
      return { code: 400, message: '缺少 ids' }
    }
    const dbCmd = db.command
    await db.collection('<集合名>').where({
      _id: dbCmd.in(ids)
    }).remove()
    return { removed: ids.length }
  },
}
```

### 3. 生成传统云函数（如指定 --type function）

创建 `uniCloud-alipay/cloudfunctions/<名称>/index.js`：

```js
const db = uniCloud.database()

exports.main = async (event, context) => {
  const { action, params } = event

  switch (action) {
    case 'list': {
      const { page = 1, pageSize = 20, where = '' } = params || {}
      let query = db.collection('<集合名>')
      if (where) query = query.where(where)
      const res = await query.skip((page - 1) * pageSize)
        .limit(pageSize).orderBy('create_date', 'desc').get()
      return res.data
    }
    case 'add':
      return await db.collection('<集合名>').add(params)
    case 'update':
      return await db.collection('<集合名>').doc(params.id).update(params.data)
    case 'remove':
      return await db.collection('<集合名>').doc(params.id).remove()
    default:
      return { code: 404, msg: '未知操作' }
  }
}
```

### 4. 生成数据库 Schema（如不存在）

创建 `uniCloud-alipay/database/<集合名>/` 下 3 个文件：

**<集合名>.schema.json**：
```json
{
  "bsonType": "object",
  "required": ["name"],
  "permission": {
    "read": true,
    "create": "auth.uid != null",
    "update": "auth.uid != null",
    "delete": "auth.role.includes('admin')"
  },
  "properties": {
    "_id": { "description": "ID" },
    "name": { "bsonType": "string", "description": "名称" },
    "status": { "bsonType": "int", "description": "状态：1启用 0禁用", "defaultValue": 1 },
    "create_date": { "bsonType": "timestamp", "description": "创建时间" },
    "update_date": { "bsonType": "timestamp", "description": "更新时间" }
  }
}
```

**<集合名>.index.json**：
```json
[
  { "IndexName": "name_index", "MgoKeySchema": { "name": 1 } }
]
```

**<集合名>.init_data.json**：
```json
[]
```

### 5. 输出清单

```
已生成:
  uniCloud-alipay/cloudfunctions/<名称>/<名称>.obj.js   — 云对象（含 CRUD + 批量删除）
  uniCloud-alipay/database/<集合名>/                     — Schema + 索引 + 初始数据

待办:
  - 按实际业务补充字段（schema.json + 云对象中的校验逻辑）
  - 如需定时触发，在 uniCloud 控制台配置
  - 如需自定义权限，修改 schema.json 的 permission
  - 前端页面用 /scaffold-page 生成
```
