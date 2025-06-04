<template lang="">
  <div style="padding-left: 16px;">
    <h1 class="heading">Update Attribute</h1>
    <AttributeForm
      :type="'edit'"
      :currentAttribute="currentAttribute"
      :onSubmit="onSubmit"
      :attributeId="Number($route.params.id)"
    />
  </div>
</template>
<script>
import api from '@/services/api';
import PATHS from '@/services/paths';

export default {
  name: 'AdminEditAttributePage',
  components: {
    AttributeForm: () => import('@/components/AttributeForm.vue'),
  },
  data() {
    return {
      currentAttribute: null
    }
  },
  
  methods: {
    async onSubmit(attribute, id) {
      try {
        await api.patch(PATHS.updateAttribute(id), attribute)
        alert('update attribute successfully!')
        this.$router.push({ name: 'admin-attributes' });
      } catch(e) {
         let errorMessage = e.response?.data?.error
        alert("update attribute failed: " + errorMessage)
      }

    }
  },
}
</script>
<style scoped>
  .heading {
    text-align: center;
    margin: 20px 0;
  }
  
</style>