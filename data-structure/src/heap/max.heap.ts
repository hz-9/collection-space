/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-01 00:57:24
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-01 01:29:09
 */

import { Heap } from './_base.heap'

export class MaxHeap<T = any> extends Heap<T> {
  public siftUp(index: number): void {
    let parent = this.getParentIndex(index)

    if (
      parent !== undefined
      && this._compareFn(this._list[parent], this._list[index]) < 0
    ) {
      this.swap(parent, index)

      this.siftUp(parent)
    }
  }

  public siftDown(index: number): void {
    let index_: number = index

    const left = this.getLeftIndex(index)
    const right = this.getLeftIndex(index)
    const size = this._size

    if (
      left < size
      && this._compareFn(this._list[index_], this._list[left]) < 0
    ) {
      index_ = left
    }
    
    if (
      right < size
      && this._compareFn(this._list[index_], this._list[right]) < 0
    ) {
      index_ = right
    }

    if (index_ !== index) {
      this.swap(index_, index)
      this.siftDown(index_)
    }
  }
}