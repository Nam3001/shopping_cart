<template lang="">
  <div class="container">
    <h1 class="heading">Attributes list</h1>
    <div style="text-align: right; margin-bottom: 20px;">
      <Button class-name="create-btn" @click="handleClickCreateNewAttribute">Create new Attribute</Button>
    </div>
    <TableComponent
      :total-pages="this.pagination.totalPages"
      :router-name="'admin-attributes'"
    >
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="attr in attributes" :key="attr.id">
          <td>{{ attr.id }}</td>
          <td>{{ attr.name }}</td>
          <td>
            <router-link :to="{ name: 'admin-attribute-edit', params: { id: attr.id } }">
              <Button class="update-btn">Update</Button>
            </router-link>
            <Button class-name="delete-btn" @click="handleDeleteAttribute(attr.id)">Delete</Button>
            <Button class-name="detail-attribute-btn" @click="handleClickDetailAttribute(attr.id)">Chi tiết</Button>
          </td>
        </tr>
      </tbody>
    </TableComponent>
  </div>
</template>
<script>
import Button from '@/components/Button.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';

export default {
  name: 'AdminAttributePage',
  components: {
    TableComponent: () => import('@/components/Table.vue'),
    Button
  },
  data() {
    return {
      attributes: [],
      pagination: {
        currentPage: 1,
        totalPages: 0,
        totalCount: 0,
      },
    };
  },
  async mounted() {
    try {
      await this.loadAttributes()
    } catch(e) {
      alert(`Không thể load danh sách attribute! ${e.message}`)
    }
  },
  methods: {
    async handleDeleteAttribute(attrId) {
      let confirmDelete = confirm("Bạn có chắc chắn xóa attribute này không?")
      if(!confirmDelete)
        return

      try {
        try {
          await api.delete(PATHS.deleteAttribute(attrId))
          alert("Xóa attribute thành công!")
        } catch(e) {
          let errorMessage = e.response?.data?.error
          alert("Delete failed: " + errorMessage)
        }
        await this.loadAttributes()
      } catch(e) {
        let errorMessage = e.response?.data?.error
        alert(`Không thể load attributes! ${errorMessage}`)
      }
    },
    handleClickDetailAttribute(attrId) {
      this.$router.push({ name: 'admin-attribute-detail', params: { id: attrId } });
    },
    handleClickCreateNewAttribute() {
      this.$router.push({ name: 'admin-attribute-new' });
    },
    async loadAttributes() {
      api.get(PATHS.attributes)
      .then(response => {
        this.attributes = response.data?.attributes || []
        this.pagination = {
          currentPage: response.data?.current_page || 1,
          totalPages: response.data?.last_page || 0,
          totalCount: response.data?.total || 0,
        };
      })
      .catch(error => {
        console.error('Error fetching attributes:', error);
      });
    }
  }
}
</script>
<style scoped>

.create-btn {
  background-color: #008000;
  padding: 10px;
  color: white;
}

.create-btn:hover {
  background-color: #026102;
}

.container {
  padding: 20px;
}

.heading {
  text-align: center;
  margin: 20px 0;
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

.detail-attribute-btn {
  background-color: #007bff;
}
.detail-attribute-btn:hover {
  background-color: #0056b3;
}
</style>