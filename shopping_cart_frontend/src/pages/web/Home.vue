<template>
  <WebLayout>
    <ProductGrid :products="products" />
    <vue-paginate :page-count="totalPages" :click-handler="handlePagechange" :prev-text="'Prev'" :next-text="'Next'"
      :container-class="'pagination'" :page-class="'page-item'" :active-class="'active'" v-model="currentPage">
    </vue-paginate>
  </WebLayout>
</template>


<script>
import api from '@/services/api.js'
import PATHS from '@/services/paths'
import Vue from 'vue';
import ProductGrid from '@/components/ProductGrid.vue'
import WebLayout from '@/layouts/WebLayout.vue';

import VuejsPaginate from 'vuejs-paginate'
Vue.component('vue-paginate', VuejsPaginate)

export default {
  name: 'AdminProductsPage',
  components: {
    ProductGrid,
    WebLayout
  },
  data() {
    return {
      products: [],
      thumbnailPlaceholder: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      currentPage: this.$route.query.page ? Number.parseInt(this.$route.query.page) : 1,
      initPerPage: 20,
      totalPages: 0
    }
  },
  mounted() {
    this.fetchProducts(this.$route?.query?.page, this.$route?.query?.per_page);
  },
  watch: {
    '$route.query.page': function (newPage) {
      this.fetchProducts(newPage, this.$route?.query?.per_page);
    },
    '$route.query.per_page': function (newPerPage) {
      this.fetchProducts(this.$route?.query?.page, newPerPage);
    }
  },
  
  methods: {
    fetchProducts(page = 1, perPage) {
      if(!perPage) perPage = this.$route?.query?.per_page || this.initPerPage
        api.get(PATHS.products, {
        params: {
          page: page,
          per_page: perPage
        }
      })
        .then(response => {
          this.products = response.data.products
          this.totalPages = response.data.pagination.total_pages === 0 ? 1 : response.data.pagination.total_pages

          let currentPage = Number.parseInt(this.$route?.query?.page)
          let perPage = Number.parseInt(this.$route?.query?.per_page)
          if (currentPage > this.totalPages) {

            this.$router.push({ name: 'home', query: { page: this.totalPages, per_page: perPage } });
          }
        })
        .catch((e) => {
          let errorMessage = e.response?.data?.error
          console.error('Error fetching products:', errorMessage);
        });
    },
    handlePagechange(pageNum) {
      this.$router.push({ name: 'home', query: { page: pageNum, per_page: this.$route?.query?.per_page || this.initPerPage } });

    }
  }
}
</script>


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