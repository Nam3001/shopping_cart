const PATHS = {
  logout: '/auth/logout',
  login: '/auth/login',
  refresh: '/auth/refresh',
  products: '/products',
  productInfo(id) {
    return `/products/${id}`
  },
  createProduct: '/products',
  updateProduct(id) {
    return `/products/${id}`
  },
  deleteProduct(id) {
    return `/products/${id}`
  },
  me: '/auth/me',
}

export default PATHS