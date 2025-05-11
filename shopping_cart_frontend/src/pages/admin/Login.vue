<template>
  <LoginLogout>
    <form @submit.prevent="handleSubmit">
      <label for="username">Username:</label>
      <input type="text" name="username" id="username" v-model="loginData.username">
      <p class="error-message" v-if="errorMesssages.username.length > 0">{{ errorMesssages.username }}</p>
      <div class="seperator"></div>

      <label for="password">Password:</label> <br>
      <input type="password" name="password" id="password" v-model="loginData.password">
      <p class="error-message" v-if="errorMesssages.password.length > 0">{{ errorMesssages.password }}</p>
      <div class="seperator"></div>

      <input type="submit" :value="!loading ? 'Login now' : 'Logging...'" :disabled="loading" :class="{ loading }">
    </form>
  </LoginLogout>
</template>

<script>
import LoginLogout from '@/layouts/LoginLogout.vue'

import api from '@/services/api.js'
import PATHS from '@/services/paths';

import { object, string } from 'yup';

const loginSchema = object({
  username: string().required(),
  password: string().required().min(6),
})

export default {
  name: 'LoginPage',
  components: {
    LoginLogout,
  },
  methods: {
    handleSubmit() {
      this.errorMesssages.username = ''
      this.errorMesssages.password = ''

      loginSchema.validate(this.loginData, { abortEarly: false })
      .then(() => {
        this.loading = true;

        api.post(PATHS.login,{
          username: this.loginData.username, password: this.loginData.password
        })
        .then(response => {
          localStorage.setItem('access_token', response.data.access_token);
          localStorage.setItem('refresh_token', response.data.refresh_token);

          this.$router.replace('/admin')
        })
        .catch((e) => {
            this.loading = false;
            let errorMessage = e.response?.data?.error
            alert(errorMessage);
          })
      })
      .catch(err => {
          err.inner.forEach(err => {
            if(this.errorMesssages[err.path].length === 0) {
              this.errorMesssages[err.path] = err.message;
            }
          });
        })
    }
  },
  data() {
    return {
      loginData: {
        username: '',
        password: ''
      },
      errorMesssages: {
        username: '',
        password: ''
      },
      loading: false
    }
  },

}
</script>

<style scoped>
input[type=password],
input[type=text] {
  width: 100%;
  padding: 5px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 5px;
  height: 40px;
}

input[type=password]:hover,
input[type=text]:hover {
  border: 1px solid var(--submit-btn-color);
}

input[type=password]:focus,
input[type=text]:focus {
  border: 1px solid var(--submit-btn-color);
  outline: none;
}
.error-message {
  color: red;
  font-size: 12px;
  margin-top: -5px;
}

input[type=submit] {
  background-color: var(--submit-btn-color);
  color: white;
  padding: 15px 20px;
  margin: 8px 0;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  width: 100%;
  font-size: 16px;
}


.loading {
  opacity: 0.5;
}

.seperator {
  padding-bottom: 10px;
}
</style>