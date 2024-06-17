/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-28 01:40:30
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 20:22:07
 */

import { defaultEquals, defaultCompare } from '../utils/index'

import { DoublyLinkedListNode, DoublyLinkedList } from './doubly.linked-list'

/**
 *
 * @class
 * 
 *  有序列表
 * 
 */
export class SortedLinkedList<T = any> extends DoublyLinkedList<T> {
  /**
   * 相等判断函数
   */
  protected readonly _compareFn: (a?: T, b?: T) => number

  public constructor(equalsFn = defaultEquals, compareFn = defaultCompare) {
    super(equalsFn)

    this._compareFn = compareFn
  }

  public push(value: T): boolean {
    if (!this._tail) return super.push(value)

    /**
     * 只有当保证合理顺序时，才允许添加
     */
    const c = this._compareFn(this._tail.val, value)
    if (c > 0) return super.push(value)
    return false
  }

  public unshift(value: T) {
    if (!this._head) return super.unshift(value)

    /**
     * 只有当保证合理顺序时，才允许添加
     */
    const c = this._compareFn(value, this._head.val)
    if (c > 0) return super.unshift(value)
    return false
  }

  public addAt(index: number, value: T): boolean {
    if (!this._tail || !this._head) {
      this.push(value)
      return false
    }

    if (this._compareFn(value, this._head.val) > 0) {
      this.unshift(value)
      return true
    }

    if (this._compareFn(this._tail.val, value) > 0) {
      this.push(value)
      return true
    }

    const nextNode = this._getNextNode(value)

    // 实际逻辑不会出现 nextNode 为空的情况。
    if (!nextNode) return false

    const node = new DoublyLinkedListNode(value, nextNode.prev, nextNode)

    if (nextNode.prev) nextNode.prev.next = node
    nextNode.prev = node

    this._size += 1
    return true
  }

  private _getNextNode(value: T): DoublyLinkedListNode<T> | undefined {
    let current = this._head
    if (!current) return undefined

    while (current) {
      if (this._compareFn(value, current.val) > 0) return current
      current = current.next
    }

    return undefined
  }
}
