<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>
<script>

export default {
  name: 'App'
}
</script>

<style>
:root {
  font-family: system-ui, Avenir, Helvetica, Arial, sans-serif;
  line-height: 1.5;
  font-weight: 400;

  --main-color: #2a2a2e;
  --main-hover-color: rgba(255, 255, 255, 0.1);
  --navbar-height: 60px;
  
  --submit-btn-color: #1570ef;
  --submit-btn-hover-color: #3485f8;
}
</style>
