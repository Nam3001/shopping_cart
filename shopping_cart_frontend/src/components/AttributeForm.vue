<template lang="">
  <div>
    <form @submit.prevent="handleSubmit">
      <div>
        <label>Name: </label>
        <BaseInput
          v-model="attribute.name"
          placeholder="Enter attribute name"
          type="text"
          class-name="input-name"
          ref="nameInput"
        />
        </div>
        <div>
          <div style="display: flex;" v-for="(attributeValueToAdd, index) in attributeValuesToAdd" :key="index" ref="inputs">
            <BaseInput v-if="type === 'new'" v-model="attributeValuesToAdd[index]"/>
            <BaseInput v-else v-model="attributeValuesToAdd[index].value" required/>
            <Button @click="handleRemoveAttributeValueToAdd(index, attributeValueToAdd)">Xóa</Button>
          </div>
        </div>
        <Button @click="handleAddClickAddValue">Add value</Button>
        <!-- <Button @click="showValues">show values</Button> -->
        <Button>Submit</Button>
    </form>
  </div>
</template>
<script>
import api from '@/services/api';
import PATHS from '@/services/paths';

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
    },
    attributeId: {
      type: Number,
      required: false
    }
  },
  components: {
    Button: () => import('@/components/Button.vue'),
    BaseInput: () => import('@/components/BaseInput.vue'),
  },
  data() {
    return {
      attribute: {
        name: '',
        values: []
      },
      attributeValuesToAdd: [],
      attributeValuesToDelete: []
    };
  },
  async mounted() {
    if(this.type === 'edit' && this.attributeId) {
      try {
        let res = await api.get(PATHS.attributeInfo(this.attributeId))
        let currentAttribute = res.data
        this.attribute.name = currentAttribute.name
        this.attributeValuesToAdd = currentAttribute.attribute_values
      } catch(e) {
        alert('Không thể load attribute, message: ' + e.response?.data?.error)
      }
    }
  },
  methods: {
    handleAddClickAddValue(e) {
      e.preventDefault();
      
      if(this.type === 'edit') {
        this.attributeValuesToAdd.push({value: ''})
      } else {
        this.attributeValuesToAdd.push('')
      }
    },
    handleRemoveAttributeValueToAdd(index, attr) {
      if(this.type === 'edit') {
        if(attr.id) {
          this.attributeValuesToDelete.push(attr.id)
        }
      }
      this.attributeValuesToAdd.splice(index, 1)
    },
    handleSubmit() {
      this.attribute.values = this.attributeValuesToAdd
      if(this.type === 'edit') {
        this.attribute.values_to_delete = this.attributeValuesToDelete
        this.onSubmit(this.attribute, this.attributeId)
      } else {
        this.onSubmit(this.attribute)
      }
    }
  },
  updated() {
    if(this.attributeValuesToAdd.length <= 0) return

    let inputRef = this.$refs?.inputs?.[this.attributeValuesToAdd.length - 1]?.firstChild
    if(inputRef) {
      inputRef.focus()
    }
  }
}
</script>
<style scoped>
</style>