---
name: uni-app-cloud-dev
description: "Use when creating or modifying cloud functions, cloud objects, database schemas, or JQL queries in uni-app projects. Covers the full cloud development workflow from schema to deployment."
tags: [uni-app, cloud, unicloud, jql, serverless]
---

# uni-app 云开发规范

本 skill 覆盖 uniCloud 云函数、云对象、数据库 Schema 的开发流程。

## 云对象 vs 云函数

| | 云对象（`.obj.js`） | 传统云函数（`index.js`） |
|---|---|---|
| 调用方式 | `uniCloud.importObject('name')` | `uniCloud.callFunction({ name })` |
| 代码结构 | 对象方法，天然分 action | switch/case 分发 |
| 生命周期 | `_before()` / `_after()` 钩子 | 无内置钩子 |
| 推荐 | **新功能用这个** | 历史代码继续用 |

## 云对象开发

### 文件结构

```
uniCloud-alipay/cloudfunctions/
└── xxx-co/
    └── xxx-co.obj.js          # 文件名 = 云对象名.obj.js
```

### 模板

```js
const db = uniCloud.database()
const dbCmd = db.command
const uniID = require('uni-id-common')

module.exports = {
  _before() {
    // ⚠️ uni-id-common 必须先 createInstance
    this.uniIDIns = uniID.createInstance({ context: this })
    const token = this.getUniIdToken()
    if (!token) throw new Error('未登录')
  },

  _after(error, result) {
    if (error) throw error
    return result
  },

  async list({ page = 1, pageSize = 20, where = '' } = {}) {
    let query = db.collection('opendb-xxx')
    if (where) query = query.where(where)
    const res = await query
      .skip((page - 1) * pageSize)
      .limit(pageSize)
      .orderBy('create_date', 'desc')
      .get()
    return res.data
  },

  async add(data) {
    // 参数校验
    if (!data.name || typeof data.name !== 'string') {
      return { code: 400, message: '参数错误：name 必填' }
    }
    data.create_date = Date.now()
    return await db.collection('opendb-xxx').add(data)
  },

  async update(id, data) {
    if (!id) return { code: 400, message: '缺少 id' }
    delete data._id  // 禁止修改 _id
    return await db.collection('opendb-xxx').doc(id).update(data)
  },

  async remove(id) {
    if (!id) return { code: 400, message: '缺少 id' }
    return await db.collection('opendb-xxx').doc(id).remove()
  },
}
```

### 前端调用

```js
const xxxCo = uniCloud.importObject('xxx-co')
const list = await xxxCo.list({ page: 1, pageSize: 20 })
await xxxCo.add({ name: 'test', status: 1 })
```

## 数据库 Schema

每个数据集合 3 个文件：

```
uniCloud-alipay/database/opendb-xxx/
├── opendb-xxx.schema.json      # 字段定义 + 权限规则
├── opendb-xxx.index.json       # 索引
└── opendb-xxx.init_data.json   # 初始数据（通常 []）
```

### Schema 权限规则

```json
{
  "permission": {
    "read": true,
    "create": "auth.uid != null",
    "update": "auth.uid == doc.user_id || auth.role.indexOf('admin') > -1",
    "delete": "auth.role.indexOf('admin') > -1"
  }
}
```

### 权限写法要点

- `read: true` — 公开读（列表页通常需要）
- `create/update/delete` — 必须限制，不能用 `true`
- `auth.uid` — 当前登录用户 ID
- `auth.role` — 当前用户角色数组
- `doc.field` — 当前记录的字段

## 数据库操作速查

```js
const db = uniCloud.database()
const dbCmd = db.command

// 查询
await db.collection('xxx').where({ status: 1 }).get()
await db.collection('xxx').doc('id').get()

// 新增
await db.collection('xxx').add({ name: 'test' })

// 更新
await db.collection('xxx').doc('id').update({ name: 'new' })

// 删除
await db.collection('xxx').doc('id').remove()

// 条件查询
.where({ age: dbCmd.gt(18) })           // age > 18
.where({ status: dbCmd.in([0, 1]) })    // status in [0, 1]
.where({ name: dbCmd.like('%张%') })    // 模糊查询
.where({ create_date: dbCmd.gt(start).and(dbCmd.lt(end)) })  // 范围
```

## 联表查询（JQL）

在 `<unicloud-db>` 的 `field` 中用外键关联：

```vue
<!-- 查询用户并关联角色名 -->
<unicloud-db collection="uni-id-users" field="nickname,role_id{name}" />
```

## 依赖管理

```js
// 公共模块（cloudfunctions/common/）
const uniId = require('uni-id-common')

// uni_modules
const uniPay = require('uni-pay')
```

## 安全规则

详见 `rules/uni-cloud-security.md`，核心要点：

1. **入口必须校验身份** — `uniID.createInstance({ context: this })` + `uniIDIns.checkToken(token)`
2. **写操作必须校验权限** — 角色或所有权检查
3. **外部输入必须校验类型** — 禁止直接拼入查询条件
4. **敏感数据不入日志** — token、密码等
5. **返回数据脱敏** — 不返回密码哈希

## 云开发 Checklist

- [ ] 云对象文件名 `.obj.js`，传统云函数 `index.js`
- [ ] `_before()` 中做了权限校验
- [ ] 参数校验（类型、范围、必填）
- [ ] Schema 权限规则已配置（特别是 delete 限制 admin）
- [ ] 错误信息对前端友好
- [ ] 如需定时触发，在 uniCloud 控制台配置
- [ ] 公共逻辑放 `cloudfunctions/common/` 复用
