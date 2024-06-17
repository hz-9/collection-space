/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 01:09:11
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:42:56
 */

import { Stack } from './_base.stack'

/**
 *
 * @class
 *
 *  一个基于对象实现的栈
 *
 */
export class ObjectStack<T = any> implements Stack<T> {
  private _items: Record<number, T>

  private _size: number

  public constructor() {
    this._items = {}
    this._size = 0
  }

  public get size(): number {
    return this._size
  }
  
  public get isEmpty(): boolean {
    return this.size === 0
  }

  public push(val: T): void {
    this._items[this._size] = val
    this._size += 1
  }

  public peek(): T | undefined {
    return this._items[this._size - 1]
  }

  public pop(): T | undefined {
    const a = this._items[this._size - 1]
    this._size -= 1
    return a
  }

  public clear(): void {
    this._items = {}
    this._size = 0
  }
}
