/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-02 10:58:23
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-02 11:18:45
 */

import { MinHeap } from './min.heap'

/**
 *
 * Top-k 问题。
 *
 * 堆排序方案。
 *
 */
export function findTopK(arr: number[], k: number): number[] {
  const heap = new MinHeap<number>()

  for (let i = 0; i < arr.length; i += 1) {
    const item = arr[i]
    if (i < k) {
      heap.add(item)
    } else {
      if (item > heap.peek()!) {
        heap.pop()
        heap.add(item)
      }
    }
  }

  return heap.toArray()
}
