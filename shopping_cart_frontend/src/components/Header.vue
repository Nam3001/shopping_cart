<template>
  <header class="main-header">
    <div class="logo">🛍️ MyShop</div>
    <nav class="nav-links">
      <a href="#" class="nav-link">Trang chủ</a>
      <a href="#" class="nav-link">Sản phẩm</a>
      <a href="#" class="nav-link">Liên hệ</a>
    </nav>
  </header>
</template>

<script>
export default {
  name: "HeaderComponent"
};
</script>

<style scoped>
.main-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 30px;
  color: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 22px;
  font-weight: bold;
}

.nav-links {
  display: flex;
  gap: 20px;
}

.nav-link {
  color: #333;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;
}

.nav-link:hover {
  color: #f1c40f;
}
</style>
