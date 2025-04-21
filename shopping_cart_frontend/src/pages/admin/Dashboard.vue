<template>
  <div id="container">
    <h1>dashboard</h1>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'DashboardPage',
  data() {
    return {
      email: '',
      password: '',
      errorMessage: ''
    }
  },

}
</script>

<style>
</style>