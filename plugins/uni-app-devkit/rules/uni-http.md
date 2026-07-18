---
name: uni-http
description: "uni-app 网络请求封装规范。适用于 uni.request 封装、uniCloud 调用、错误处理、拦截器的编写和审查。"
alwaysApply: true
---

# 网络请求规范

## 1. 请求封装

所有 HTTP 请求必须通过统一的 `$request` 实例，禁止直接调用 `uni.request()`。

```js
// utils/request.js
const BASE_URL = process.env.VUE_APP_BASE_URL || ''

function $request(options) {
  return new Promise((resolve, reject) => {
    const token = uni.getStorageSync('uni_id_token') || ''
    uni.request({
      url: BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data,
      header: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        ...options.header,
      },
      success(res) {
        if (res.statusCode === 200) {
          resolve(res.data)
        } else if (res.statusCode === 401) {
          // token 过期，清除登录态并跳转
          uni.removeStorageSync('uni_id_token')
          uni.removeStorageSync('uni_id_token_expired')
          uni.reLaunch({ url: '/pages/login/login' })
          reject(new Error('登录已过期'))
        } else {
          reject(new Error(res.data?.message || `请求失败 (${res.statusCode})`))
        }
      },
      fail(err) {
        reject(new Error(err.errMsg || '网络异常'))
      },
    })
  })
}

export default $request
```

## 2. uniCloud 调用

uniCloud 的云对象和云函数调用是独立体系，不经过 `$request`。

```js
// ✅ 云对象调用
const productCo = uniCloud.importObject('product-co')
const res = await productCo.list({ page: 1, pageSize: 20 })

// ✅ 云函数调用
const res = await uniCloud.callFunction({
  name: 'product-fn',
  data: { action: 'list', params: { page: 1 } },
})

// ❌ 禁止用 uni.request 调用 uniCloud HTTP 接口
```

## 3. 错误处理

所有请求必须有 `.catch` 或 `try/catch`，禁止裸调用。

```js
// ✅ 列表页加载
async loadData() {
  this.loading = true
  try {
    const res = await productCo.list({ page: this.page })
    this.list = res.data
    this.total = res.total
  } catch (e) {
    uni.showToast({ title: e.message || '加载失败', icon: 'none' })
  } finally {
    this.loading = false
  }
}

// ❌ 裸调用
const res = await productCo.list({ page: 1 })
this.list = res.data
```

## 4. Loading 状态

- 按钮提交：禁用 + loading 图标
- 页面加载：`this.loading` 控制骨架屏或空状态
- 批量操作：进度提示

```js
// ✅ 提交按钮
async submit() {
  if (this.submitting) return  // 防重复提交
  this.submitting = true
  try {
    await productCo.add(this.formData)
    uni.showToast({ title: '新增成功' })
    setTimeout(() => uni.navigateBack(), 500)
  } catch (e) {
    uni.showToast({ title: e.message || '提交失败', icon: 'none' })
  } finally {
    this.submitting = false
  }
}
```

## 5. 环境区分

环境变量取值方式取决于编译器，不需要条件编译：

```js
// utils/config.js
// Vue 3 + Vite 项目：
const BASE_URL = import.meta.env.VITE_BASE_URL || ''

// Vue 2 + webpack 项目（替换上一行）：
// const BASE_URL = process.env.VUE_APP_BASE_URL || ''

export default {
  baseUrl: BASE_URL,
}
```

环境变量命名规则：

| 编译器 | 变量前缀 | 定义文件 |
|--------|---------|----------|
| Vite (Vue 3) | `VITE_` | `.env` / `.env.development` / `.env.production` |
| webpack (Vue 2) | `VUE_APP_` | `.env` / `.env.development` / `.env.production` |

- uniCloud 的环境通过 `uniCloud-alipay` / `uniCloud-tcb` 目录自动区分
- 前端 HTTP 接口的环境通过 `process.env.NODE_ENV` 区分

## 6. 禁止事项

| 禁止 | 替代 |
|------|------|
| `axios` / `fetch` | `uni.request()` 或 `$request` |
| 裸 `uni.request()` | `$request()` |
| 请求不 catch | 始终 `try/catch` |
| token 硬编码 | `uni.getStorageSync()` 动态读取 |
| baseURL 硬编码 | 配置文件 + 环境变量 |
