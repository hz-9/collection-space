<script setup lang="ts">
import { defineProps, defineEmits } from 'vue'

defineProps<{
  leftTitle?: string
  rightTitle?: string
  leftButton?: string
  rightButton?: string
}>()

const emits = defineEmits(['left-click', 'right-click'])

const handleLeftClick = () => {
  emits('left-click')
}

const handleRightClick = () => {
  emits('right-click')
}
</script>

<template>
  <div class="content">
    <div class="left">
      <h3>{{ leftTitle ?? 'Left' }}</h3>
      <a-button class="button" size="small" type="primary" @click="handleLeftClick">{{
        leftButton ?? 'To right.'
      }}</a-button>

      <slot name="left" />
    </div>
    <div class="right">
      <h3>{{ rightTitle ?? 'Right' }}</h3>
      <a-button class="button" size="small" type="primary" @click="handleRightClick">{{
        rightButton ?? 'To left.'
      }}</a-button>

      <slot name="right" />
    </div>
  </div>
</template>

<style scoped>
.content {
  width: 100%;
  display: flex;
  gap: 6px;
}

.left,
.right {
  position: relative;
  width: 50%;
}

.right >>> iframe {
  background: #fff;
}

.left .button,
.right .button {
  position: absolute;
  top: 0;
  right: 6px;
}

.left >>> .iframe {
  color: #000;
  background: #fff;
  display: flex;
  height: 500px;
}
</style>
