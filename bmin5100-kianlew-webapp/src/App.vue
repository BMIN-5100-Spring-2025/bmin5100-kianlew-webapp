<script setup>
import Dashboard from '@/components/Dashboard.vue';
/*
import SelectFiles from '@/components/upload/selectfiles.vue';
import UploadComponent from '@/components/upload/uploadcomponent.vue';
*/
import Login from '@/components/login/login.vue';
import Status from '@/components/status/status.vue';
import PennsieveLogo from '@/components/icons/IconPennsieveLogo.vue';
</script>

<template>
  <main>
    <div class="wrapper">
      <pennsieve-logo class="logo" />
      <status />
      <login />
      <select-files />
      <upload-component />
      -->

      <Dashboard />
    </div>
  </main>
</template>

<style scoped>
main {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

.wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  padding: 20px;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  .wrapper {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: flex-start;
  }
  .logo {
    margin: 0 2rem 0 0;
  }
}
</style>
