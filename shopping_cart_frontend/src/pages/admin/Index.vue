<template>
  <AdminLayout>
    <router-view />
  </AdminLayout>
</template>
<script>
import AdminLayout from '@/layouts/AdminLayout.vue';
export default {
  name: 'IndexAdmin',
  components: {
    AdminLayout,
  }
}
</script>
<style scoped></style>