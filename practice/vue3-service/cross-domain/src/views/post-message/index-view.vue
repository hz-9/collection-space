<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { type Website } from '../../types'

import MultiTabs from '../../components/multi-tabs.vue'
import TwoPage from '../../components/two-page.vue'
import LeftMockIframe from '../../components/left-mock-iframe.vue'

import type { MessageLog, SendInfo } from '../../types/index'

const list = ref<Website[]>([
  {
    name: 'Same Domain',
    baseUrl: `${location.protocol}//${location.hostname}:${location.port}/post-message.html`
  },
  {
    name: 'Diff Domain',
    baseUrl: `${location.protocol}//${location.hostname}:5175/post-message.html`
  }
])

const msgList = ref<MessageLog[]>([])

const iframe = ref<HTMLIFrameElement | null>(null)

const sendToIframe = (website: Website) => {
  if (iframe.value) {
    const msg = `This is parent, send to iframe: ${new Date().toLocaleString()}`
    const sendInfo: SendInfo = {
      type: 'msg',
      msg
    }

    msgList.value.push({
      type: 'send',
      msg
    })

    iframe.value.contentWindow?.postMessage(JSON.stringify(sendInfo), website.baseUrl)
  }
}

const messageCallback = (e: MessageEvent) => {
  const data = JSON.parse(e.data)
  if (data.type === 'callback') {
    msgList.value.push({
      type: 'receive',
      msg: data.msg
    })
  }
}

onMounted(() => {
  window.addEventListener('message', messageCallback)
})

onUnmounted(() => {
  window.removeEventListener('message', messageCallback)
})

const sendToParent = (website: Website) => {
  if (iframe.value) {
    const sendInfo: SendInfo = {
      type: 'callback',
      msg: ''
    }
    iframe.value.contentWindow?.postMessage(JSON.stringify(sendInfo), website.baseUrl)
  }
}

const handleChange = () => {
  msgList.value = []
}
</script>

<template>
  <div>
    <multi-tabs title="PostMessage" :list="list" @change="handleChange">
      <template v-slot:content="{ info }">
        <two-page @left-click="sendToIframe(info)" @right-click="sendToParent(info)">
          <template v-slot:left>
            <left-mock-iframe :msgList="msgList"></left-mock-iframe>
          </template>

          <template v-slot:right>
            <iframe
              ref="iframe"
              class="iframe"
              :src="info.baseUrl"
              width="100%"
              height="500"
              frameborder="0"
              scrolling="no"
            ></iframe>
          </template>
        </two-page>
      </template>
    </multi-tabs>
  </div>
</template>
