
<script setup>
import { fetchAuthSession } from "aws-amplify/auth";
import { S3Client} from "@aws-sdk/client-s3"
import { useMainStore } from '@/stores/mainStore'
import { Upload } from "@aws-sdk/lib-storage"
import { fromCognitoIdentityPool } from "@aws-sdk/credential-providers"; // ES6 import
import { computed } from 'vue'

const store = useMainStore()
const isDisabled = computed(() => {
  return !store.hasFiles()
})

function makeSafeS3Key(string) {
  return string.replace(/[^a-z0-9]/gi, '_').toLowerCase();
}

// UPLOAD LOGIC
async function startUpload() {

  let logins = {}
  const authSession = await fetchAuthSession();
  const poolResource = authSession.tokens.accessToken.payload.iss.replace("https://","");
  logins[poolResource] = authSession.tokens.idToken.toString();

  // Iterate over the file-list and upload sequentially
  for (let value of store.selectedFiles) {
    try {

      const tags = "OrgId=" + "test_bmin5100"

      const filename = "test_bmin5100" + "/" + makeSafeS3Key(value.name)

      const s3_client = new S3Client({
        region: 'us-east-1',
        credentials: fromCognitoIdentityPool({
          identityPoolId: "us-east-1:6c006afe-1718-48c8-875f-51f7de84d8f7",
          clientConfig: {region: "us-east-1"},
          logins: logins
        })
      })

      const parallelUploads3 = new Upload({
        client: s3_client,
        queueSize: 4,
        leavePartsOnError: false,
        params: {
          Bucket: "template-project-data",
          Key: filename,
          Body: value,
          Tagging: tags
        }
      })

      parallelUploads3.on("httpUploadProgress", (progress) => {
        console.log(progress.loaded)
      });

      await parallelUploads3.done();

      store.status = store.statusOptions.FILES_UPLOADED

    } catch (e) {
      console.error(e);
    }
  }
}

</script>

<template>
  <div class="upload-wrapper">
    <button :disabled='isDisabled' @click="startUpload">Upload Files</button>
  </div>
</template>

<style scoped>
  .upload-wrapper {
    margin: 8px 0;
    padding: 8px;
    border: 1px solid grey;
  }
</style>
