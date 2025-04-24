<template>
  <div class="product-grid">
    <div v-for="product in products" :key="product.id" class="product-card">
      <img :src="product.thumbnail_url" :alt="product.product_name" class="product-image" />
      <h3 class="product-name">{{ product.product_name }}</h3>
      <p class="product-price">{{ formatCurrency(product.price) }}</p>
      <p class="product-quantity">Số lượng: {{ product.quantity }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "ProductGrid",
  props: {
    products: {
      type: Array,
      required: true
    }
  },
  methods: {
    formatCurrency(value) {
      return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
      }).format(value);
    }
  }
};
</script>

<style scoped>
.product-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
  padding: 20px;
}

@media (max-width: 968px) {
  .product-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 550px) {
  .product-grid {
    grid-template-columns: repeat(1, 1fr);
  }
}
.product-card {
  border: 1px solid #ddd;
  border-radius: 10px;
  padding: 15px;
  background-color: #fff;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}
.product-image {
  max-width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
}
.product-name {
  font-size: 16px;
  margin: 10px 0 5px;
}
.product-price {
  font-weight: bold;
  color: #2e7d32;
}
.product-quantity {
  color: #666;
  font-size: 14px;
}
</style>


<style lang="css">
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  list-style-type: none;

}
.page-item, .pagination li {
  margin: 0 5px;
  border: 1px solid #ccc;
  border-radius: 3px;
  height: 35px;
  min-width: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.page-item a, .pagination li a {
  padding: 10px 10px;
  text-align: center;
  width: 100%;
}
.page-item.disabled, .pagination li.disabled {
  pointer-events: none;
  opacity: 0.5;
}
.active {
  background-color: var(--main-color);
  color: #fff;
  border: none;
}
</style>