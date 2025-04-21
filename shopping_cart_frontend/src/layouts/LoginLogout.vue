<template>
  <div class="container">
    <div id="sub-container">
    <h1 class="title">Login to your account</h1>
    <slot></slot>
  </div>
  </div>
</template>

<script>

export default {
  data() {
    return {
      email: '',
      password: '',
      errorMessage: ''
    }
  },

}
</script>

<style scoped>
.container {
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #EEE;
}

.title {
  width: 100%;
  text-align: center;
  margin-top: 0;
  margin-bottom: 20px;
}


body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
}

#sub-container {
  background-color: #FFF;
  padding: 30px 50px;
  width: 100%;
  border-radius: 15px;
}

@media screen and (min-width: 768px) {
  #sub-container {
    width: 540px;
  }
  
}


</style>