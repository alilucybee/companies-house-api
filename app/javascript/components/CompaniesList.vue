<template>
  <div id="companies-list">
    <p>{{ title }}</p>
    <li v-for="company, index in companies" :key="index">
      {{ company.name }}
    </li>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      title: "Hello Companies List!"
    }
  },
  props: {
    companies: {
      type: Array,
      default: () => []
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>