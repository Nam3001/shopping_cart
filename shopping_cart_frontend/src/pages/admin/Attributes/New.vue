<template lang="">
  <div>
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
      // this.$router.push({ name: 'admin-attributes' });
      // console.log('Attribute submitted:', attribute);
      try {
        let res = await api.post(PATHS.createAttribute, attribute)
        alert('add new attribute successfully!') 
      } catch(e) {
         let errorMessage = e.response?.data?.error
        alert("Logout failed: " + errorMessage)
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