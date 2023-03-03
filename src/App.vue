<template>
  <div class="header">
    <div class="title-container">
      Wordle
    </div>
  </div>
  <div class="main-wrapper">
    <div class="main-container">
      <RouterView />
    </div>
  </div>
</template>

<script setup lang="ts">
import { RouterView } from 'vue-router'
</script>

<style lang="scss">
  .header {
    height: 70px;
    background-color: #041D3D;
    color: white;
  }

  .title-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    font-size: 24px;
    font-weight: 600;
  }

  .main-wrapper {
    background-color: #DDDDDD;
    padding: 20px;
    height: calc(100vh - 70px);
  }
</style>
