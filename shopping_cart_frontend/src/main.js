import Vue from 'vue'

import App from './App.vue'
import router from './router/index.js'

import VueQuillEditor from 'vue-quill-editor'

// import styles
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'


Vue.use(VueQuillEditor)

new Vue({
  render: h => h(App),
  router,
}).$mount('#app')
