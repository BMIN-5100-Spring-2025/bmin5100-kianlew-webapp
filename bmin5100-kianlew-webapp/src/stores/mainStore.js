// src/stores/mainStore.js
import { defineStore } from 'pinia';

export const useMainStore = defineStore('main', {
  state: () => ({
    selectedFiles: [],
    status: null,
    statusOptions: {
      FILES_SELECTED: 'files_selected',
    },
    counter: 0,
  }),
  actions: {
    setSelectedFiles(files) {
      this.selectedFiles = files || [];
    },
    setStatus(status) {
      this.status = status;
    },
  },
});
