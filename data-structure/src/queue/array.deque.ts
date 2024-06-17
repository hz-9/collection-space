/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:05:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 11:22:34
 */

import { Deque } from './_base.deque'

import { ArrayQueue } from './array.queue'

/**
 *
 * @class
 *
 *  一个基于数组的双向队列。
 *
 */
export class ArrayDeque<T = any> extends ArrayQueue<T> implements Deque<T> {
  public unshift(value: T): void {
    this._list.unshift(value)
  }

  public pop(): T | undefined {
    return this._list.pop()
  }
}
