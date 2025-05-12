<template>
  <div>
    <UnitForm :on-submit="handleSubmit" type="edit" />
  </div>
</template>

<script>
import UnitForm from '@/components/UnitForm.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
export default {
  name: 'AdminEditUnitPage',
  components: {
    UnitForm
  },
  methods: {
    handleSubmit: async function (unitName) {
      const data = new FormData();
      data.append('unit_name', unitName);

      try {
         let unitId = this.$route.params.id;
        await api.patch(PATHS.updateUnit(unitId), data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Unit update successfully');
        this.$router.replace({ name: 'admin-units' });
      } catch (error) {
         const errorMessages = error.response?.data?.error || 'Unknown error';
        alert('Error updating unit:' + errorMessages);
      }
    }
  }
}
</script>