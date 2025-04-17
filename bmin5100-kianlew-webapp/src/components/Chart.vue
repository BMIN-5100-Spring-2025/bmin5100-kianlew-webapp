<template>
  <div class="chart-container">
    <v-chart :option="chartOption" autoresize />
  </div>
</template>

<script>
import VChart from 'vue-echarts';
import { use } from 'echarts/core';
import { BarChart } from 'echarts/charts';
import { TitleComponent, TooltipComponent, LegendComponent, GridComponent } from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';

use([
  CanvasRenderer,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
]);

export default {
  name: 'Chart',
  components: {
    VChart
  },
  props: {
    data: Array,
  },
  computed: {
    chartOption() {
      return {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: this.data.map(item => item.category)
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: 'Count',
            type: 'bar',
            data: this.data.map(item => item.value),
            itemStyle: {
              color: 'rgba(75, 192, 192, 1)'
            }
          }
        ]
      };
    }
  }
};
</script>

<style scoped>
.chart-container {
  height: 400px;
  width: 100%;
}
</style>
