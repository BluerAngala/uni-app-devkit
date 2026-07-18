---
name: uni-app-state-management
description: "uni-app 状态管理规范。适用于 Pinia store 的编写、模块拆分、持久化、与 uni-storage 边界的审查。"
alwaysApply: true
---

# 状态管理规范

## 1. 框架选择

- **使用 Pinia**（uni-app 官方推荐 Vue 3 + Pinia。Vue 2 项目如需 Pinia 需额外配置 `@pinia/vue2-plugin`，但不推荐）
- 禁止 Vuex（Pinia 是 Vue 官方推荐的下一代状态管理）
- uni-app 必须用 `createSSRApp`（不是 `createApp`），Pinia 实例必须在 `createApp()` 工厂函数中 return

```js
// main.js
import { createSSRApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'

export function createApp() {
  const app = createSSRApp(App)
  const pinia = createPinia()
  app.use(pinia)
  return {
    app,
    pinia,  // 必须 return pinia，uni-app 框架需要
  }
}
```

**⚠️ 关键点：**
- 必须 return `{ app, pinia }`，不能只 return app
- Vue 2 项目如需状态管理，只能用 Vuex 或自行封装响应式 store（`Vue.observable()`）

## 2. Store 模块拆分

按业务域拆分，不按数据类型拆分。

```
store/
├── index.js              # createPinia() + 注册
├── user.js               # 用户信息、登录态、权限
├── app.js                # 全局主题、语言、设备信息
├── <module>.js           # 业务模块（如 product、order）
```

```js
// store/user.js
import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: '',
    userInfo: null,
    roles: [],
  }),

  getters: {
    isLoggedIn: (state) => !!state.token,
    isAdmin: (state) => state.roles.includes('admin'),
  },

  actions: {
    async login(params) {
      const res = await uniCloud.importObject('user-co').login(params)
      this.token = res.token
      this.userInfo = res.userInfo
      this.roles = res.roles || []
      // 同步持久化
      uni.setStorageSync('uni_id_token', res.token)
      uni.setStorageSync('uni_id_token_expired', res.tokenExpired)
    },

    logout() {
      this.token = ''
      this.userInfo = null
      this.roles = []
      uni.removeStorageSync('uni_id_token')
      uni.removeStorageSync('uni_id_token_expired')
      uni.reLaunch({ url: '/pages/login/login' })
    },
  },
})
```

## 3. Store vs Storage 边界

| 场景 | 用 Store | 用 Storage |
|------|---------|-----------|
| 页面间共享的响应式状态 | ✅ | ❌ |
| 登录 token（跨启动持久化） | ✅ 同步到 storage | ✅ 作为持久层 |
| 用户偏好（主题/语言） | ✅ | ✅ 作为持久层 |
| 一次性表单草稿 | ❌ | ✅ 直接 storage |
| 缓存过期数据 | ❌ | ✅ 带过期时间 |

**原则：Store 管内存状态，Storage 管持久化。Store 的 state 是单一数据源，Storage 只是它的备份。**

```js
// ✅ Store 初始化时从 Storage 恢复
state: () => ({
  token: uni.getStorageSync('uni_id_token') || '',
  theme: uni.getStorageSync('app_theme') || 'light',
})

// ❌ 禁止在组件里直接读 Storage 判断登录态
if (uni.getStorageSync('uni_id_token')) { ... }
// ✅ 应该用 Store getter
if (userStore.isLoggedIn) { ... }
```

## 4. 组件中使用

Options API 中用 `mapStores` 或在 computed 中缓存 store 引用（避免每次调用创建新实例）：

```vue
<script>
import { useUserStore } from '@/store/user'
import { mapStores, mapState, mapActions } from 'pinia'

export default {
  computed: {
    // ✅ 推荐：mapStores 自动注册所有 store
    ...mapStores(useUserStore),
    // 然后用 this.userStore.isLoggedIn

    // 或：mapState 只映射特定 getter
    // ...mapState(useUserStore, ['isLoggedIn', 'isAdmin']),
  },
  methods: {
    // ✅ mapActions 映射 store 方法
    ...mapActions(useUserStore, ['logout']),
    handleLogout() {
      this.logout()
      // 或 this.userStore.logout()
    },
  },
}
</script>
```

**⚠️ 禁止在 computed 中直接调用 `useUserStore()` 作为返回值** — 每次 computed 重新计算时会创建新引用，导致不必要的渲染。用 `mapStores` 或 `mapState` 代替。

## 5. 跨页面通信

| 场景 | 方案 |
|------|------|
| 父子页面传参 | `onLoad(options)` + URL 参数 |
| 兄弟页面共享状态 | Pinia store |
| 全局事件通知 | `uni.$emit` / `uni.$on`（轻量，不滥用） |
| 页面返回刷新 | `onShow` 中重新加载，不用 eventBus |

## 6. 禁止事项

| 禁止 | 替代 |
|------|------|
| Vuex | Pinia |
| 全局变量 `getApp().globalData` | Pinia store |
| 组件内直接读写 `uni.setStorageSync` 判断状态 | Store getter/action |
| 一个巨型 store 存所有状态 | 按业务域拆分多个 store |
| `$on` / `$emit` 做复杂数据流 | Pinia store |
