<template>
  <div class="content-container">
    <h1 class="heading">Units list</h1>
    <div class="create-btn-container">
      <Button class-name="create-unit-btn" @click="handleNewUnit">Create new unit</Button>
    </div>
    <Table :total-pages="this.totalPages">
      <thead>
        <tr>
          <th>ID</th>
          <th>Unit Name</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="unit in units" :key="unit.id">
          <td>{{ unit.id }}</td>
          <td>{{ unit.unit_name }}</td>
          <td>
            <router-link :to="{ name: 'admin-unit-edit', params: { id: unit.id } }">
              <Button class-name="update-btn">Update</Button>
            </router-link>
            <Button class-name="delete-btn" @click="handleDeleteUnit(unit.id)">Delete</Button>
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
  name: 'AdminUnitsPage',
  components: {
    Button, Table
  },
  data() {
    return {
      units: [],
      totalPages: 0
    }
  },
  mounted() {
    this.fetchUnits(this.$route?.query?.page, this.$route?.query?.per_page);
  },
  watch: {
    '$route.query.page': function (newPage) {
      this.fetchUnits(newPage, this.$route?.query?.per_page);
    },
    '$route.query.per_page': function (newPerPage) {
      this.fetchUnits(this.$route?.query?.page, newPerPage);
    }
  },

  methods: {
    handleDeleteUnit(cateId) {
      if (confirm('Are you sure you want to delete this unit?')) {
        api.delete(PATHS.deleteUnit(cateId))
          .then(() => {
            alert('Unit deleted successfully');
            let currentPage  = Number.parseInt(this.$route?.query?.page)
            let perPage = Number.parseInt(this.$route?.query?.per_page)
            if (currentPage > 1) {
              this.$router.push({ name: 'admin-units', query: { page: 1, per_page: perPage } });
            }
            else
              this.fetchUnits(1, perPage);
          })
          .catch((e) => {
            let errorMessage = e.response?.data?.error
            alert(`Error deleting unit: ${errorMessage}`);
          });
      }
    },
    fetchUnits(page = 1, perPage = 10) {
      api.get(PATHS.units, {
        params: {
          page: page,
          per_page: perPage
        }
      })
        .then(response => {
          this.units = response.data.units
          this.totalPages = response.data.pagination.total_pages === 0 ? 1 : response.data.pagination.total_pages

          let currentPage = Number.parseInt(this.$route?.query?.page)
          let perPage = Number.parseInt(this.$route?.query?.per_page)
          if (currentPage > this.totalPages) {

            this.$router.push({ name: 'admin-units', query: { page: this.totalPages, per_page: perPage } });
          }
        })
        .catch((e) => {
          let errorMessage = e.response?.data?.error
          console.error('Error fetching units:', errorMessage);
        });
    },
    handleNewUnit() {
      this.$router.push({ name: 'admin-unit-create' });
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

.create-unit-btn {
  background-color: #008000;
  color: white;
  padding: 10px;
  margin-bottom: 20px;
  margin-left: 0;
  margin-right: 0;
}

.create-unit-btn:hover {
  background-color: #016001;
}
</style>