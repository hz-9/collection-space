<script setup lang="ts">
import type { StepProps } from 'ant-design-vue'
import { ref, watch } from 'vue'

import MultiTabs from '../../components/multi-tabs.vue'
import { type Website } from '../../types'

const list = ref<Website[]>([])

enum IframeStatus {
  /**
   *  Init stage.
   */
  Init = 'init',

  /**
   * Same domain, save request data.
   */
  Send = 'send',

  /**
   * Diff domain, receive request data and callback.
   */
  Callback = 'callback',

  /**
   * Receive data from iframe.
   */
  Receive = 'receive',
}

const items = ref<StepProps[]>([
  {
    title: 'Init',
    status: 'process',
  },
  {
    title: 'Send',
    status: 'wait',
  },
  {
    title: 'Callback',
    status: 'wait',
  },
  {
    title: 'Receive',
    status: 'wait',
  },
])

const iframeStatus = ref<IframeStatus>(IframeStatus.Init)

watch(iframeStatus, () => {
  let done = true
  items.value.forEach((item) => {
    if ((item.title ?? '').toLowerCase() === iframeStatus.value.toLowerCase()) {
      item.status = 'process'
      done = false
    } else if (done) {
      item.status = 'finish'
    } else {
      item.status = 'wait'
    }
  })
})

const iframe = ref<HTMLIFrameElement | null>(null)

const running = ref<boolean>(false)

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

const src1 = `${location.protocol}//${location.hostname}:${location.port}/window-name.html`
const src2 = `${location.protocol}//${location.hostname}:5175/window-name.html`

interface SendInfo {
  type: 'msg' | 'callback'
  msg: string
  fromHost: string
  toHost: string
}

const loadSameDomain = () =>
  new Promise((resolve, reject) => {
    if (iframe.value) {
      const sendInfo: SendInfo = {
        type: 'msg',
        msg: `This is parent, send to iframe: ${new Date().toLocaleString()}`,
        fromHost: location.host,
        toHost: `${location.hostname}:5175`,
      }

      iframe.value.src = src1
      iframe.value.onload = () => {
        iframeStatus.value = IframeStatus.Send

        if (iframe.value?.contentWindow) iframe.value.contentWindow.name = JSON.stringify(sendInfo)
        resolve({})
      }
      iframe.value.onerror = () => {
        reject(new Error('iframe error'))
      }
    } else {
      reject(new Error('iframe is null'))
    }
  })

const loadDiffDomain = () =>
  new Promise((resolve, reject) => {
    if (iframe.value) {
      iframe.value.src = src2
      iframe.value.onload = () => {
        iframeStatus.value = IframeStatus.Callback

        resolve({})
      }
      iframe.value.onerror = () => {
        reject(new Error('iframe error'))
      }
    } else {
      reject(new Error('iframe is null'))
    }
  })

const loadSameDomain2 = () =>
  new Promise((resolve, reject) => {
    if (iframe.value) {
      iframe.value.src = src1
      iframe.value.onload = () => {
        iframeStatus.value = IframeStatus.Receive

        resolve(iframe.value?.contentWindow?.name)
      }
      iframe.value.onerror = () => {
        reject(new Error('iframe error'))
      }
    } else {
      reject(new Error('iframe is null'))
    }
  })

const handleStart = async () => {
  running.value = true

  iframeStatus.value = IframeStatus.Init

  await loadSameDomain()

  await sleep(3000)

  await loadDiffDomain()

  await sleep(3000)

  await loadSameDomain2()

  await sleep(3000)

  running.value = false
}
</script>

<template>
  <div>
    <multi-tabs
      title="Window.name"
      :list="list"
    >
      <template v-slot:extra>
        <a-button
          size="small"
          type="primary"
          @click="handleStart"
          :disabled="running"
        >
          Start Request.
        </a-button>
      </template>
      <template v-slot:content>
        <a-steps
          class="steps"
          :items="items"
        ></a-steps>

        <div class="">Iframe status: {{ iframeStatus }}</div>

        <iframe
          ref="iframe"
          class="iframe"
          src=""
          width="100%"
          height="500"
          frameborder="0"
          scrolling="no"
        ></iframe>
      </template>
    </multi-tabs>
  </div>
</template>

<style scoped>
.iframe {
  background-color: #fff;
}

.steps :deep() .ant-steps-item-title,
.steps :deep() .ant-steps-icon {
  color: #fff !important;
}
.steps :deep() .ant-steps-item-icon {
  border-color: #fff !important;
}
</style>
