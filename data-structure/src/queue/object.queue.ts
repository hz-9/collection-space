/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:05:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:43:35
 */

import { Queue } from './_base.queue'

/**
 *
 * @class
 *
 *  一个基于对象的单向队列。
 *
 */
export class ObjectQueue<T = any> implements Queue<T> {
  protected _items: Record<number, T>

  protected _size: number

  /**
   * 第一个元素，未知
   */
  protected _flag: number

  public constructor() {
    this._items = []

    this._size = 0

    this._flag = 0
  }

  public get size() {
    return this._size
  }

  public get isEmpty() {
    return this._size === 0
  }

  public get first(): T | undefined {
    return this._items[this._flag]
  }

  public get last(): T | undefined {
    return this._items[this._flag + this._size - 1]
  }

  public push(value: T): void {
    this._items[this._flag + this._size] = value
    this._size += 1
  }

  public shift(): T | undefined {
    const first = this._items[this._flag]
    delete this._items[this._flag]

    this._size -= 1

    /**
     * 在队列中，先入先出过程中， _flag 会不断地向右移动，当队列为空时，_flag 进行重置。
     */
    if (this.isEmpty) {
      this._flag = 0
    } else {
      this._flag += 1
    }

    return first
  }

  public clear(): void {
    this._items = []

    this._size = 0

    this._flag = 0
  }
}
