<template>
  <div class="user-info" @click="toggleDropdown">
    <div class="user-info-display">
      <span>Admin</span>
      <img src="https://i.pravatar.cc/32" alt="Avatar">
    </div>
    <div class="dropdown-menu" id="dropdown">
      <div class="dropdown-item">Profile</div>
      <div class="dropdown-item">Settings</div>
      <div @click="handleLogout" class="dropdown-item">Logout</div>
    </div>
  </div>
</template>
<script>
// import api from '@/services/api.js'
import logoutUser from '@/utils/logoutUser';

  export default {
    props: {
      logoutPath: String
    },
    methods: {
      toggleDropdown() {
        const dropdown = document.getElementById('dropdown');
        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
      },
      handleLogout() {
        logoutUser(this.logoutPath).then(() => {
          this.$router.replace({ name: 'login' });
        })
      }
    }
  }
</script>
<style scoped>

.user-info {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.user-info span {
  font-size: 0.95rem;
}

.user-info img {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
}

.user-info:hover {
  cursor: pointer;
}

.user-info-display {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}


.dropdown-menu {
  display: none;
  position: absolute;
  right: 10px;
  top: 70px;
  border-radius: 6px;
  min-width: 120px;
  z-index: 100;
  box-shadow: rgba(99, 99, 99, 0.2) 0px 2px 8px 0px;
  overflow: hidden;
  background-color: #fff;;
}

.dropdown-menu .dropdown-item {
  display: block;
  padding: 0.5rem 1rem;
  color: #333;
  text-decoration: none;
  transition: background 0.2s ease;
}

.dropdown-menu .dropdown-item:hover {
  background-color: rgb(0, 0, 0, 0.1);
}


</style>