import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useMainStore = defineStore('main', () => {
  const statusOptions = Object.freeze({
    NONE: 'No Status',
    LOGGED_IN: 'Logged In',
    FILES_SELECTED: 'Files Selected',
    FILES_DOWNLOADED: 'Files Downloaded',
    PROCESSING: 'Processing: Running Fargate Task',
    COMPLETED: 'Completed'
  });

  const selectedFiles = ref([])
  const status = ref(statusOptions.NONE)
  const jobID = ref(null)

  function hasFiles() {
    return selectedFiles.value.length > 0
  }

  return { statusOptions, selectedFiles, status, jobID, hasFiles  }
})
