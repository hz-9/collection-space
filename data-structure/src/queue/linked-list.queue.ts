/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:05:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:43:31
 */

import { Queue } from './_base.queue'

import { SinglyLinkedList } from '../linked-list/singly.linked-list'

/**
 *
 * @class
 *
 *  一个基于链表（单向链表）的单向队列。
 *
 */
export class LinkedListQueue<T = any> implements Queue<T> {
  protected _linkedList: SinglyLinkedList<T>

  public constructor() {
    this._linkedList = new SinglyLinkedList<T>()
  }

  public get size() {
    return this._linkedList.size
  }

  public get isEmpty() {
    return this._linkedList.isEmpty
  }

  public get first(): T | undefined {
    return this._linkedList.first
  }

  public get last(): T | undefined {
    return this._linkedList.last
  }

  public push(value: T): void {
    this._linkedList.push(value)
  }

  public shift(): T | undefined {
    return this._linkedList.shift()
  }

  public clear(): void {
    this._linkedList.clear()
  }
}
