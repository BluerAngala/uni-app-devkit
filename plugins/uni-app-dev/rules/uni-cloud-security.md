---
name: uni-cloud-security
description: "uniCloud 安全规则。适用于云函数、云对象、JQL 查询的编写和审查。"
alwaysApply: true
---

# uniCloud 安全规则

## 1. 权限校验

- 云函数/云对象入口必须校验调用者身份
- 写操作（增删改）必须校验权限，读操作按需
- 使用 `uniID.checkToken(token)` 验证登录态
- 管理员操作用 `uid` 对比或角色检查

```js
// 云对象示例
async delete(id) {
  const token = this.getUniIdToken()
  const { uid, role } = await uniID.checkToken(token)
  if (!role.includes('admin')) {
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
const { where } = this.getBodyParams()
db.collection('user').where(where).get()

// ✅ 安全
const { name, status } = this.getBodyParams()
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

- 对外暴露的接口应做频率限制
- 使用 `uniCloud-alipay/cloudfunctions/common/` 中的公共模块统一处理
