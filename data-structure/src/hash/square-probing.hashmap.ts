/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 12:58:01
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 18:42:57
 */

import { EMPTY_KEY_VALUE, KeyValue } from './_base.hashmap'

import { SimpleHashmap } from './simple.hashmap'

/**
 *
 * @class
 *
 * 一个平方探查的哈希表。
 *
 */
export class SquareProbingHashmap<K = any, V = any> extends SimpleHashmap<K, V> {
  public set(key: K, value: V): boolean {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))

    let index = 0
    while (!this._items[keyStr + index ** 2] || this._items[keyStr + index ** 2] === EMPTY_KEY_VALUE) {
      index += 1
    }

    this._items[keyStr + index ** 2] = new KeyValue<K, V>(key, value)
    return true
  }

  public get(key: K): V | undefined {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))
    if (!this._items[keyStr]) return undefined

    let index = 0
    while (this._items[keyStr + index ** 2]) {
      const g = this._items[keyStr + index ** 2]
      if (g.key === key) return g.value

      index += 1
    }

    return undefined
  }

  public remove(key: K): boolean {
    const keyStr: number = this._toHashCode(this._toKeyStr(key))
    if (!this._items[keyStr]) return false

    let index = 0
    while (this._items[keyStr + index ** 2]) {
      const g = this._items[keyStr + index ** 2]

      if (g.key === key) {
        this._items[keyStr + index ** 2] = EMPTY_KEY_VALUE
        this._size -= 1
        return true
      }

      index += 1
    }

    return false
  }
}
