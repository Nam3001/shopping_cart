<template>
  <AdminLayout logout-path="/auth/logout"></AdminLayout>
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