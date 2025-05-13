<template>
  <div>
    <Header></Header>
    <main>
      <slot></slot>
    </main>
  </div>
</template>

<script>
import Header from '@/components/Header.vue'

export default {
  name: 'WebLayout',
  components: {
    Header
  }
}
</script>
<style>
  main {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  }
</style>
