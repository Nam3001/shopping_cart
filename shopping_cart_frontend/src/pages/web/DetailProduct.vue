<template>
  <WebLayout>
    <div class="product-detail">
      <div class="product-images">
        <div class="main-image">
          <img :src="product?.thumbnails?.[currentImageIndex].thumbnail_url" alt="Hình ảnh chính">
        </div>
        <div class="thumbnail-images">
          <img v-for="(thumbnail, index) in product?.thumbnails" :key="thumbnail.id" :src="thumbnail.thumbnail_url"
            :class="{ active: index === currentImageIndex }" @click="currentImageIndex = index" alt="Hình ảnh thu nhỏ">
        </div>
      </div>

      <div class="product-info">
        <h1 class="product-title">{{ product?.product_name }}</h1>
        <div class="product-price">
          <span class="original-price" v-if="product?.discountPrice">{{ formatPrice(product?.price) }}</span>
          <span class="discounted-price">{{ formatPrice(product?.discountPrice || product?.price) }}</span>
        </div>
        <div class="product-rating">
          <span v-for="i in 5" :key="i" class="star" :class="{ active: i <= Math.round(product?.rating) }">★</span>
          <span>({{ product?.reviewCount }} đánh giá)</span>
        </div>

        <!-- <div class="product-options" v-if="product.options && Object.keys(product.options).length > 0">
          <div v-for="(optionValues, optionName) in product.options" :key="optionName" class="option">
            <label>{{ optionName }}:</label>
            <select v-model="selectedOptions[optionName]">
              <option v-for="value in optionValues" :key="value" :value="value">{{ value }}</option>
            </select>
          </div>
        </div> -->

        <div class="product-quantity">
          <span>Tồn kho: </span>
          <span>{{ product?.quantity }}</span>
        </div>
        <div class="product-actions">
          <div class="quantity-selector">
            <button @click="decreaseQuantity" :disabled="quantity === 1 || product.quantity === 0">-</button>
            <span>{{ quantity }}</span>
            <button @click="increaseQuantity" :disabled="product.quantity === 0 || quantity === product.quantity">+</button>
          </div>
          <button class="add-to-cart" @click="addToCart" :disabled="!product?.quantity || product.quantity === 0">Thêm vào giỏ hàng</button>
          <button class="buy-now">Mua ngay</button>
        </div>

        <div>
          <p>Danh mục: <span>Điện tử</span></p>
        </div>
        <!-- <div class="product-details">
        <h3>Thông tin chi tiết:</h3>
        <ul>
          <li v-for="(value, key) in product.details" :key="key">
            <strong>{{ key }}:</strong> {{ value }}
          </li>
        </ul>
      </div> -->
      </div>
    </div>
    <div class="product-description">
      <h3>Mô tả sản phẩm:</h3>
      <p v-html="product?.description"></p>
    </div>
  </WebLayout>
</template>

<script>
import WebLayout from '@/layouts/WebLayout.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
export default {
  name: 'ProductDetail',
  components: { WebLayout },
  data() {
    return {
      product: null,
      currentImageIndex: 0,
      quantity: 1,
      selectedOptions: {}
    };
  },
  methods: {
    formatPrice(price) {
      return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(price);
    },
    increaseQuantity() {
      if(this.product.quantity === 0) return
      this.quantity++;
    },
    decreaseQuantity() {
      if (this.quantity <= 1) return
      this.quantity--;
    },
    addToCart() {
      alert('Đã thêm sản phẩm vào giỏ hàng!');
    },

    fetchProductInfo(id) {
      api.get(PATHS.productInfo(id)).then(res => {
        this.product = res.data
      }).catch(e => {
         let errorMessage = e.response?.data?.error
          alert("Logout failed: " + errorMessage)
      })
    }
  },
  mounted() {
    this.fetchProductInfo(this.$route.params?.id)
  }
};
</script>

<style scoped>
.product-detail {
  display: flex;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 8px;
  margin-bottom: 20px;
  flex-direction: row;
}

@media (max-width: 720px) {
  .product-detail {
    flex-direction: column;
  }

  .product-images {
    width: 100% !important;
  }
}

.product-images {
  width: 40%;
  margin-right: 20px;
}

button[disabled] {
  opacity: 0.8;
  cursor: auto;
}

.main-image {
  margin-bottom: 10px;
  border: 1px solid #eee;
  border-radius: 4px;
  overflow: hidden;
  height: 400px;
  width: 400px;
}

.main-image img {
  width: 100%;
  object-fit: cover;
  display: block;
}

.thumbnail-images {
  display: flex;
  gap: 5px;
  overflow-x: auto;
}

.thumbnail-images img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border: 1px solid #eee;
  border-radius: 4px;
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.thumbnail-images img.active,
.thumbnail-images img:hover {
  opacity: 1;
  border-color: #333;
}

.product-info {
  width: 60%;
}

.product-title {
  font-size: 24px;
  margin-bottom: 10px;
}

.product-price {
  font-size: 18px;
  margin-bottom: 15px;
}

.original-price {
  color: #777;
  text-decoration: line-through;
  margin-right: 10px;
}

.discounted-price {
  color: #e44d26;
  font-weight: bold;
}

.product-rating {
  color: #ffc107;
  font-size: 16px;
  margin-bottom: 20px;
}

.star {
  margin-right: 3px;
}

.star.active {
  color: #ff9800;
}

.product-quantity {
  margin-bottom: 10px;
}

.product-description {
  margin-bottom: 20px;
}

.product-description h3 {
  font-size: 16px;
  margin-bottom: 5px;
}

.product-description p {
  line-height: 1.6;
}

.product-options {
  margin-bottom: 20px;
}

.option {
  margin-bottom: 10px;
}

.option label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.option select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.product-actions {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  flex-direction: row;
}

@media(max-width: 720px) {
  .product-actions {
    flex-direction: column;
    align-items: flex-start;
    justify-content: space-between;
  }

  .quantity-selector {
    margin-bottom: 10px;    
  }
  .add-to-cart {
    margin-bottom: 10px;
  }
}

.quantity-selector {
  display: flex;
  align-items: center;
  margin-right: 20px;
  border: 1px solid #ccc;
  border-radius: 4px;
  overflow: hidden;
  min-width: 100px;
}

.quantity-selector button {
  background: none;
  border: none;
  padding: 8px 12px;
  cursor: pointer;
  font-size: 16px;
}

.quantity-selector button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.quantity-selector span {
  padding: 8px 15px;
  border-left: 1px solid #ccc;
  border-right: 1px solid #ccc;
}

.add-to-cart,
.buy-now {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  color: white;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.add-to-cart {
  background-color: #4caf50;
  margin-right: 10px;
}

.add-to-cart:hover {
  background-color: #45a049;
}
.add-to-cart[disabled]:hover {
  background-color: #4caf50;
}

.buy-now {
  background-color: #007bff;
}

.buy-now:hover {
  background-color: #0056b3;
}
.buy-now[disabled]:hover {
  background-color: #007bff;
}

.product-details h3 {
  font-size: 16px;
  margin-bottom: 10px;
}

.product-details ul {
  list-style: none;
  padding: 0;
}

.product-details li {
  margin-bottom: 5px;
}

.product-details strong {
  font-weight: bold;
  margin-right: 5px;
}
</style>