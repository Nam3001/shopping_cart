<template>
  <div>
    <div class="table-container">
      <table>
        <slot></slot>
      </table>
    </div>
    <vue-paginate :page-count="totalPages" :click-handler="handlePagechange" :prev-text="'Prev'" :next-text="'Next'"
      :container-class="'pagination'" :page-class="'page-item'" :active-class="'active'" v-model="currentPage">
    </vue-paginate>
  </div>
</template>
<script>
import Vue from 'vue';

import VuejsPaginate from 'vuejs-paginate'
Vue.component('vue-paginate', VuejsPaginate)

export default {
  props: {
    totalPages: Number,
    routerName: String
  },
  name: 'TableComponent',
  methods: {
    handlePagechange(pageNum) {
      this.$router.push({ name: this.routerName, query: { page: pageNum, per_page: this.perPage } });
    },
  },
  data() {
    return {
      currentPage: Number.parseInt(this?.$route?.query?.page) || 1,
      perPage: Number.parseInt(this?.$route?.query?.per_page) || 10
    }
  },
  watch: {
    '$route.query.page': function () {
      this.currentPage = Number.parseInt(this.$route?.query?.page) ? Number.parseInt(this.$route.query.page) : 1
      this.perPage = Number.parseInt(this.$route?.query?.per_page) ? Number.parseInt(this.$route.query.per_page) : 1
    },
    '$route.query.per_page': function () {
      this.currentPage = Number.parseInt(this.$route?.query?.page) ? Number.parseInt(this.$route.query.page) : 1
      this.perPage = Number.parseInt(this.$route?.query?.per_page) ? Number.parseInt(this.$route.query.per_page) : 1
    }
  }
}
</script>
<style>

.table-container {
  max-height: calc(100vh - var(--navbar-height) - 200px);
  overflow-y: scroll;
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