<script setup lang="ts">
import { defineEmits, ref, watch } from 'vue'

import type { Service, Website } from '../types'

const props = defineProps<{
  title: string
  list: Array<Website | Service>
}>()

const emit = defineEmits(['change'])

const chooseOne = ref(props.list[0])

watch(chooseOne, () => {
  emit('change', chooseOne.value)
})
</script>

<template>
  <div class="container">
    <h1>{{ title }}</h1>

    <div class="service">
      <a-space>
        <template
          v-for="(item, index) in list"
          :key="index"
        >
          <a-button
            :type="chooseOne === item ? 'primary' : undefined"
            @click="chooseOne = item"
            size="small"
          >
            {{ item.name }}
          </a-button>
        </template>
      </a-space>

      <div class="extra">
        <slot name="extra"></slot>
      </div>
    </div>

    <div class="content">
      <slot
        name="content"
        :info="chooseOne"
      ></slot>
    </div>
  </div>
</template>

<style scoped>
.container {
  /* background: white; */
  padding: 0.2rem 0.5rem;
  border: 1px solid var(--color-border);
}

.service {
  position: relative;
  margin-top: 1rem;
  display: flex;
  justify-content: space-between;
}

.content {
  margin-top: 1rem;
}

.extra {
  position: absolute;
  right: 6px;
  bottom: 6px;
}
</style>
