<template lang="">
  <input :value="value" @input="$emit('input', $event.target.value)" v-bind="$attrs" />
</template>
<script>
export default {
  props: ['value']
}

</script>
<style lang="css" scoped>
  input {
  width: 100%;
  padding: 0 10px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 3px;
  height: 40px;
}
</style>

<!-- usage: -->
 <!-- <BaseInput v-model="model" /> => corresponding: <BaseInput :value="model" @input="model = $event " />  -->