<script setup lang="ts">
import { fetchAuthSession } from 'aws-amplify/auth';
import {
  S3Client,
  GetObjectCommand,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { fromCognitoIdentityPool } from '@aws-sdk/credential-providers';
import { computed, ref, defineEmits } from 'vue';
import { useMainStore } from '@/stores/mainStore';


const REGION = 'us-east-1';
const IDENTITY_POOL_ID = 'us-east-1:6c006afe-1718-48c8-875f-51f7de84d8f7';
const BUCKET_NAME = 'bmin5100-kianlew';
const DOWNLOAD_PREFIX = 'output/';
const URL_EXPIRES_IN = 60 * 60;


const store = useMainStore();
const isDisabled = computed(() => !store.hasFiles());
const isDownloaded = ref(false);

const emit = defineEmits<{
  (e: 'download-complete'): void;
  (e: 'submit-processing'): void;
}>();


function makeSafeS3Key(str: string) {
  return str.replace(/[^a-z0-9]/gi, '_').toLowerCase();
}


async function startDownload() {
  try {
    const authSession = await fetchAuthSession();


    const poolResource = authSession.tokens!.accessToken!.payload.iss.replace(
      'https://',
      '',
    );
    const logins: Record<string, string> = {
      [poolResource]: authSession.tokens!.idToken!.toString(),
    };

    const s3Client = new S3Client({
      region: REGION,
      credentials: fromCognitoIdentityPool({
        identityPoolId: IDENTITY_POOL_ID,
        clientConfig: { region: REGION },
        logins,
      }),
    });


    for (const file of store.selectedFiles) {
      const key = `${DOWNLOAD_PREFIX}${makeSafeS3Key(file.name ?? file)}`;

      const url = await getSignedUrl(
        s3Client,
        new GetObjectCommand({ Bucket: BUCKET_NAME, Key: key }),
        { expiresIn: URL_EXPIRES_IN },
      );


      window.open(url, '_blank');
    }


    store.status = store.statusOptions.FILES_DOWNLOADED;
    isDownloaded.value = true;
    emit('download-complete');
  } catch (e) {
    console.error('[Download] Failed:', e);
  }
}


function submitProcessing() {
  if (!isDownloaded.value) {
    console.error('Files must be downloaded before submitting for processing.');
    return;
  }
  emit('submit-processing');
}
</script>

<template>
  <div class="download-wrapper">
    <button :disabled="isDisabled" @click="startDownload">
      Download Files
    </button>
    <button :disabled="!isDownloaded" @click="submitProcessing">
      Submit for Processing
    </button>
  </div>
</template>

<style scoped>
.download-wrapper {
  margin: 1rem 0;
  padding: 1rem;
  border: 1px solid grey;
  border-radius: 4px;
}

button {
  margin: 0.5rem;
  padding: 0.6rem 1.25rem;
  font-size: 1rem;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

button:hover:not(:disabled) {
  background-color: #0056b3;
}
</style>
