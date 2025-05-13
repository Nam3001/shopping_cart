<template>
  <div class="product-grid">
    <ProductCard v-for="product in products" :key="product.id" :product="product" @click="handleClickProductCard" />
  </div>
</template>

<script>

import ProductCard from './ProductCard.vue';
export default {
  components: { ProductCard },
  name: "ProductGrid",
  props: {
    products: {
      type: Array,
      required: true
    }
  },
  methods: {
    handleClickProductCard(productId) {
      this.$router.push({ name: 'detail-product', params: { id: productId } })
    }
  }
};
</script>

<style scoped>
.product-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

@media (max-width: 1080px) {
  .product-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 720px) {
  .product-grid {
    grid-template-columns: repeat(1, 1fr);
  }
}
</style>
