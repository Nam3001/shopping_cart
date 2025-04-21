<template lang="">
  <input  :value="value" @input="$emit('input', $event.target.value)" v-bind="$attrs" />
</template>
<script>
export default {
  props: {
    value: String
  }
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

<!-- component cha sẽ dùng như này: -->
 <!-- <BaseInput v-model="model" /> => sẽ tương đương với: <BaseInput :value="model" @input="model = $event " />  -->