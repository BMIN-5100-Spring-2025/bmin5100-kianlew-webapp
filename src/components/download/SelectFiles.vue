<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { fetchAuthSession } from 'aws-amplify/auth';
import {
  S3Client,
  ListObjectsV2Command,
  _Object as S3Object,
} from '@aws-sdk/client-s3';
import { fromCognitoIdentityPool } from '@aws-sdk/credential-providers';
import { useMainStore } from '@/stores/mainStore';

const REGION            = 'us-east-1';
const IDENTITY_POOL_ID  = 'us-east-1:6c006afe-1718-48c8-875f-51f7de84d8f7';
const BUCKET_NAME       = 'bmin5100-kianlew';
const PREFIX            = 'output/';

const store       = useMainStore();
const objects     = ref<S3Object[]>([]);
const loading     = ref(false);
const error       = ref<string | null>(null);

async function buildS3Client() {
  const session      = await fetchAuthSession();
  const issuer       = session.tokens!.accessToken!.payload.iss.replace('https://', '');
  const logins       = { [issuer]: session.tokens!.idToken!.toString() };

  return new S3Client({
    region: REGION,
    credentials: fromCognitoIdentityPool({
      identityPoolId: IDENTITY_POOL_ID,
      clientConfig: { region: REGION },
      logins,
    }),
  });
}

async function loadObjects() {
  loading.value = true;
  error.value   = null;

  try {
    const s3  = await buildS3Client();
    const res = await s3.send(
      new ListObjectsV2Command({ Bucket: BUCKET_NAME, Prefix: PREFIX }),
    );
    objects.value = res.Contents ?? [];
  } catch (e: any) {
    error.value = e.message ?? 'Unable to list S3 objects';
  } finally {
    loading.value = false;
  }
}

function toggle(key: string) {
  const arr = store.selectedFiles as unknown as string[];
  const idx = arr.indexOf(key);
  if (idx === -1) arr.push(key);
  else arr.splice(idx, 1);

  store.status = store.statusOptions.FILES_SELECTED;
}

function isChecked(key: string) {
  return (store.selectedFiles as unknown as string[]).includes(key);
}

onMounted(loadObjects);
</script>

<template>
  <div class="select-wrapper">
    <h4>Select files from S3</h4>
    <p v-if="loading">Loading…</p>
    <p v-else-if="error" class="err">{{ error }}</p>

    <ul v-else class="file-list">
      <li v-for="obj in objects" :key="obj.Key">
        <label>
          <input
            type="checkbox"
            :value="obj.Key"
            :checked="isChecked(obj.Key!)"
            @change="toggle(obj.Key!)"
          />
          {{ obj.Key?.replace(PREFIX, '') }}
        </label>
      </li>
    </ul>

    <p v-if="objects.length === 0 && !loading">No files found.</p>
  </div>
</template>

<style scoped>
.select-wrapper { border:1px solid grey; padding:1rem; margin:1rem 0; border-radius:4px; }
.file-list      { list-style:none; padding:0; margin:0.5rem 0 0; }
.file-list li   { margin-bottom:0.25rem; }
.err            { color:#d73737; font-weight:600; }
</style>
