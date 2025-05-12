<template>
  <div>
    <CategoryForm :on-submit="handleSubmit" type="new" />
  </div>
</template>

<script>
import CategoryForm from '@/components/CategoryForm.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
export default {
  name: 'AdminNewCategoryPage',
  components: {
    CategoryForm
  },
  methods: {
    handleSubmit: async function (categoryName) {
      const data = new FormData();
      data.append('name', categoryName);

      try {
        await api.post(PATHS.categories, data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Category created successfully');
        this.$router.replace({ name: 'admin-categories' });
      } catch (error) {
         const errorMessages = error.response?.data?.error || 'Unknown error';
        alert('Error creating category:' + errorMessages);
      }
    }
  }
}
</script>