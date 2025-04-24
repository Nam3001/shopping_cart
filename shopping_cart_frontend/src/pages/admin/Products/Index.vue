<template>
  <div class="content-container">
    <h1 style="margin: 10px 0; text-align: center;">Products list</h1>
    <div style="display: flex; justify-content: flex-end;">
      <Button class-name="create-product-btn" @click="handleNewProduct">Create new product</Button>
    </div>
    <div class="product-list">
      <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Product Name</th>
          <th>Price</th>
          <th>Quantity</th>
          <th>Thumbnail</th>
          <th>Unit</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="product in products" :key="product.id">
          <td>{{ product.id }}</td>
          <td>{{ product.product_name }}</td>
          <td>{{ product.price }}</td>
          <td>{{ product.quantity }}</td>
          <td class="thumbnail-column"><img class="thumbnail" :src="product.thumbnail_url || thumbnailPlaceholder"
              alt="Product Thumbnail" /></td>
          <td>{{ product.unit }}</td>
          <td>
            <router-link :to="{ name: 'admin-product-edit', params: { id: product.id } }">
              <Button class-name="update-btn">Update</Button>
            </router-link>
            <Button class-name="delete-btn" @click="handleDeleteProduct(product.id)">Delete</Button>
          </td>
        </tr>
      </tbody>
    </table>
    </div>
    <vue-paginate :page-count="totalPages" :click-handler="handlePagechange" :prev-text="'Prev'" :next-text="'Next'"
      :container-class="'pagination'" :page-class="'page-item'" :active-class="'active'" v-model="currentPage">
    </vue-paginate>
  </div>
</template>
<script>
import api from '@/services/api.js';
import PATHS from '@/services/paths';
import Button from '@/components/Button.vue';
import Vue from 'vue';

import VuejsPaginate from 'vuejs-paginate'
Vue.component('vue-paginate', VuejsPaginate)

export default {
  name: 'AdminProductsPage',
  components: {
    Button
  },
  data() {
    return {
      products: [],
      thumbnailPlaceholder: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      currentPage: this.$route.query.page ? Number.parseInt(this.$route.query.page) : 1,
      perPage: 10,
      totalPages: 0
    }
  },
  mounted() {
    this.currentPage = this.$route.query.page ? Number.parseInt(this.$route.query.page) : 1;
    this.fetchProducts(this.$route.query.page, this.perPage);
  },
  watch: {
    '$route.query.page': function (newPage) {
      this.currentPage = this.$route.query.page ? Number.parseInt(this.$route.query.page) : 1;
      this.fetchProducts(newPage, this.perPage);
    }
  },
  
  methods: {
    handleDeleteProduct(productId) {
      if (confirm('Are you sure you want to delete this product?')) {
        api.delete(PATHS.deleteProduct(productId))
          .then(() => {
            alert('Product deleted successfully');
            this.fetchProducts();
          })
          .catch(error => {
            alert(`Error deleting product: ${ error.message}`);
          });
      }
    },
    fetchProducts(page = 1, perPage = 10) {
      api.get(PATHS.products, {
          params: {
            page: page,
            per_page: perPage
          }
      })
        .then(response => {
          this.products = response.data.data
          this.perPage = response.data.pagination.per_page
          this.totalPages = response.data.pagination.total_pages

          if(this.currentPage > this.totalPages) {
            
            this.$router.push({ name: 'admin-products', query: { page: this.totalPages } });
          }
        })
        .catch(error => {
          console.error('Error fetching products:', error);
        });
    },
    handlePagechange(pageNum) {
      this.$router.push({ name: 'admin-products', query: { page: pageNum } });
    },
    handleNewProduct() {
      this.$router.push({ name: 'admin-product-create' });
    }
  }
}
</script>

<style scoped>
.content-container {
  padding: 0 20px 20px;
}

.product-list {
  max-height: calc(100vh - var(--navbar-height) - 200px);
  overflow-y: scroll;
}

.thumbnail-column {
  text-align: center;
  width: 60px;
}

.thumbnail {
  width: 70%;
}

table {
  border-collapse: collapse;
  width: 100%;
}


th,
td {
  border: 1px solid #9999;
  padding: 8px;
  text-align: left;
}

.update-btn {
  background-color: #008000;
}

.update-btn:hover {
  background-color: #026102;
}

.delete-btn {
  background-color: #c63e3e;
}

.delete-btn:hover {
  background-color: #a43434;
}

.create-product-btn {
  background-color: #008000;
  color: white;
  padding: 10px;
  margin-bottom: 20px;
  margin-left: 0;
  margin-right: 0;
}
.create-product-btn:hover {
  background-color: #016001;
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