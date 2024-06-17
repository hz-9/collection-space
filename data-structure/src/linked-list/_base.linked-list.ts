/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-28 15:18:52
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 20:21:08
 */

import type { FindCallback } from '../types/index'

import { defaultEquals } from '../utils/index'

/**
 *
 * @class
 * 
 *  链表节点基类
 * 
 */
export class LinkedListNode<T = any> {
  /**
   * 节点信息
   */
  public val: T

  /**
   * 下一个节点。
   */
  public next: LinkedListNode<T> | undefined

  public constructor(val: T, next?: LinkedListNode<T>) {
    this.val = val
    this.next = next
  }
}

/**
 *
 * @class
 * 
 *  链表基类
 * 
 */
export abstract class LinkedList<T = any, N extends LinkedListNode<T> = LinkedListNode<T>> {
  /**
   * 链表的头部节点
   */
  protected _head: N | undefined

  /**
   * 链表的尾部节点
   */
  protected _tail: N | undefined

  /**
   * 链表节点数量
   */
  protected _size: number

  /**
   * 相等判断函数
   */
  protected readonly _equalsFn: (a?: T, b?: T) => boolean

  public constructor(equalsFn = defaultEquals<T>) {
    this._head = undefined

    this._tail = undefined

    this._size = 0

    this._equalsFn = equalsFn
  }

  /**
   * 链表节点数量
   */
  public get size(): number {
    return this._size
  }

  /**
   * 链表是否为空
   */
  public get isEmpty(): boolean {
    return this.size === 0
  }

  /**
   * 头部节点
   */
  public get head(): N | undefined {
    return this._head
  }

  /**
   * 尾部节点
   */
  public get tail(): N | undefined {
    return this._tail
  }

  /**
   * 第一个值
   */
  public get first(): T | undefined {
    return this._head?.val
  }

  /**
   * 最后一个值
   */
  public get last(): T | undefined {
    return this._tail?.val
  }

  /**
   * 
   * 在链尾添加一个新元素。若在有序链表中，添加的元素不大于尾部元素，则添加失败。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 待添加的元素
   * 
   */
  public abstract push(value: T): boolean

  /**
   * 
   * 在链尾删除一个节点，并返回该节点
   * 
   * 时间复杂度: O(1) (SinglyLinkedList 未 O(n))
   *
   * 空间复杂度: O(1)
   * 
   * @returns 返回删除的节点，若链为空，则返回 undefined
   *
   */
  public abstract popNode(): N | undefined

  /**
   * 
   * 在链尾删除一个新元素，并返回该元素
   * 
   * 时间复杂度: O(1) (SinglyLinkedList 未 O(n))
   *
   * 空间复杂度: O(1)
   * 
   * @returns 返回删除的元素，若链为空，则返回 undefined
   *
   */
  public pop(): T | undefined {
    const node = this.popNode()
    return node?.val
  }

  /**
   * 
   * 向链头添加一个新元素。若在有序链表中，添加的元素不大于头部元素，则添加失败。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 待添加的元素
   *
   */
  public abstract unshift(value: T): boolean

  /**
   * 
   * 在链头删除一个新元素，并返回该节点
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @returns 返回删除的节点，若链为空，则返回 undefined
   *
   */
  public abstract shiftNode(): N | undefined

  /**
   * 
   * 在链头删除一个新元素，并返回该元素
   * 
   * 时间复杂度: O(1) 
   *
   * 空间复杂度: O(1)
   * 
   * @returns 返回删除的元素，若链为空，则返回 undefined
   *
   */
  public shift(): T | undefined {
    const node = this.shiftNode()
    return node?.val
  }

  /**
   * 
   * 在链表某个位置的节点
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {number} index - 查询的位置
   * 
   * @returns 查询的节点。若未查询到，则返回 undefined
   */
  public getNodeAt(index: number): N | undefined {
    if (index < 0 || index > this.size) return undefined

    let current = this._head

    let i = 0
    while (current && i < index) {
      current = current.next as N | undefined
      i += 1
    }

    return current
  }

  /**
   * 
   * 在链表某个位置的元素
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {number} index - 查询的位置
   * 
   * @returns 查询的元素。若未查询到，则返回 undefined
   */
  public getAt(index: number): T | undefined {
    const node = this.getNodeAt(index)
    return node?.val
  }

  /**
   * 
   * 获取某元素在链的位置
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 元素
   * 
   * @returns 位置。若未查到，返回 -1
   */
  public getIndex(value: T): number {
    let index = 0;
    let current: N | undefined = this._head

    while (current) {
      if (this._equalsFn(current.val, value)) return index

      index += 1
      current = current.next as N | undefined
    }

    return -1
  }

  /**
   * 
   * 获取某元素在链的节点
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 元素
   * 
   * @returns 位置。若未查到，返回 -1
   */
  public getNode(value: T): N | undefined {
    let current = this._head

    while (current) {
      if (this._equalsFn(current.val, value)) return current
      current = current.next as N | undefined
    }

    return undefined
  }

  /**
   * 
   * 遍历链表，并找到某个值
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 元素
   * 
   * @returns 位置。若未查到，返回 -1
   */
  public find(callback: FindCallback<T>): T | undefined {
    let current: N | undefined = this._head

    while (current) {
      const result = callback(current.val)
      if (result) return current.val
      current = current.next as N | undefined
    }

    return undefined
  }

  /**
   * 
   * 在链表某个位置添加新元素。
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {number} index - 添加位置。在有序链表中，可传入任意值，实际会根据排序位置确定塞入点。
   * @param {T} value - 待添加的元素
   * 
   * @returns 是否添加成功
   */
  public abstract addAt(index, value): boolean

  /**
   * 
   * 删除链表某个位置节点
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {number} index - 删除位置
   * 
   * @returns 是否添加成功
   *
   */
  public abstract removeAt(index): boolean

  /**
   * 
   * 删除某个元素
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 元素
   * 
   * @returns 是否删除成功。
   *
   */
  public abstract remove(value: T): boolean

  /**
   * 
   * 清空链表
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 元素
   * 
   * @returns 是否删除成功。
   *
   */
  public clear(): void {
    this._head = undefined
    this._tail = undefined
    this._size = 0
  }
}
