<template>
  <div class="header">
    <div class="infolegale-logo">
      <router-link to="/">
        <div class="logo"></div>
      </router-link>
    </div>
  </div>
  <div class="main-wrapper">
    <div class="main-container">
      <RouterView />
    </div>
  </div>
</template>

<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>

<style lang="scss">
  .header {
    height: 70px;
    background-color: #041D3D;
    color: white;
  }

  .main-wrapper {
    background-color: #DDDDDD;
    padding: 20px;
    height: calc(100vh - 70px);
  }
</style>
