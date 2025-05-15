<template lang="">
  <div class="product-card" @click="$emit('click', product.id)">
    <div class="product-image-container">
      <img :src="this.product?.thumbnails?.[0]?.thumbnail_url" :alt="this.product.product_name" class="product-image" />
    </div>
    <h3 class="product-name">{{ this.product.product_name }}</h3>
    <p class="product-price">{{ this.formatCurrency(this.product.price) }}</p>
    <p class="product-category">{{ this.product.category.name }}</p>
  </div>
</template>
<script>
export default {
  props: {
    product: {
      type: Object,
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
}
</script>
<style>
  
.product-card {
  border: 1px solid #ddd;
  border-radius: 10px;
  padding: 15px;
  background-color: #fff;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  text-decoration: none;
}


.product-image-container {
  max-width: 100%;
  height: 150px;
  border-radius: 8px;
  overflow: hidden;
}


.product-image {
  max-width: 100%;
  height: 100%;
  object-fit: cover;
}


.product-name {
  font-size: 16px;
  margin: 10px 0 5px;
}
.product-price {
  font-weight: bold;
  color: #2e7d32;
}
.product-category {
  color: #666;
  font-size: 14px;
}
.product-card:hover .product-image {
  scale: 1.1;
}
</style>