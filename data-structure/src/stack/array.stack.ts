/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 01:09:11
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:43:42
 */

import { Stack } from './_base.stack'

/**
 *
 * @class
 *
 *  一个基于数组实现的栈
 *
 */
export class ArrayStack<T = any> implements Stack<T> {
  private _list: Array<T>

  public constructor() {
    this._list = []
  }

  public get size(): number {
    return this._list.length
  }
  
  public get isEmpty(): boolean {
    return this.size === 0
  }

  public push(val: T): void {
    this._list.push(val)
  }

  public peek(): T | undefined {
    return this._list[this._list.length - 1]
  }

  public pop(): T | undefined {
    const a = this._list[this._list.length - 1]
    this._list.length -= 1
    return a
  }

  public clear(): void {
    this._list = []
  }
}
