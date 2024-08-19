import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: () => import('../views/home/index-view.vue')
    },
    {
      path: '/cors',
      name: 'CORS',
      component: () => import('../views/cors/index-view.vue')
    },
    {
      path: '/proxy',
      name: 'Proxy',
      component: () => import('../views/proxy/index-view.vue')
    },
    {
      path: '/jsonp',
      name: 'Jsonp',
      component: () => import('../views/jsonp/index-view.vue')
    },
    {
      path: '/post-message',
      name: 'PostMessage',
      component: () => import('../views/post-message/index-view.vue')
    },
    {
      path: '/document-domain',
      name: 'DocumentDomain',
      component: () => import('../views/document-domain/index-view.vue')
    },
    {
      path: '/window-name',
      name: 'WindowName',
      component: () => import('../views/window-name/index-view.vue')
    },
    {
      path: '/location-hash',
      name: 'LocationHash',
      component: () => import('../views/location-hash/index-view.vue')
    }
  ]
})

export default router
