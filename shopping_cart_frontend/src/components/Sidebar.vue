<template>
  <aside class="sidebar">
    <div class="sidebar-header">
      <h2 @click="goToHome">Admin Panel</h2>
    </div>
    <ul>
      <SidebarItem v-for="(item, index) in items" :key="index" :name="item.name" :to="item.path" />
    </ul>
  </aside>
</template>

<script>
import SidebarItem from '@/components/SidebarItem.vue'
export default {
  name: 'SidebarComponent',
  props: {
    items: {
      type: Array,
      default: () => []
    }
  },
  components: {
    SidebarItem
  },
  methods: {
    goToHome() {
      this.$router.push({name: 'admin-home'})
    }
  }
}
</script>

<style scoped>
.sidebar {
  flex-basis: 230px;
  background-color: var(--main-color);
  padding: 10px 0;
}

.sidebar-header h2 {
  padding: 10px 20px;
  color: #fff;
  cursor: pointer;
}

.sidebar ul {
  padding: 10px 0;
}
</style>