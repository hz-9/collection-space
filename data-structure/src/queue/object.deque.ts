/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:05:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 11:31:22
 */

import { Deque } from './_base.deque'

import { ObjectQueue } from './object.queue'

/**
 *
 * @class
 *
 *  一个基于对象的双向队列。
 *
 */
export class ObjectDeque<T = any> extends ObjectQueue<T> implements Deque<T> {
  public unshift(value: T): void {
    if (!this.isEmpty) this._flag -= 1

    this._items[this._flag] = value
    this._size += 1
  }

  public pop(): T | undefined {
    const last = this._items[this._flag + this._size - 1]
    delete this._items[this._flag + this._size - 1]

    this._size -= 1

    /**
     * 在队列中，先入先出过程中， _flag 会不断地向右移动，当队列为空时，_flag 进行重置。
     */
    if (this.isEmpty) {
      this._flag = 0
    }

    return last
  }
}
