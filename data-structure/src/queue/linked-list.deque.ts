/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:05:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-06-17 13:20:04
 */

import { Deque } from './_base.deque'

import { LinkedListQueue } from './linked-list.queue'

import { DoublyLinkedList } from '../linked-list/doubly.linked-list'

/**
 *
 * @class
 *
 *  一个基于链表（双向链表）的双向队列。
 *
 */
export class LinkedListDeque<T = any> extends LinkedListQueue<T> implements Deque<T> {
  declare protected _linkedList: DoublyLinkedList<T>

  public constructor() {
    super()
    this._linkedList = new DoublyLinkedList<T>()
  }

  public unshift(value: T): void {
    this._linkedList.unshift(value)
  }

  public pop(): T | undefined {
    return this._linkedList.pop()
  }
}
