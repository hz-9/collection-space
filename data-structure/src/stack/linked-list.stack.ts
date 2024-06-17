/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 01:09:05
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:43:45
 */

import { Stack } from './_base.stack'

import { SinglyLinkedList } from '../linked-list/singly.linked-list'

/**
 *
 * @class
 *
 *  一个基于链表实现的栈
 *
 */
export class LinkedListStack<T = any> implements Stack<T> {
  private _linkList: SinglyLinkedList<T>

  public constructor() {
    this._linkList = new SinglyLinkedList<T>()
  }

  public get size(): number {
    return this._linkList.size
  }
  
  public get isEmpty(): boolean {
    return this._linkList.isEmpty
  }

  public push(val: T): void {
    this._linkList.push(val)
  }

  public peek(): T | undefined {
    return this._linkList.last
  }

  public pop(): T | undefined {
    return this._linkList.pop()
  }

  public clear(): void {
    this._linkList.clear()
  }
}
