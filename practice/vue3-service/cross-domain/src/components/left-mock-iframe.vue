<script setup lang="ts">
import { computed } from 'vue'

import type { MessageLog } from '../types/index'

const props = defineProps<{
  msgList: MessageLog[]
}>()

const logList = computed(() => {
  const reverseMsgList = [...props.msgList]
  reverseMsgList.reverse()
  if (reverseMsgList.length > 8) reverseMsgList.length = 8
  return reverseMsgList
})
</script>

<template>
  <div class="iframe">
    <div class="iframe-content">
      <ul>
        <template v-if="logList.length">
          <li
            v-for="(item, index) in logList"
            :key="index"
          >
            {{ item.type }}: {{ item.msg }}
          </li>
        </template>
        <template v-else>
          <li>Please click the button to send message.</li>
        </template>
      </ul>
    </div>
  </div>
</template>

<style scoped>
.iframe {
  background: #fff;
}

.iframe-content {
  margin: 8px;
}

/* .left .iframe,
.right iframe {
} */
</style>
