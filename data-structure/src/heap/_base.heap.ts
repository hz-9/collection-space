/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-01 00:51:18
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-02 12:14:45
 */

import { defaultCompare } from '../utils/index'

/**
 * @class
 *  
 *  最大堆、最小堆的基类。
 * 
 */
export abstract class Heap<T = any> {
  protected _size: number

  protected _list: Array<T>

  /**
   * 相等判断函数
   */
  protected readonly _compareFn: (a?: T, b?: T) => number

  public constructor(compareFn = defaultCompare) {
    this._compareFn = compareFn

    this._list = []

    this._size = 0
  }

  /**
   * 堆元素数量
   */
  public get size(): number {
    return this._size
  }

  /**
   * 树是否为空
   */
  public get isEmpty(): boolean {
    return this._size === 0
  }

  /**
   * 
   * 在堆中插入一个值。如果插入成功，则返回 true，否则返回 false
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @param value 
   */
  public add(value: T): boolean {
    this._list.push(value)
    this.siftUp(this._list.length - 1)

    this._size += 1
    return true
  }

  /**
   * 
   * 移除这个堆的最大值或最小值，并返回。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param value 
   */
  public pop(): T | undefined {
    const first = this._list[0]
  
    if (this._list.length > 1) {
      this._list[0] = this._list.pop()!
      this.siftDown(0)
    }

    return first
  }

  /**
   * 
   * 返回这个堆的最大值或最小值。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param value 
   */
  public peek(): T | undefined {
    return this._list[0]
  }
  
  /**
   * 
   * 上移操作。
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {number} value - 待移动的元素位置
   */
  protected abstract siftUp(index: number): void

  /**
   * 
   * 下移操作。
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {number} value - 待移动的元素位置
   */
  protected abstract siftDown(index: number): void

  /**
   * 
   * 交换两个位置数值。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param a 
   * @param b 
   */
  protected swap(a: number, b: number): void {
    [this._list[b], this._list[a]] = [this._list[a], this._list[b]]
  }

  /**
   * 获取节点左支的位置
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param index - 节点位置
   */
  protected getLeftIndex(index: number): number {
    return index * 2 + 1
  }

  /**
   * 获取节点右支的位置
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param index - 节点位置
   */
  protected getRightIndex(index: number): number {
    return index * 2 + 2
  }

  /**
   * 获取节点父节点的位置
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param index - 节点位置
   */
  protected getParentIndex(index: number): number | undefined {
    if (index === 0) return undefined
    return Math.floor((index - 1) / 2)
  }

  /**
   * 
   * 清除树结构。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   */
  public clear(): void {
    this._list = []
    this._size = 0
  }

  /**
   * 
   * 返回堆的数组结构。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(n)
   * 
   */
  public toArray(): Array<T> {
    return this._list.filter(i => i !== undefined)
  }
}
