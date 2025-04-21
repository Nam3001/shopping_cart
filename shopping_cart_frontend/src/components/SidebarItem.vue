<template>
  <li>
    <router-link :to="to" class="sidebar-item">
      {{ name }}
    </router-link>
  </li>
</template>

<script>

export default {
  props: {
    name: {
      type: String,
      required: true
    },
    to: {
      type: String,
      required: true
    }
  }
}
</script>
<style scoped>

li {
  width: 100%;
  display: flex;
}
.sidebar-item {
  color: #fff;
  padding: 10px;
  padding-left: 20px;
  width: 100%;
  text-decoration: none;
}



.sidebar-item:hover {
  background-color: var(--main-hover-color);
  cursor: pointer;
}
</style>