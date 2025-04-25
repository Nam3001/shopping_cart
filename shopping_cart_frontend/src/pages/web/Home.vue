<template>
  <div>
    <Header></Header>
    <ProductGrid :products="products" />
    <vue-paginate :page-count="totalPages" :click-handler="handlePagechange" :prev-text="'Prev'" :next-text="'Next'"
      :container-class="'pagination'" :page-class="'page-item'" :active-class="'active'" v-model="currentPage">
    </vue-paginate>
  </div>
</template>


<script>
import api from '@/services/api.js'
import PATHS from '@/services/paths'
import Header from '@/components/Header.vue'
import Vue from 'vue';
import ProductGrid from '@/components/ProductGrid.vue'

import VuejsPaginate from 'vuejs-paginate'
Vue.component('vue-paginate', VuejsPaginate)

export default {
  name: 'AdminProductsPage',
  components: {
    Header,
    ProductGrid
  },
  data() {
    return {
      products: [],
      thumbnailPlaceholder: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      currentPage: this.$route.query.page ? Number.parseInt(this.$route.query.page) : 1,
      perPage: 20,
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

            if(this.currentPage > 1) 
              this.$router.push({ name: 'admin-products', query: { page: 1 } });
            else 
              this.fetchProducts(this.currentPage, this.perPage);
          })
          .catch(error => {
            alert(`Error deleting product: ${ error.message}`);
          });
      }
    },
    fetchProducts(page = 1, perPage) {
      if(!perPage) perPage = this.perPage
      
      api.get(PATHS.products, {
          params: {
            page: page,
            per_page: perPage
          }
      })
        .then(response => {
          this.products = response.data.data
          // this.perPage = response.data.pagination.per_page
          this.totalPages = response.data.pagination.total_pages

          if(this.currentPage > this.totalPages) {
            
            this.$router.push({ name: 'home', query: { page: this.totalPages } });
          }
        })
        .catch(error => {
          console.error('Error fetching products:', error);
        });
    },
    handlePagechange(pageNum) {
      this.$router.push({ name: 'home', query: { page: pageNum, per_page: this.perPage } });

    },
    // handleNewProduct() {
    //   this.$router.push({ name: 'admin-product-create' });
    // }
  }
}
</script>