<template>
  <div id="company-item">
    <div id="company-title">
      {{ name }} - {{ number }}
      <button :class="{ active: isLiked }" @click="toggleLikeCompany()">{{ isLiked ? 'LIKED' : 'LIKE' }}</button>
    </div>
    <div id="company-address">
      <p> {{ address }}</p>
    </div>
    <br/>
  </div>
</template>

<script>

import axios from "axios";
let token = document.getElementsByName('csrf-token')[0].getAttribute('content')
axios.defaults.headers.common['X-CSRF-Token'] = token
axios.defaults.headers.common['Accept'] = 'application/json'

export default {
  data() {
    return {
      isLiked: this.liked
    }
   },
  methods: {
    toggleLikeCompany() {
      this.isLiked = !this.isLiked
      try {
        axios.patch('/company', {
          number: this.number,
          liked: this.isLiked
        })
      } catch (e) {
        console.log(e)
      }
    }
  },
  props: {
    name: {
      type: String
    },
    number: {
      type: String
    },
    address: {
      type: String
    },
    liked: {
      type: Boolean
    }
  }
}
</script>

<style scoped>
.active {
  background-color: lightGreen;
}
</style>