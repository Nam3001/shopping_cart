<template lang="">
  <div style="padding-left: 16px;">
    <h1 class="heading">Create New Attribute</h1>
    <AttributeForm
      :type="'new'"
      :onSubmit="onSubmit"
    />
  </div>
</template>
<script>
import api from '@/services/api';
import PATHS from '@/services/paths';

export default {
  name: 'AdminNewAttributePage',
  components: {
    AttributeForm: () => import('@/components/AttributeForm.vue'),
  },
  methods: {
    async onSubmit(attribute) {
      try {
        await api.post(PATHS.createAttribute, attribute)
        alert('add new attribute successfully!')
        this.$router.push({ name: 'admin-attributes' });
      } catch(e) {
         let errorMessage = e.response?.data?.error
        alert("add new attribute failed: " + errorMessage)
      }
      
    },
  },
}
</script>
<style scoped>
  .heading {
    text-align: center;
    margin: 20px 0;
  }
  
</style>