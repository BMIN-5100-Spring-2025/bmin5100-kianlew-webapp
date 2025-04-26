<script setup lang="ts">
import {
  signIn,
  confirmSignIn,
  signOut,
  fetchAuthSession,
} from 'aws-amplify/auth';
import { ref } from 'vue';
import { useMainStore } from '@/stores/mainStore';

/**
 * Pinia store – exposes `status` and `statusOptions`
 */
const store = useMainStore();

interface Credentials {
  username: string;
  password: string;
}


const credentials = ref<Credentials>({ username: '', password: '' });
// LOGIN ➜ user must enter credentials
// NEW_PASSWORD ➜ user has to set a new password (Cognito challenge)
const state = ref<'LOGIN' | 'NEW_PASSWORD'>('LOGIN');
const loading = ref(false);
const error = ref<string | null>(null);


async function doLogin() {
  loading.value = true;
  error.value = null;

  try {
    // 1️⃣ Ensure we start with a clean session
    await signOut();

    // 2️⃣ Attempt Sign‑In
    const res = await signIn({
      username: credentials.value.username.trim(),
      password: credentials.value.password,
      options: { authFlowType: 'USER_PASSWORD_AUTH' },
    });

    switch (res.nextStep.signInStep) {
      case 'CONFIRM_SIGN_IN_WITH_NEW_PASSWORD_REQUIRED':
        state.value = 'NEW_PASSWORD';
        break;

      case 'DONE': {
        const session = await fetchAuthSession();
        const token = session?.tokens?.accessToken?.toString();

        if (token) {
          store.status = store.statusOptions.LOGGED_IN;
          console.info('[Auth] Access token:', token);
        }

        // housekeeping
        credentials.value.password = '';
        break;
      }

      default:
        error.value = 'Unexpected authentication step. Please try again.';
    }
  } catch (e: any) {
    error.value = e.message || 'Login failed. Please check your credentials.';
  } finally {
    loading.value = false;
  }
}

async function doConfirmLogin() {
  loading.value = true;
  error.value = null;

  try {
    const res = await confirmSignIn({
      challengeResponse: credentials.value.password,
    });

    if (res.nextStep.signInStep === 'DONE') {
      const session = await fetchAuthSession();
      const token = session?.tokens?.accessToken?.toString();

      if (token) {
        store.status = store.statusOptions.LOGGED_IN;
        console.info('[Auth] Access token:', token);
      }

      // Reset back to login state
      state.value = 'LOGIN';
      credentials.value.password = '';
    }
  } catch (e: any) {
    error.value = e.message || 'Unable to update password.';
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <div class="login-wrapper">
    <!-- LOGIN FORM -->
    <form v-if="state === 'LOGIN'" class="login-form" @submit.prevent="doLogin">
      <div class="mb-3">
        <label for="username">Username:</label>
        <input
          v-model="credentials.username"
          id="username"
          type="text"
          autocomplete="username"
          required
        />
      </div>

      <div class="mb-3">
        <label for="password">Password:</label>
        <input
          v-model="credentials.password"
          id="password"
          type="password"
          autocomplete="current-password"
          required
        />
      </div>

      <button class="btn btn-outline-dark" type="submit" :disabled="loading">
        {{ loading ? 'Logging in…' : 'Login' }}
      </button>
    </form>

    <form
      v-else
      class="login-form"
      @submit.prevent="doConfirmLogin"
    >
      <div class="mb-3">
        <label for="newPassword">New Password:</label>
        <input
          v-model="credentials.password"
          id="newPassword"
          type="password"
          autocomplete="new-password"
          required
        />
      </div>

      <button class="btn btn-outline-dark" type="submit" :disabled="loading">
        {{ loading ? 'Updating…' : 'Update Password' }}
      </button>
    </form>

    <p v-if="error" class="error-msg">{{ error }}</p>
  </div>
</template>

<style scoped>
.login-wrapper {
  border: 1px solid #d0d0d0;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 1px;
}

.mb-3 {
  margin-bottom: 0.55rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.error-msg {
  color: var(--danger, #d73737);
  margin-top: 0.75rem;
}
</style>
