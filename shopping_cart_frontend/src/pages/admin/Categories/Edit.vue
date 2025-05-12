<template>
  <div>
    <CategoryForm :on-submit="handleSubmit" type="edit" />
  </div>
</template>

<script>
import CategoryForm from '@/components/CategoryForm.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
export default {
  name: 'AdminEditCategoryPage',
  components: {
    CategoryForm
  },
  methods: {
    handleSubmit: async function (categoryName) {
      const data = new FormData();
      data.append('name', categoryName);

      try {
         let cateId = this.$route.params.id;
        await api.patch(PATHS.updateCategory(cateId), data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Category update successfully');
        this.$router.replace({ name: 'admin-categories' });
      } catch (error) {
         const errorMessages = error.response?.data?.error || 'Unknown error';
        alert('Error updating category:' + errorMessages);
      }
    }
  }
}
</script>