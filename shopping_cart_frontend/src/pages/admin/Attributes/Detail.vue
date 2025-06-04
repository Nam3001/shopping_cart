<template lang="">
  <div class="container">
    <h1>Attribute detail</h1>

    <div>
      <b>Name: </b>
      <span>{{ attribute.name }}</span>
    </div>
    <div>
      <b>Values: </b>
      <ul class="list-attribute-values">
        <li v-for="(value) in this.attribute.attribute_values" :key="value.id"> {{ value.value }}</li>
      </ul>
    </div>
  </div>
</template>
<script>
import api from '@/services/api';
import PATHS from '@/services/paths';

export default {
  name: 'AdminAttributeDetailPage',
  data() {
    return {
      attribute: {},
    };
  },
  async mounted() {
    await this.fetchAttributeDetail();

    console.log(this.attribute.attribute_values);
  },
  methods: {
    async fetchAttributeDetail() {
      const attributeId = this.$route.params.id;
      try {
        let res = await api.get(PATHS.attributeInfo(attributeId))
        this.attribute = res.data;
      } catch (error) {
         console.error('Error fetching attribute detail:', error);
      }
    }
  },
}
</script>
<style scoped>
  .container {
    padding: 20px;
  }

  .list-attribute-values {
    padding: 0 30px;
  }
</style>