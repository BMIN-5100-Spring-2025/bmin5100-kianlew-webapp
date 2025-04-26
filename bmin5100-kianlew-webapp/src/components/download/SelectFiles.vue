<!-- SelectFiles.vue -->
<script setup lang="ts">
import { computed } from 'vue';
import { useDropzone } from 'vue3-dropzone';
import { useMainStore } from '@/stores/mainStore';

const store = useMainStore();


function onDrop(acceptedFiles: File[]) {
  store.selectedFiles = acceptedFiles;
  store.status = store.statusOptions.FILES_SELECTED;
}

const { getRootProps, getInputProps, isDragActive } = useDropzone({
  onDrop,
});


const selectedFilesLabel = computed(() =>
  store.selectedFiles.length
    ? `${store.selectedFiles.length} file${store.selectedFiles.length === 1 ? '' : 's'} selected`
    : 'No files selected',
);
</script>

<template>
  <div class="select-files-wrapper">
    <div class="select-files-container" v-bind="getRootProps()">
      <input v-bind="getInputProps()" />
      <p>
        {{ isDragActive ? 'Drop the files here …' : 'Drag & drop files here, or click to select' }}
      </p>
    </div>

    <p class="selected-files-label">{{ selectedFilesLabel }}</p>
  </div>
</template>

<style scoped>
.select-files-wrapper {
  border: 1px solid grey;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.select-files-container {
  width: 240px;
  height: 120px;
  border: 2px dashed #999;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background 0.2s;
}

.select-files-container:hover {
  background: #f7f7f7;
}

.selected-files-label {
  margin-top: 0.5rem;
  font-weight: 500;
}
</style>
