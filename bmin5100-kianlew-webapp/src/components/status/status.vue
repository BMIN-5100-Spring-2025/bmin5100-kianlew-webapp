<script setup>
import { useMainStore } from '@/stores/mainStore.js'
const store = useMainStore()

</script>

<template>
  <div class="status_wrapper">
    <div>
      Current Status:
    </div>
    <div class="status">
      {{store.status}}
    </div>

  </div>

</template>

<style scoped>
.status_wrapper {
  margin: 8px 0;
  padding: 8px;
  border: 1px solid gray;
}

.status {
  color: green;
  background: lightblue;
  padding: 0 8px;
}

</style>
