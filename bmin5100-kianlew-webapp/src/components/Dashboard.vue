<template>
  <div class="dashboard">
    <h1>Data Analytics Dashboard</h1>
    <div class="filters">
      <Dropdown
        label="Age Group (CATAG6)"
        :options="catag6Options"
        v-model="filters.CATAG6"
        @update:value="updateFilters"
      />
      <Dropdown
        label="Sex (IRSEX)"
        :options="irsexOptions"
        v-model="filters.IRSEX"
        @update:value="updateFilters"
      />
      <Dropdown
        label="Race (NEWRACE2)"
        :options="newrace2Options"
        v-model="filters.NEWRACE2"
        @update:value="updateFilters"
      />
      <Dropdown
        label="Education (EDUHIGHCAT)"
        :options="eduhighcatOptions"
        v-model="filters.EDUHIGHCAT"
        @update:value="updateFilters"
      />
      <Dropdown
        label="Year (YEAR)"
        :options="yearOptions"
        v-model="filters.YEAR"
        @update:value="updateFilters"
      />
      <Dropdown
        label="Intention"
        :options="intentionOptions"
        v-model="filters.Intention"
        @update:value="updateFilters"
      />
      <Dropdown
        label="Reasons"
        :options="reasonsOptions"
        v-model="filters.REASONS"
        @update:value="updateFilters"
      />
    </div>
    <Chart :data="chartData" />
  </div>
</template>

<script>
import axios from 'axios';
import Dropdown from './Dropdown.vue';
import Chart from './Chart.vue';

export default {
  name: 'Dashboard',
  components: {
    Dropdown,
    Chart,
  },
  data() {
    return {
      filters: {
        CATAG6: '',
        IRSEX: '',
        NEWRACE2: '',
        EDUHIGHCAT: '',
        YEAR: '',
        Intention: '',
        REASONS: '',
      },
      chartData: [],
      catag6Options: [
        { value: '2', label: '18-25' },
        { value: '3', label: '26-34' },
        { value: '4', label: '35-49' },
        { value: '5', label: '50+' },
      ],
      irsexOptions: [
        { value: '1', label: 'Male' },
        { value: '2', label: 'Female' },
      ],
      newrace2Options: [
        { value: '1', label: 'White' },
        { value: '2', label: 'Black/African American' },
        { value: '3', label: 'Native American' },
        { value: '4', label: 'Native Hawaiian/Pacific Islander' },
        { value: '5', label: 'Asian' },
        { value: '6', label: 'More than one race' },
        { value: '7', label: 'Hispanic' },
      ],
      eduhighcatOptions: [
        { value: '1', label: 'Less than high school' },
        { value: '2', label: 'High school graduate' },
        { value: '3', label: 'Some college' },
        { value: '4', label: 'College graduate' },
      ],
      yearOptions: Array.from({ length: 2023 - 2015 + 1 }, (_, i) => ({
        value: (2015 + i).toString(),
        label: (2015 + i).toString(),
      })),
      intentionOptions: [
        { value: 'IRSUICTHNK', label: 'Thought of Suicide' },
        { value: 'IRSUITRYYR', label: 'Tried Suicide' },
        { value: 'IRSUIPLANYR', label: 'Planned Suicide' },
      ],
      reasonsOptions: [
        { value: 'MHNTENFCV', label: 'Enough Coverage' },
        { value: 'MHNTFFLKE', label: 'Felt Like It' },
        { value: 'MHNTPROBS', label: 'Problems' },
        { value: 'MHNTTIME', label: 'Time' },
        { value: 'MHNTINSCV', label: 'Insurance Coverage' },
        { value: 'MHNTWHER', label: 'Where to Go' },
        { value: 'MHNTNOHLP', label: 'No Help Needed' },
        { value: 'MHNTCOST', label: 'Cost' },
        { value: 'MHNTHNDL', label: 'Handle on Own' },
        { value: 'MHNTFORCE', label: 'Forced' },
        { value: 'MHNTCONSQ', label: 'Consequences' },
        { value: 'MHNTPRIV', label: 'Privacy' },
        { value: 'MHNTPTHNK', label: 'Others Think' },
      ],
    };
  },
  methods: {
    // src/components/Dashboard.vue (snippet of updateFilters method)
    async updateFilters() {
      // Build query string from filters
      const query = Object.entries(this.filters)
        .filter(([_, value]) => value !== '')
        .map(([key, value]) => `${key}=${value}`)
        .join('&');

      try {
        // Fetch data from the Shiny API
        const response = await axios.get(`http://localhost:8000?${query}`);
        this.chartData = response.data;
      } catch (error) {
        console.error('Error fetching data:', error);
        this.chartData = [];
      }
    }
  },
  mounted() {
    // Fetch initial data
    this.updateFilters();
  },
};
</script>

<style scoped>
.dashboard {
  padding: 20px;
}
.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 20px;
}
</style>
