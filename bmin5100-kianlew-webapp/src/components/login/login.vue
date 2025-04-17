<script setup>
import { signIn, confirmSignIn, signOut, fetchAuthSession } from 'aws-amplify/auth'
import { ref } from 'vue'
import { useMainStore } from '@/stores/mainStore'

const store = useMainStore()

const input = ref({username:"", password:""})

const state = ref("LOGIN")

async function doLogin() {

  // We always try to sign out before signing back in.
  // This is a simple (and probably inefficient way) to
  // ensure we don't get an error if there already is a
  // logged in user.
  await signOut()

  // Login with Cognito --> expect to return token
  const response = await signIn({
    username: input.value.username,
    password: input.value.password,
    options: {
      authFlowType: "USER_PASSWORD_AUTH",
    },
  })

  // Check that response has a next-step of DONE
  switch (response.nextStep.signInStep) {
    case "CONFIRM_SIGN_IN_WITH_NEW_PASSWORD_REQUIRED":
      state.value = "NEW_PASSWORD"
    break;
    case "DONE":
      const session = await fetchAuthSession();
      const token = session?.tokens?.accessToken.toString();

      store.status = store.statusOptions.LOGGED_IN
      console.log(token)

      break;
  }

}

async function doConfirmLogin() {
  const response = await confirmSignIn({
    challengeResponse: input.value.password,
  })

  // Check that response has a next-step of DONE
  switch (response.nextStep.signInStep) {
    case "DONE":
      const session = await fetchAuthSession();
      const token = session?.tokens?.accessToken.toString();
      state.value = "LOGIN"

      store.status = store.statusOptions.LOGGED_IN
      console.log(token)

      break;
  }
}

</script>

<template>
  <div class="login-wrapper">
    <form v-if="state==='LOGIN'" name="login-form" >
      <div  class="mb-3">
        <label for="username">Username: </label>
        <input type="text" id="username" v-model="input.username" />
      </div>
      <div class="mb-3">
        <label for="password">Password: </label>
        <input type="password" id="password" v-model="input.password" />
      </div>
      <button class="btn btn-outline-dark" type="submit" @click.prevent = "doLogin()">
        Login
      </button>
    </form>
    <form v-if="state==='NEW_PASSWORD'" name="login-form" >
      <div class="mb-3">
        <label for="password">New Password: </label>
        <input type="password" id="password" v-model="input.password" />
      </div>
      <button class="btn btn-outline-dark" type="submit" @click.prevent = "doConfirmLogin()">
        Update Password
      </button>
    </form>
  </div>
</template>

<style scoped>
.login-wrapper {
  border: 1px solid black;
  padding: 8px;
  margin: 8px 0;
}
</style>
