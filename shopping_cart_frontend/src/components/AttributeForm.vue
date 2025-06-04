<template lang="">
  <div>
    <form @submit.prevent="handleSubmit">
      <div>
        <label>Name: </label>
        <BaseInput
          v-model="attribute.name"
          placeholder="Enter attribute name"
          type="text"
          class-name="input-name" />
        </div>
        <div>
          <div style="display: flex;" v-for="(attributeValueToAdd, index) in attributeValuesToAdd" :key="index">
            <BaseInput v-model="attributeValuesToAdd[index]" />
            <Button @click="handleRemoveAttributeValueToAdd(index)">Xóa</Button>
          </div>
        </div>
        <Button @click="handleAddClickAddValue">Add value</Button>
        <!-- <Button @click="showValues">show values</Button> -->
        <Button>Submit</Button>
    </form>
  </div>
</template>
<script>
export default {
  props: {
    type: {
      type: String,
      required: true,
      default: 'new'
    },
    onSubmit: {
      type: Function,
      required: true
    }
  },
  components: {
    Button: () => import('@/components/Button.vue'),
    BaseInput: () => import('@/components/BaseInput.vue'),
  },
  methods: {
    handleAddClickAddValue(e) {
      e.preventDefault();
      
      this.attributeValuesToAdd.push('')
    },
    // showValues() {
    //   console.log(this.attributeValuesToAdd);
    // },
    handleRemoveAttributeValueToAdd(index) {
      this.attributeValuesToAdd.splice(index, 1)
    },
    handleSubmit() {
      this.attribute.values = this.attributeValuesToAdd
      if(this.type === 'edit') {
        // this.attribute.attribute_values = this.attributeValuesToAdd
      }
      this.onSubmit(this.attribute)
    }
  },
  data() {
    return {
      attribute: {
        name: '',
        values: []
      },
      attributeValuesToAdd: []
    };
  },
}
</script>
<style scoped>
</style>