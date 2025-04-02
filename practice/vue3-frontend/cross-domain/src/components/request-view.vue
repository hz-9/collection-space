<script setup lang="ts">
import type { AxiosRequestConfig } from 'axios'
import { computed, ref, watch } from 'vue'

import type { Service } from '../types'

const props = defineProps<{
  service: Service
  method: string
  url: string
  requestHandle: (options: AxiosRequestConfig) => Promise<any>
}>()

const requestUrl = computed(() => `${props.service.baseUrl}${props.url}`)

const responseData = ref<any>(null)

watch(requestUrl, () => {
  responseData.value = null
})

const handleRequest = async () => {
  const result = await props.requestHandle({
    method: props.method,
    url: requestUrl.value,
  })
  responseData.value = result
}
</script>

<template>
  <div class="container">
    <div class="section">
      <div class="label">URL</div>
      <div class="content">{{ method }}: {{ requestUrl }}</div>

      <a-button
        class="button"
        type="primary"
        size="small"
        @click="handleRequest"
      >
        Request
      </a-button>
    </div>

    <div class="section">
      <div class="label">Response:</div>
      <div class="content">{{ responseData ?? '---' }}</div>
    </div>
  </div>
</template>

<style scoped>
.section {
  position: relative;
}
.label {
  margin-top: 0.5rem;
}
.content {
  margin-top: 0.2rem;
  padding: 0.2rem 0.5rem;
}

.button {
  position: absolute;
  right: 4px;
  bottom: 4px;
}
</style>
