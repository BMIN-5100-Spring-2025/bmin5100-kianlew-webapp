<template>
  <div class="dropdown">
    <label>{{ label }}</label>
    <select v-model="selectedValue" @change="emitChange">
      <option value="">Select an option</option>
      <option v-for="option in options" :key="option.value" :value="option.value">
        {{ option.label }}
      </option>
    </select>
  </div>
</template>

<script>
export default {
  name: 'Dropdown',
  props: {
    label: String,
    options: Array, // Array of { value, label }
    value: [String, Number],
  },
  data() {
    return {
      selectedValue: this.value || '',
    };
  },
  methods: {
    emitChange() {
      this.$emit('update:value', this.selectedValue);
    },
  },
};
</script>

<style scoped>
.dropdown {
  margin: 10px 0;
}
label {
  margin-right: 10px;
}
select {
  padding: 5px;
  font-size: 16px;
}
</style>
