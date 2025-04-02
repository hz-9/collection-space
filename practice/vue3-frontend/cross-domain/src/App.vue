<script setup lang="ts">
import { RouterLink, RouterView, useRouter } from 'vue-router'

import MainContent from './components/main-content.vue'

const router = useRouter()

const handleToHome = () => {
  router.push({ name: 'Home' })
}
</script>

<template>
  <header>
    <img
      alt="HZ-9"
      class="logo"
      src="@/assets/LOGO-opacity.png"
      width="125"
      height="125"
      @click="handleToHome"
    />
    <!-- <img alt="HZ-9" class="logo" src="@/assets/logo.jpg" width="125" height="125" @click="handleToHome"/> -->

    <div class="wrapper">
      <main-content />

      <nav>
        <RouterLink to="/cors">CORS</RouterLink>
        <RouterLink to="/proxy">Proxy</RouterLink>
        <RouterLink to="/jsonp">Jsonp</RouterLink>
        <RouterLink to="/post-message">postMessage</RouterLink>
        <RouterLink to="/document-domain">document.domain</RouterLink>
        <RouterLink to="/window-name">window.name</RouterLink>
        <RouterLink to="/location-hash">location.hash</RouterLink>
      </nav>
    </div>
  </header>

  <RouterView />
</template>

<style scoped>
header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
  cursor: pointer;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
}
</style>
