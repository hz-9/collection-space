/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:05:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:43:27
 */

import { Queue } from './_base.queue'

/**
 *
 * @class
 *
 *  一个基于数组的单向队列。
 *
 */
export class ArrayQueue<T = any> implements Queue<T> {
  protected _list: Array<T>

  public constructor() {
    this._list = []
  }

  public get size() {
    return this._list.length
  }

  public get isEmpty() {
    return this._list.length === 0
  }

  public get first(): T | undefined {
    return this._list[0]
  }

  public get last(): T | undefined {
    return this._list[this._list.length - 1]
  }

  public push(value: T): void {
    this._list.push(value)
  }

  public shift(): T | undefined {
    return this._list.shift()
  }

  public clear(): void {
    this._list = []
  }
}
