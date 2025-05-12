<template>
  <div class="content-container">
    <h1 class="heading">Categories list</h1>
    <div class="create-btn-container">
      <Button class-name="create-category-btn" @click="handleNewCategory">Create new category</Button>
    </div>
    <Table :total-pages="this.totalPages">
      <thead>
        <tr>
          <th>ID</th>
          <th>Category Name</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="cate in categories" :key="cate.id">
          <td>{{ cate.id }}</td>
          <td>{{ cate.name }}</td>
          <td>
            <router-link :to="{ name: 'admin-category-edit', params: { id: cate.id } }">
              <Button class-name="update-btn">Update</Button>
            </router-link>
            <Button class-name="delete-btn" @click="handleDeleteCategory(cate.id)">Delete</Button>
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


export default {
  name: 'AdminCategoriesPage',
  components: {
    Button, Table
  },
  data() {
    return {
      categories: [],
      totalPages: 0
    }
  },
  mounted() {
    this.fetchCategories(this.$route?.query?.page, this.$route?.query?.per_page);
  },
  watch: {
    '$route.query.page': function (newPage) {
      this.fetchCategories(newPage, this.$route?.query?.per_page);
    },
    '$route.query.per_page': function (newPerPage) {
      this.fetchCategories(this.$route?.query?.page, newPerPage);
    }
  },

  methods: {
    handleDeleteCategory(cateId) {
      if (confirm('Are you sure you want to delete this category?')) {
        api.delete(PATHS.deleteCategory(cateId))
          .then(() => {
            alert('Category deleted successfully');
            let currentPage  = Number.parseInt(this.$route?.query?.page)
            let perPage = Number.parseInt(this.$route?.query?.per_page)
            if (currentPage > 1) {
              this.$router.push({ name: 'admin-categories', query: { page: 1, per_page: perPage } });
            }
            else
              this.fetchCategories(1, perPage);
          })
          .catch((e) => {
            let errorMessage = e.response?.data?.error
            alert(`Error deleting category: ${errorMessage}`);
          });
      }
    },
    fetchCategories(page = 1, perPage = 10) {
      api.get(PATHS.categories, {
        params: {
          page: page,
          per_page: perPage
        }
      })
        .then(response => {
          this.categories = response.data.categories
          this.totalPages = response.data.pagination.total_pages === 0 ? 1 : response.data.pagination.total_pages

          let currentPage = Number.parseInt(this.$route?.query?.page)
          let perPage = Number.parseInt(this.$route?.query?.per_page)
          if (currentPage > this.totalPages) {

            this.$router.push({ name: 'admin-categories', query: { page: this.totalPages, per_page: perPage } });
          }
        })
        .catch((e) => {
          let errorMessage = e.response?.data?.error
          console.error('Error fetching categories:', errorMessage);
        });
    },
    handleNewCategory() {
      this.$router.push({ name: 'admin-category-create' });
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

.create-category-btn {
  background-color: #008000;
  color: white;
  padding: 10px;
  margin-bottom: 20px;
  margin-left: 0;
  margin-right: 0;
}

.create-category-btn:hover {
  background-color: #016001;
}
</style>