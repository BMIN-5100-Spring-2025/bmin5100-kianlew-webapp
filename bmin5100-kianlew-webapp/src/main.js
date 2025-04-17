// src/main.js
import { createApp } from 'vue';
import { createPinia } from 'pinia';
import { Amplify } from 'aws-amplify';
import App from './App.vue';
import VueECharts from 'vue-echarts'; // For charts
import 'echarts'; // Core ECharts library
import './assets/main.css';

const awsConfig = {
  Auth: {
    Cognito: {
      userPoolClientId: '1rskp96od6vbv5icbecm7qigu2',
      userPoolId: 'us-east-1_1YXxPxFDP',
      loginWith: {
        email: true,
        oauth: {
          domain: 'bmin5100-students.auth.us-east-1.amazoncognito.com',
          responseType: 'token',
        },
      },
    },
  },
};

Amplify.configure(awsConfig);

const app = createApp(App);
app.use(createPinia());
app.component('v-chart', VueECharts); // Register VueECharts globally
app.mount('#app');

