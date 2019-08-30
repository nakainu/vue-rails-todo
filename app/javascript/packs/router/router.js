import Vue from 'vue/dist/vue.esm.js'
import VueRouter from 'vue-router'
import Index from '../components/index.vue'
import Search from '../components/search.vue'
import List from '../components/list.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: Index },
    { path: '/search', component: Search },
    { path: '/list/:id', component: List },
  ],
})
