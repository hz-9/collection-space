/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 12:58:01
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 18:43:15
 */

import { EMPTY_KEY_VALUE, KeyValue } from './_base.hashmap'

import { SimpleHashmap } from './simple.hashmap'

/**
 *
 * @class
 *
 * 一个线性探查的哈希表。
 *
 */
export class LinearProbingHashmap<K = any, V = any> extends SimpleHashmap<K, V> {
  public get size(): number {
    return this._size
  }

  public get isEmpty(): boolean {
    return this.size === 0
  }

  public set(key: K, value: V): boolean {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))

    let index = keyStr
    while (!this._items[keyStr] || this._items[keyStr] === EMPTY_KEY_VALUE) {
      index += 1
    }

    this._items[index] = new KeyValue<K, V>(key, value)
    return true
  }

  public get(key: K): V | undefined {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))
    if (!this._items[keyStr]) return undefined

    let index = keyStr
    while (this._items[keyStr]) {
      const g = this._items[index]
      if (g.key === key) return g.value

      index += 1
    }

    return undefined
  }

  public remove(key: K): boolean {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))
    if (!this._items[keyStr]) return false

    let index = keyStr
    while (this._items[keyStr]) {
      const g = this._items[index]

      if (g.key === key) {
        this._items[index] = EMPTY_KEY_VALUE
        this._size -= 1
        return true
      }

      index += 1
    }

    return false
  }
}
