<script setup lang="ts">
import { computed } from 'vue';
import Status from '@/components/status/status.vue'
import Login  from '@/components/login/login.vue'
import SelectFiles from '@/components/download/SelectFiles.vue';
import DownloadComponent from '@/components/download/DownloadComponent.vue';
import { useMainStore } from '@/stores/mainStore';
import bannerImg from '@/assets/suicide.png'

const store = useMainStore();
const isLoggedIn = computed(
  () => store.status !== store.statusOptions.NONE,
);

const showSelectFiles = computed(() =>
  [
    store.statusOptions.LOGGED_IN,
    store.statusOptions.FILES_SELECTED,
    store.statusOptions.FILES_DOWNLOADED,
  ].includes(store.status),
);

const showDownload = computed(() =>
  [
    store.statusOptions.FILES_SELECTED,
    store.statusOptions.FILES_DOWNLOADED,
  ].includes(store.status),
);


const bannerImgUrl = bannerImg as string;
const thisYear     = new Date().getFullYear();
</script>

<template>
  <div class="dashboard">
    <!-- ── NAVBAR ── -->
    <nav class="main-nav">
      <ul class="nav-links">
        <li><a href="#">Solutions</a></li>
        <li><a href="#">Training</a></li>
        <li><a href="#">Resources</a></li>
        <li><a href="#">About Us</a></li>
      </ul>
    </nav>



     <section class="banner">
       <img :src="bannerImg" alt="Suicide Prevention Banner" />
     </section>

    <!-- ── RESOURCE CARDS ── -->
    <section class="outer">
      <div class="card-row">
        <article class="card">
          <h3>Safety Resources</h3>
          <p>In case of emergency, dial 911 or 222 - 684 - 5944</p>
        </article>

        <article class="card">
          <h3>Psychological Resources</h3>
          <p>Links to counselling, psychological support services.</p>
        </article>

        <article class="card">
          <h3>Educational Resources</h3>
          <p>Access training material and prevention tool-kits.</p>
        </article>
      </div>
    </section>

    <!-- ── INFO STRIPS ── -->
    <section class="outer">
      <div class="info-row">
        <article class="info primary">
          <h4>What is suicide?</h4>
          <p>Suicide is the act of intentionally causing one's own death through self-directed injurious behavior with the intent to die.</p>
        </article>

        <article class="info danger">
          <h4>Types</h4>
          <p>Include completed suicide (fatal self-harm with intent to die), attempted suicide (non-fatal self-harm with intent to die), and suicidal ideation (thoughts or plans without action)..</p>
        </article>

        <article class="info success">
          <h4>Seek Help!</h4>
          <p>If you or someone you know is affected, confidential help is available 24/7. You are not alone!.</p>
        </article>
      </div>
    </section>

     <!-- ── ADMIN FLOW ── -->
    <section class="outer admin">
      <h3>Download Latest Reports</h3>

      <Status class="admin-block" />

      <!-- 1️⃣  Login until authenticated -->
      <Login v-if="!isLoggedIn" class="admin-block" />

      <!-- 2️⃣  File picker stays visible while logged-in -->
      <SelectFiles v-if="showSelectFiles" class="admin-block" />

      <!-- 3️⃣  Download panel shows after at least one file is chosen -->
      <DownloadComponent v-if="showDownload" class="admin-block" />

    </section>

    <!-- ── FOOTER ── -->
    <footer>
      <span>&copy; {{ thisYear }} Copyright </span>
      <span>All Rights Reserved </span>
    </footer>
  </div>
</template>

<!-- ──────────  scoped styles  ────────── -->
<style scoped>
*{box-sizing:border-box;margin:0;padding:0}
ul{list-style:none}
button{border:0;background:none;cursor:pointer}
input,button,textarea,select{font:inherit}

/* colours */
:root{
  --blue-900:#0d1a7f; --blue-100:#e7efff; --grey-100:#f8f8f8;
  --danger:#d73737;   --success:#2e9e4f;
}

/* responsive base font */
html{font-size:clamp(110px,3.9vw+1.2rem,120px)}

/* wrapper */
.dashboard{
  min-height:100vh;width:100%;
  display:left;flex-direction:column;background:#fff;color:#212529;
  font-family:system-ui,-apple-system,'Segoe UI',Roboto,sans-serif
}


/* NAVBAR */
.main-nav{
  display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;
  padding:2.1rem 2.1 rem;gap:3.1rem
}
.brand{font-weight:1000}
.nav-links{display:flex;gap:3.1rem;flex-wrap:wrap;font-size:1.35rem}
.nav-links a{color:var(--blue-900);text-decoration:none}

/* HERO */
.hero{background:var(--blue-900);color:#fff;padding:0.1rem 2rem}
.hero h2{font-size:1.45rem;max-width:50rem;line-height:0.34;margin:0}
.date-label{color:var(--blue-100)}
.cta{margin-top:0 rem;display:inline-grid ;gap:1rem;justify-content:space-evenly}
.btn-primary{background:#fff;color:var(--blue-900);padding:.15rem 1.3rem;border-radius:1px;font-weight:800}
.btn-outline{border:2px solid #fff;color:#fff;padding:.3rem 1 .2rem;border-radius:4px;font-weight:600}

/* OUTER – full width with 1 cm left margin */
.outer{width:calc(80vw - 8cm);margin-left:0;padding:0rem}
/* GRID rows */
.card-row,.info-row{
  display:grid;gap:2rem;
  grid-template-columns:repeat(auto-fit,minmax(350px,1fr));
  padding:1.2rem 0
}

/* cards */
.card{border:1px solid #d0d0d0;border-radius:4px;padding:0.9rem;background:#fff}
.card h3{font-size:1.52rem;margin-bottom:.2rem}

/* strips */
.info{padding:1rem;border-left:6px solid;background:var(--grey-100);border-radius:4px}
.info h4{margin-bottom:.25rem;font-size:1.55rem}
.info.primary{border-color:var(--blue-900)}
.info.danger {border-color:var(--danger)}
.info.success{border-color:var(--success)}

/* admin */
.admin{padding:0.2rem 0;border-top:1px solid #d0d0d0;display:flex;flex-direction:column;gap:.1rem}
.admin h3{font-size:1.28rem;font-weight:600}
.admin-block{border:1px solid #d0d0d0;padding:0.9rem;border-radius:4px}

/* download button style */
.btn-container{display:flex;justify-content:center}
.btn-download{
  background:var(--blue-900);color:#fff;font-weight:600;
  padding:.45rem 0.6rem;border-radius:4px
}

/* footer */
footer {
  margin-top: 0.1rem;
  padding: 0.1rem 0.25rem;
  background: #f1f1f1;
  font-size: .85rem;
  display: flex;
  flex-wrap: wrap;
  gap: .1rem;
  justify-content: center;
}

</style>

<!-- keep background white -->
<style>html,body{background:#fff}</style>
