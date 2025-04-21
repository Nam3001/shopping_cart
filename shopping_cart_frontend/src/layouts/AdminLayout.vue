<template>
  <div id="app">
    <div class="main">
      <Sidebar :items="sidebarItems" />
      <main class="main-content">
        <header class="header">
          <UserInfo :logout-path="logoutPath" />
        </header>
        <section class="content">
          <slot></slot>
        </section>
      </main>
    </div>
  </div>
</template>

<script>
  import Sidebar from '@/components/Sidebar.vue'
  import UserInfo from '@/components/UserInfo.vue'
  export default {
    name: 'AdminLayout',
    components: {
      Sidebar,
      UserInfo
    },
    data() {
      return {
        sidebarItems: [
          { name: 'Products', path: '/admin/products' },
        ],
      }
    },
    props: {
      logoutPath: {
        type: String,
        default: '/auth/logout'
      }
    }
  }
</script>
<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}


body {
  font-family: Arial, sans-serif;
}

#app {
  height: 100vh;
}

/* Responsive */
@media (max-width: 768px) {
 
}
.main {
  display: flex;
  height: 100vh;
}

.main .main-content {
  flex-grow: 1;
  /* padding: 20px; */
}
.main-content .header {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 0 20px;
  box-shadow: rgba(99, 99, 99, 0.2) 0px 2px 8px 0px;
  height: var(--navbar-height);
}

</style>