
<script setup lang="ts">
import { ref, computed } from 'vue';
import { fetchAuthSession } from 'aws-amplify/auth';
import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { fromCognitoIdentityPool } from '@aws-sdk/credential-providers';
import { useMainStore } from '@/stores/mainStore';

const REGION            = 'us-east-1';
const IDENTITY_POOL_ID  = 'us-east-1:6c006afe-1718-48c8-875f-51f7de84d8f7';
const BUCKET_NAME       = 'bmin5100-kianlew';
const URL_EXPIRES_IN    = 60 * 60;

const store         = useMainStore();
const isDownloading = ref(false);

const isDisabled = computed(
  () =>
    (store.selectedFiles as unknown as string[]).length === 0 ||
    isDownloading.value,
);

async function buildS3Client() {
  const session = await fetchAuthSession();
  const issuer  = session.tokens!.accessToken!.payload.iss.replace('https://', '');
  const logins  = { [issuer]: session.tokens!.idToken!.toString() };

  return new S3Client({
    region: REGION,
    credentials: fromCognitoIdentityPool({
      identityPoolId: IDENTITY_POOL_ID,
      clientConfig: { region: REGION },
      logins,
    }),
  });
}

async function startDownload() {
  if (isDisabled.value) return;
  isDownloading.value = true;

  try {
    const s3 = await buildS3Client();

    for (const key of store.selectedFiles as unknown as string[]) {
      const url = await getSignedUrl(
        s3,
        new GetObjectCommand({ Bucket: BUCKET_NAME, Key: key }),
        { expiresIn: URL_EXPIRES_IN },
      );
      window.open(url, '_blank');
    }

    store.status = store.statusOptions.FILES_DOWNLOADED;
  } catch (e) {
    console.error('[Download] failed:', e);
  } finally {
    isDownloading.value = false;
  }
}
</script>

<template>
  <div class="download-wrapper">
    <button :disabled="isDisabled" @click="startDownload">
      {{ isDownloading ? 'Opening files…' : 'Download Selected Files' }}
    </button>
  </div>
</template>

<style scoped>
.download-wrapper {
  border: 1px solid grey;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}
button {
  margin: 0.5rem;
  padding: 0.6rem 1.25rem;
  font-size: 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  background: #007bff;
  color: #fff;
}
button:disabled {
  background: #ccc;
  cursor: not-allowed;
}
button:hover:not(:disabled) {
  background: #0056b3;
}
</style>
