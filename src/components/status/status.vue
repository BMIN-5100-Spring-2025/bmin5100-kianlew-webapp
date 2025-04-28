<script setup lang="ts">
import { computed } from 'vue';
import { useMainStore } from '@/stores/mainStore';

const store = useMainStore();

const colorMap: Record<string, string> = {
  'Logged In': '#0d6efd',
  'Files Selected': '#ffc107',
  'Files Downloaded': '#20c997',
  Processing: '#ff922b',
  Completed: '#198754',
};

const statusColor = computed(() => colorMap[store.status] ?? '#6c757d');
</script>

<template>
  <div class="status-wrapper">
    <strong>Current Status:</strong>
    <span
      class="status-badge"
      :style="{ backgroundColor: statusColor }"
      aria-live="polite"
    >
      {{ store.status }}
    </span>
  </div>
</template>

<style scoped>
.status-wrapper {
  margin: 8px 0;
  padding: 8px;
  border: 1px solid gray;
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.status-badge {
  display: inline-block;
  padding: 0 8px;
  border-radius: 4px;
  color: #fff;
}
</style>
