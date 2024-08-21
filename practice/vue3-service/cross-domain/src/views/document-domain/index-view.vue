<script setup lang="ts">
import { ref, nextTick, onMounted, onBeforeUnmount } from 'vue'
import { type Website } from '../../types'

import MultiTabs from '../../components/multi-tabs.vue'
import TwoPage from '../../components/two-page.vue'
import LeftMockIframe from '../../components/left-mock-iframe.vue'

import type { MessageLog, SendInfo } from '../../types/index'

const list = ref<Website[]>([
  {
    name: 'Same Domain',
    baseUrl: `${location.protocol}//${location.hostname}:${location.port}/set-domain.html`
  },
  {
    name: 'Diff Domain',
    baseUrl: `${location.protocol}//a.example.com:${location.port}/set-domain.html`
  }
])

const msgList = ref<MessageLog[]>([])

const iframe = ref<HTMLIFrameElement | null>(null)

const sendToIframe = () => {
  nextTick(() => {
    const msg = `This is parent, send to iframe: ${new Date().toLocaleString()}`
    const sendInfo: SendInfo = {
      type: 'msg',
      msg
    }
    msgList.value.push({
      type: 'send',
      msg
    })

    const receiveMsg = iframe.value?.contentWindow?.receiveMsg
    if (receiveMsg) {
      receiveMsg(JSON.stringify(sendInfo))
    }
  })
}

const inExampleDomain = location.hostname.includes('example.com')
const exampleUrl = `${location.protocol}//www.example.com:${location.port}/document-domain`

onMounted(() => {
  window.receiveMsgFromParent = (data: SendInfo) => {
    const receiveInfo: SendInfo = data
    if (receiveInfo.type === 'msg') {
      msgList.value.push({
        type: 'receive',
        msg: receiveInfo.msg
      })
    }
  }
})

onBeforeUnmount(() => {
  // @ts-ignore
  if (window.removeEventListener) window.removeEventListener = undefined
})

const sendToParent = () => {
  if (iframe.value) {
    const sendInfo: SendInfo = {
      type: 'callback',
      msg: ''
    }
    const receiveMsg = iframe.value?.contentWindow?.receiveMsg
    if (receiveMsg) {
      receiveMsg(JSON.stringify(sendInfo))
    }
  }
}

const handleChange = () => {
  msgList.value = []
}
</script>

<template>
  <div>
    <multi-tabs title="Document.domain" :list="list" @change="handleChange">
      <template v-slot:content="{ info }">
        <template v-if="inExampleDomain">
          <two-page @left-click="sendToIframe" @right-click="sendToParent">
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
        <template v-else>
          please visit <a :href="exampleUrl">{{ exampleUrl }}</a
          >.
          <br />
          Of course, you need to set the hosts file to point a.example.com and www.example.com to
          127.0.0.1.
        </template>
      </template>
    </multi-tabs>
  </div>
</template>
