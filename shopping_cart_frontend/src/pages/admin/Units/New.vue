<template>
  <div>
    <UnitForm :on-submit="handleSubmit" type="new" />
  </div>
</template>

<script>
import UnitForm from '@/components/UnitForm.vue';
import api from '@/services/api';
import PATHS from '@/services/paths';
export default {
  name: 'AdminNewUnitPage',
  components: {
    UnitForm
  },
  methods: {
    handleSubmit: async function (unitName) {
      const data = new FormData();
      data.append('unit_name', unitName);

      try {
        await api.post(PATHS.units, data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })

        alert('Unit created successfully');
        this.$router.replace({ name: 'admin-units' });
      } catch (error) {
         const errorMessages = error.response?.data?.error || 'Unknown error';
        alert('Error creating unit:' + errorMessages);
      }
    }
  }
}
</script>