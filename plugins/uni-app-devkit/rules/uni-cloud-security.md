---
name: uni-cloud-security
description: "uniCloud 安全规则。适用于云函数、云对象、JQL 查询的编写和审查。"
alwaysApply: true
---

# uniCloud 安全规则

## 1. 权限校验

- 云函数/云对象入口必须校验调用者身份
- 写操作（增删改）必须校验权限，读操作按需
- 使用 `uniID.createInstance()` 创建实例后调用 `checkToken()` 验证登录态
- 管理员操作用 `uid` 对比或角色检查

```js
// 云对象示例
const uniID = require('uni-id-common')

async delete(id) {
  // ⚠️ uni-id-common 必须先 createInstance
  const uniIDIns = uniID.createInstance({ context: this })
  const token = this.getUniIdToken()
  const { uid, role } = await uniIDIns.checkToken(token)
  if (role.indexOf('admin') === -1) {
    return { code: 403, message: '无权限' }
  }
  // 执行删除
}
```

## 2. 数据校验

- 所有外部输入必须校验类型和范围
- 禁止直接将前端参数拼入 JQL where 条件
- 使用 `validator` 或手动校验

```js
// ❌ 危险
const { where } = this.getParams()
db.collection('user').where(where).get()

// ✅ 安全
const [name, status] = this.getParams()
if (typeof name !== 'string' || name.length > 50) {
  return { code: 400, message: '参数错误' }
}
```

## 3. JQL 查询

- 客户端 JQL 受 schema 权限规则约束，不需要额外校验
- 服务端 JQL（云函数内）必须手动校验
- 禁止在客户端 JQL 中使用 `getTemp()` 联表获取敏感数据绕过权限

## 4. 敏感数据

- Token、密码等禁止写入日志
- 返回给前端的数据脱敏（不返回密码哈希、内部 ID 等）
- 使用 `field` 字段限制返回内容

## 5. 频率限制

- 对外暴露的接口必须做频率限制
- 按用户 ID + 接口名限流，防止单用户刷接口
- 超限返回 `{ code: 429, message: '请求过于频繁，请稍后重试' }`

```js
// common/rate-limiter.js
// ⚠️ 开发环境专用，生产环境请替换为 Redis 或 uniCloud KV 存储
const LIMIT_MAP = new Map()

/**
 * 简易限流器（滑动窗口）
 * @param {string} key - 限流键（如 uid + ':' + action）
 * @param {number} maxRequests - 窗口内最大请求数
 * @param {number} windowMs - 窗口时长（毫秒）
 * @returns {boolean} true=允许, false=拒绝
 */
function checkRateLimit(key, maxRequests = 60, windowMs = 60000) {
  const now = Date.now()
  const record = LIMIT_MAP.get(key) || { count: 0, resetAt: now + windowMs }

  if (now > record.resetAt) {
    record.count = 0
    record.resetAt = now + windowMs
  }

  if (record.count >= maxRequests) {
    return false
  }

  record.count++
  LIMIT_MAP.set(key, record)
  return true
}

module.exports = { checkRateLimit }
```

```js
// 云对象中使用
const uniID = require('uni-id-common')
const { checkRateLimit } = require('../common/rate-limiter')

async list(params) {
  const uniIDIns = uniID.createInstance({ context: this })
  const token = this.getUniIdToken()
  const { uid } = await uniIDIns.checkToken(token)

  // 每用户每分钟最多 60 次查询
  if (!checkRateLimit(`${uid}:list`, 60, 60000)) {
    return { code: 429, message: '请求过于频繁，请稍后重试' }
  }

  // 正常业务逻辑...
}

async add(data) {
  const uniIDIns = uniID.createInstance({ context: this })
  const token = this.getUniIdToken()
  const { uid } = await uniIDIns.checkToken(token)

  // 写操作更严格：每用户每分钟最多 10 次
  if (!checkRateLimit(`${uid}:add`, 10, 60000)) {
    return { code: 429, message: '操作过于频繁，请稍后重试' }
  }

  // 正常业务逻辑...
}
```

限流建议值：

| 操作类型 | 限流阈值 | 说明 |
|---------|---------|------|
| 查询（list/get） | 60次/分钟 | 普通读操作 |
| 写操作（add/update） | 10次/分钟 | 防止批量刷数据 |
| 登录/注册 | 5次/分钟 | 防暴力破解 |
| 发送验证码 | 1次/60秒 | 严格限流 |

**注意：** 内存 Map 仅适用于单实例开发环境。生产环境多实例部署时，必须用 Redis 或 uniCloud 的 KV 存储做分布式限流。
