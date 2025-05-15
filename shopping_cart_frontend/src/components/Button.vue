<template>
  <button :class="className" :style="customStyle" @click="handleClick" v-bind="$attrs">
    <slot></slot>
  </button>
</template>

<script>
export default {
  name: 'ButtonComponent',
  props: {
    customStyle: {
      type: Object,
      default: () => ({})
    },
    className: {
      type: String,
      default: ''
    }
  },
  methods: {
    handleClick(e) {
      this.$emit('click', e)
    }
  }
}
</script>

<style scoped>
button {
  padding: 5px 10px;
  margin: 5px;
  border: none;
  border-radius: 5px;
  background-color: #fb275e;
  color: white;
  cursor: pointer;
}
button:hover {
  background-color: #c42a52;
}
</style>