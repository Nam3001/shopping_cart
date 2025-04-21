<template>
  <AdminLayout>
    <router-view />
  </AdminLayout>
</template>
<script>
import AdminLayout from '@/layouts/AdminLayout.vue';
export default {
  name: 'HomePage',
  components: {
    AdminLayout,
  }
}
</script>
<style scoped></style>