<script setup>
import { computed } from 'vue';
import { useDropzone } from 'vue3-dropzone';
import { useMainStore } from '@/stores/mainStore';

const store = useMainStore();

// FILE SELECT LOGIC
const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop });

function onDrop(acceptFiles, rejectReasons) {
  store.selectedFiles = acceptFiles || [];
  store.status = store.statusOptions.FILES_SELECTED;
}

const selectedFilesContent = computed(() => {
  const fileCount = store.selectedFiles?.length || 0;
  return fileCount > 0 ? `${fileCount} files selected` : 'No files selected';
});
</script>

<template>
  <div class="select-files-wrapper">
    <div v-bind="getRootProps()" class="select-files-container">
      <input v-bind="getInputProps()" />
      <p>Drag 'n' drop some files here, or click to select files</p>
    </div>
    <div>
      {{ selectedFilesContent }}
    </div>
  </div>
</template>

<style scoped>
.select-files-wrapper {
  border: 1px solid grey;
  padding: 8px;
  margin: 8px 0;
}

.select-files-container {
  width: 200px;
  height: 100px;
  border: 1px solid grey;
  padding: 8px;
}
</style>
