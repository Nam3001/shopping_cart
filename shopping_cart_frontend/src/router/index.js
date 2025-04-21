import Vue from 'vue'
import VueRouter from 'vue-router'

import Login from '@/pages/admin/Login.vue'
import NotFound from '@/pages/NotFound.vue'
import { default as AdminHome } from '@/pages/admin/Home.vue'

Vue.use(VueRouter)


const routes = [
  {
    path: '/',
    component: () => import('@/pages/web/Home.vue'),
  },
  {
    path: '/admin',
    component: AdminHome,
    children: [],
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/admin/login',
    component: Login,
  },
  {
    path: '/admin/products',
    name: 'admin-products',
    component: () => import('@/pages/admin/Products/Index.vue'),
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'admin-product-create',
    path: '/admin/products/new',
    component: () => import('@/pages/admin/Products/NewProduct.vue'),
    meta: {
      requiresAuth: true
    }
  },
  {
    name: 'admin-product-edit',
    path: '/admin/products/:id/edit',
    component: () => import('@/pages/admin/Products/EditProduct.vue'),
    meta: {
      requiresAuth: true
    }
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
  if(to.meta.requiresAuth && !isAuthenticated) {
    next({ path: '/admin/login' })
  } else if(to.path === '/admin/login' && isAuthenticated) {
    next({ path: '/admin' })
  } else {
    next()
  }
})

export default router