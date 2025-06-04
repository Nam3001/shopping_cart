import Vue from 'vue'
import VueRouter from 'vue-router'

import Login from '@/pages/admin/Login.vue'
import NotFound from '@/pages/NotFound.vue'


Vue.use(VueRouter)


const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/pages/web/Home.vue'),
  },
  {
    path: '/detail-product/:id',
    name: 'detail-product',
    component: () => import('@/pages/web/DetailProduct.vue')
  },
  {
    path: '/admin',
    name: 'admin-home',
    component: () => import('@/pages/admin/Index.vue'),
    children: [
      {
        name: 'admin-products',
        path: 'products',
        component: () => import('@/pages/admin/Products/Index.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-product-create',
        path: 'products/new',
        component: () => import('@/pages/admin/Products/NewProduct.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-product-edit',
        path: 'products/:id/edit',
        component: () => import('@/pages/admin/Products/EditProduct.vue'),
        meta: {
          requiresAuth: true
        }
      },

      {
        name: 'admin-categories',
        path: 'categories',
        component: () => import('@/pages/admin/Categories/Index.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-category-create',
        path: 'categories/new',
        component: () => import('@/pages/admin/Categories/New.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-category-edit',
        path: 'categories/:id/edit',
        component: () => import('@/pages/admin/Categories/Edit.vue'),
        meta: {
          requiresAuth: true
        }
      },

      {
        name: 'admin-units',
        path: 'units',
        component: () => import('@/pages/admin/Units/Index.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-unit-create',
        path: 'units/new',
        component: () => import('@/pages/admin/Units/New.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-unit-edit',
        path: 'units/:id/edit',
        component: () => import('@/pages/admin/Units/Edit.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-attributes',
        path: 'attributes',
        component: () => import('@/pages/admin/Attributes/Index.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-attribute-new',
        path: 'attributes/new',
        component: () => import('@/pages/admin/Attributes/New.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-attribute-edit',
        path: 'attributes/:id/edit',
        component: () => import('@/pages/admin/Attributes/Edit.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        name: 'admin-attribute-detail',
        path: 'attributes/:id',
        component: () => import('@/pages/admin/Attributes/Detail.vue'),
        meta: {
          requiresAuth: true
        }
      }
    ],
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/admin/login',
    name: 'login',
    component: Login,
  },
  {
    path: '/not-found',
    name: 'not-found',
    component: NotFound
  },
  {
    path: '*',
    name: 'not-found',
    component: NotFound
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('access_token') !== null
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ path: '/admin/login' })
  } else if (to.path === '/admin/login' && isAuthenticated) {
    next({ path: '/admin' })
  } else {
    next()
  }
})

export default router