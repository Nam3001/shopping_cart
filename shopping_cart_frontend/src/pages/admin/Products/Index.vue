<template>
  <div class="content-container">
    <h1 class="heading">Products list</h1>
    <div class="create-btn-container">
      <Button class-name="create-product-btn" @click="handleNewProduct">Create new product</Button>
    </div>
    <Table :total-pages="this.totalPages">
      <thead>
        <tr>
          <th>ID</th>
          <th>Product Name</th>
          <th>Price</th>
          <th>Quantity</th>
          <th>Thumbnail</th>
          <th>Category</th>
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
          <td>{{ product.category.name }}</td>
          <td>{{ product.unit.unit_name }}</td>
          <td>
            <router-link :to="{ name: 'admin-product-edit', params: { id: product.id } }">
              <Button class-name="update-btn">Update</Button>
            </router-link>
            <Button class-name="delete-btn" @click="handleDeleteProduct(product.id)">Delete</Button>
          </td>
        </tr>
      </tbody>
    </Table>
  </div>
</template>
<script>
import api from '@/services/api.js';
import PATHS from '@/services/paths';
import Button from '@/components/Button.vue';
import Table from '@/components/Table.vue';
// import DOMPurify from 'dompurify';


export default {
  name: 'AdminProductsPage',
  components: {
    Button, Table
  },
  data() {
    return {
      products: [],
      thumbnailPlaceholder: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
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
    handleDeleteProduct(productId) {
      if (confirm('Are you sure you want to delete this product?')) {
        api.delete(PATHS.deleteProduct(productId))
          .then(() => {
            alert('Product deleted successfully');
            let currentPage  = Number.parseInt(this.$route?.query?.page)
            let perPage = Number.parseInt(this.$route?.query?.per_page)
            if (currentPage > 1) {
              this.$router.push({ name: 'admin-products', query: { page: 1, per_page: perPage } });
            }
            else
              this.fetchProducts(1, perPage);
          })
          .catch((e) => {
            let errorMessage = e.response?.data?.error
            alert(`Error deleting product: ${errorMessage}`);
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
          this.products = response.data.products
          this.totalPages = response.data.pagination.total_pages === 0 ? 1 : response.data.pagination.total_pages

          let currentPage = Number.parseInt(this.$route?.query?.page)
          let perPage = Number.parseInt(this.$route?.query?.per_page)
          if (currentPage > this.totalPages) {

            this.$router.push({ name: 'admin-products', query: { page: this.totalPages, per_page: perPage } });
          }
        })
        .catch((e) => {
          let errorMessage = e.response?.data?.error
          console.error('Error fetching products:', errorMessage);
        });
    },
    handleNewProduct() {
      this.$router.push({ name: 'admin-product-create' });
    }
  }
}
</script>

<style scoped>
.create-btn-container {
  display: flex;
  justify-content: flex-end;
}

.heading {
  margin: 10px 0;
  text-align: center;
}

.content-container {
  padding: 0 20px 20px;
}

.thumbnail-column {
  text-align: center;
  width: 60px;
}

.thumbnail {
  width: 70%;
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