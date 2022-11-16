<template>
  <div id="companies-list">
    <p>{{ title }}</p>
    <li v-for="company, index in companies" :key="index">
      <div id="company-item">
        <Company :name="company.name" :number="company.number" :address="company.address" v-bind:liked="company.liked" />
      </div>
    </li>
  </div>
</template>

<script>
import Company from '../components/Company.vue'
export default {
  data: function () {
    return {
      title: "Companies List"
    }
  },
  methods: {
  },
  props: {
    companies: {
      type: Array,
      default: () => []
    }
  },
  components: { Company }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>