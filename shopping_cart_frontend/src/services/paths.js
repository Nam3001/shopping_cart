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

  categories: '/categories',
  categoryInfo(id) {
    return `/categories/${id}`
  },
  createCategory: '/categories',
  updateCategory(id) {
    return `categories/${id}`
  },
  deleteCategory(id) {
    return `categories/${id}`
  },

  units: '/units',
  unitInfo(id) {
    return `/units/${id}`
  },
  createUnit: '/units',
  updateUnit(id) {
    return `units/${id}`
  },
  deleteUnit(id) {
    return `units/${id}`
  },

  attributes: '/attributes',
  attributeInfo(id) {
    return `/attributes/${id}`
  },
  createAttribute: '/attributes',
  updateAttribute(id) {
    return `attributes/${id}`
  },
  deleteAttribute(id) {
    return `attributes/${id}`
  },

  me: '/auth/me',
}

export default PATHS