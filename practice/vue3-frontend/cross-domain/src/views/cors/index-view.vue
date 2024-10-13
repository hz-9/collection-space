<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { type Service, ServiceStatus } from '../../types'

import axios, { type AxiosRequestConfig } from 'axios'
import { CloseCircleOutlined, CheckCircleOutlined, LoadingOutlined } from '@ant-design/icons-vue'

import MultiTabs from '../../components/multi-tabs.vue'

import RequestView from '../../components/request-view.vue'

const list = ref<Service[]>([
  {
    name: 'Express',
    baseUrl: `${location.protocol}//${location.hostname}:3000`,
  },
  {
    name: 'Koa.js',
    baseUrl: `${location.protocol}//${location.hostname}:3001`,
  },
  {
    name: 'Egg.js',
    baseUrl: `${location.protocol}//${location.hostname}:3002`,
  },
  {
    name: 'Nest.js',
    baseUrl: `${location.protocol}//${location.hostname}:3003`,
  },
])

const requestHandle = async (options: AxiosRequestConfig) => {
  const result = await axios.request(options)
  return result.data
}

let serviceStatus = ref(ServiceStatus.init)

const handleChange = (newInfo: Service) => {
  connectService(newInfo)
}

const connectService = async (service: Service = list.value[0]) => {
  serviceStatus.value = ServiceStatus.loading

  axios
    .get(`${service.baseUrl}/cross-domain/cors`)
    .then(() => {
      serviceStatus.value = ServiceStatus.success
    })
    .catch(() => {
      serviceStatus.value = ServiceStatus.error
    })
}

onMounted(() => {
  connectService()
})
</script>

<template>
  <div>
    <multi-tabs
      title="CORS"
      :list="list"
      @change="handleChange"
    >
      <template v-slot:extra>
        <template v-if="serviceStatus === ServiceStatus.success">
          <check-circle-outlined style="color: #52c41a" />
        </template>

        <template v-else-if="serviceStatus === ServiceStatus.error">
          <close-circle-outlined style="color: #ff4d4f" />
        </template>

        <template v-else>
          <loading-outlined />
        </template>
      </template>

      <template v-slot:content="{ info }">
        <request-view
          :service="info"
          :method="'GET'"
          :url="'/cross-domain/cors'"
          :request-handle="requestHandle"
        ></request-view>
      </template>
    </multi-tabs>
  </div>
</template>
