---
name: uni-typescript
description: "uni-app TypeScript 规范。适用于 .vue 文件的 TS 声明、云对象类型定义、类型导入的编写和审查。"
alwaysApply: true
---

# TypeScript 规范

## 1. 使用场景

- **推荐 TS**：新项目、Store、工具函数库、云对象类型定义
- **可选 JS**：已有 JS 项目的 .vue 页面文件（渐进迁移）
- `.vue` 文件中用 `<script>` + JSDoc 或 `<script lang=\"ts\">`

## 2. Vue 文件中的 TS

```vue
<script lang="ts">
import { defineComponent, PropType } from 'vue'

interface Product {
  _id: string
  name: string
  price: number
  status: number
}

export default defineComponent({
  props: {
    product: {
      type: Object as PropType<Product>,
      required: true,
    },
  },
  data() {
    return {
      loading: false as boolean,
      list: [] as Product[],
      formData: {
        name: '',
        price: 0,
      } as Partial<Product>,
    }
  },
  methods: {
    async loadData(): Promise<void> {
      this.loading = true
      try {
        const res = await this.$db.collection('product').get()
        this.list = res.result.data as Product[]
      } finally {
        this.loading = false
      }
    },
  },
})
</script>
```

## 3. 云对象类型定义

为每个云对象创建类型文件，前后端共享。

```ts
// types/product-co.ts

/** 云对象入参类型 */
export interface ProductListParams {
  page?: number
  pageSize?: number
  where?: Record<string, any>
  orderby?: string
}

export interface ProductAddParams {
  name: string
  price: number
  status?: number
  [key: string]: any
}

/** 云对象返回类型 */
export interface ProductListResult {
  data: Product[]
  total: number
  page: number
  pageSize: number
}

export interface Product {
  _id: string
  name: string
  price: number
  status: number
  create_date: number
  update_date: number
}
```

```ts
// 在页面中使用
import type { Product, ProductListParams } from '@/types/product-co'

const productCo = uniCloud.importObject('product-co')
const params: ProductListParams = { page: 1, pageSize: 20 }
const res = await productCo.list(params)
const list: Product[] = res.data
```

## 4. Store 类型

```ts
// store/user.ts
import { defineStore } from 'pinia'

interface UserInfo {
  _id: string
  username: string
  role: string[]
  nickname?: string
  avatar?: string
}

interface UserState {
  token: string
  userInfo: UserInfo | null
  roles: string[]
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    token: uni.getStorageSync('uni_id_token') || '',
    userInfo: null,
    roles: [],
  }),

  getters: {
    isLoggedIn: (state): boolean => !!state.token,
    isAdmin: (state): boolean => state.roles.includes('admin'),
  },

  actions: {
    async login(params: { username: string; password: string }): Promise<void> {
      const res = await uniCloud.importObject('user-co').login(params)
      this.token = res.token
      this.userInfo = res.userInfo as UserInfo
      this.roles = res.roles || []
    },
  },
})
```

## 5. 工具函数类型

```ts
// utils/format.ts

/**
 * 格式化价格
 * @param value - 原始值（分或元）
 * @param options.fromCent - 是否从分为单位
 */
export function formatPrice(
  value: number,
  options: { fromCent?: boolean } = {}
): string {
  const { fromCent = false } = options
  const amount = fromCent ? value / 100 : value
  return amount.toFixed(2)
}

/**
 * 格式化日期
 */
export function formatDate(
  timestamp: number,
  format: 'YYYY-MM-DD' | 'YYYY-MM-DD HH:mm:ss' = 'YYYY-MM-DD'
): string {
  // 实现略
}
```

## 6. uni-app API 类型增强

```ts
// types/uni.d.ts
declare namespace UniApp {
  interface Uni {
    // 扩展自定义 uni API 类型
    $request: <T = any>(options: RequestOptions) => Promise<T>
    $hasPermission: (permission: string) => boolean
    $hasRole: (role: string) => boolean
  }
}
```

## 7. tsconfig.json

```json
{
  \"compilerOptions\": {
    \"target\": \"es2017\",
    \"module\": \"esnext\",
    \"strict\": true,
    \"jsx\": \"preserve\",
    \"moduleResolution\": \"node\",
    \"esModuleInterop\": true,
    \"sourceMap\": true,
    \"skipLibCheck\": true,
    \"baseUrl\": \".\",
    \"paths\": {
      \"@/*\": [\"./src/*\"]
    },
    \"types\": [\"@dcloudio/types\"]
  },
  \"include\": [\"src/**/*.ts\", \"src/**/*.vue\"],
  \"exclude\": [\"node_modules\", \"dist\", \"unpackage\"]
}
```

## 8. 禁止事项

| 禁止 | 替代 |
|------|------|
| `any` 滥用 | 定义具体类型或用 `unknown` + 类型守卫 |
| `@ts-ignore` 隐藏错误 | 修复类型或用 `@ts-expect-error` + 说明原因 |
| JS 文件中写 `// @ts-check` 不加类型 | 要么转 TS，要么用 JSDoc 注释完整类型 |
| 类型定义和实现不同步 | 类型文件和云对象代码放在同一仓库 |
