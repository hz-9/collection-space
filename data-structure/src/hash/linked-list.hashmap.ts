/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 12:58:01
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 18:24:36
 */

import { ToKeyStr, ToHashCode, KeyValue, Hashmap } from './_base.hashmap'

import { loseloseHashCode } from './hash-code'

import { SinglyLinkedList } from '../linked-list/singly.linked-list'

/**
 *
 * @class
 *
 * 一个链式寻址的哈希表。
 *
 * 若遇到哈希值冲突时，将会根据在链表中继续寻找。
 *
 */
export class LinkedListHashmap<K = any, V = any> implements Hashmap<K, V> {
  protected _items: Record<number, SinglyLinkedList<KeyValue<K, V>>>

  protected _size: number

  protected _toKeyStr: ToKeyStr<K>

  protected _toHashCode: ToHashCode

  public constructor(toKeyStr: ToKeyStr<K>, toHashCode: ToHashCode = loseloseHashCode) {
    this._items = {}

    this._size = 0

    this._toKeyStr = toKeyStr

    this._toHashCode = toHashCode
  }

  public get size(): number {
    return this._size
  }

  public get isEmpty(): boolean {
    return this.size === 0
  }

  protected _singlyLinkedListEqualFn(a?: KeyValue<K, V>, b?: KeyValue<K, V>): boolean {
    return a?.value === b?.value
  }

  public set(key: K, value: V): boolean {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))

    if (!this._items[keyStr]) {
      this._items[keyStr] = new SinglyLinkedList<KeyValue<K, V>>(this._singlyLinkedListEqualFn)
    }

    this._items[keyStr].push(new KeyValue<K, V>(key, value))

    this._size += 1
    return true
  }

  public get(key: K): V | undefined {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))
    if (!this._items[keyStr]) return undefined

    const f = this._items[keyStr].find((n) => n.key === key)
    return f?.value
  }

  public has(key: K): boolean {
    return !!this.get(key)
  }

  public remove(key: K): boolean {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))
    if (!this._items[keyStr]) return false

    const removeResult = this._items[keyStr].remove(new KeyValue<K, V>(key, null as V))
    if (removeResult) this._size -= 1
    if (this._items[keyStr].isEmpty) delete this._items[keyStr]
    return removeResult
  }

  public clear(): void {
    this._size = 0
    this._items = {}
  }
}
