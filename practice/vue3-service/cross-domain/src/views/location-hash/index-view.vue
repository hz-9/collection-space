<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { type Website } from '../../types'

import MultiTabs from '../../components/multi-tabs.vue'
import TwoPage from '../../components/two-page.vue'

import type { MessageLog } from '../../types/index'

const list = ref<Website[]>([])

const leftUrl = `${location.protocol}//${location.hostname}:5174/location-hash.left.html`
const rightUrl = `${location.protocol}//${location.hostname}:5175/location-hash.right.html`

const msgList = ref<MessageLog[]>([])

const leftIframe = ref<HTMLIFrameElement | null>(null)

const rightIframe = ref<HTMLIFrameElement | null>(null)

const changeHash = (iframe: HTMLIFrameElement, hashStr: string) => {
  const url = new URL(iframe.src)
  url.hash = hashStr
  iframe.src = url.toString()
}

const sendToLeft = () => {
  if (rightIframe.value) {
    changeHash(rightIframe.value, `callback-${location.port}`)
  }
}

const sendToRight = () => {
  if (leftIframe.value) {
    changeHash(leftIframe.value, `callback-${location.port}`)
  }
}

onMounted(() => {
  window.addEventListener('hashchange', () => {
    console.log('hashchange', window.location.hash)
    const hash = window.location.hash.replace(/^#/, '')
    window.location.hash = ''
    if (/^to-right-/.test(hash)) {
      if (rightIframe.value) changeHash(rightIframe.value, `msg-${hash.replace(/^to-right-/, '')}`)
    } else if (/^to-left-/.test(hash)) {
      if (leftIframe.value) changeHash(leftIframe.value, `msg-${hash.replace(/^to-left-/, '')}`)
    }
  })
})

const handleChange = () => {
  msgList.value = []
}
</script>

<template>
  <div>
    <multi-tabs
      title="LocationHash"
      :list="list"
      @change="handleChange"
    >
      <template v-slot:content>
        <two-page
          @left-click="sendToRight"
          @right-click="sendToLeft"
        >
          <template v-slot:left>
            <iframe
              ref="leftIframe"
              class="iframe"
              :src="leftUrl"
              width="100%"
              height="500"
              frameborder="0"
              scrolling="no"
            ></iframe>
          </template>

          <template v-slot:right>
            <iframe
              ref="rightIframe"
              class="iframe"
              :src="rightUrl"
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
