/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 12:58:01
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 18:49:01
 */

import { ToKeyStr, ToHashCode } from './_base.hashmap'

import { SquareProbingHashmap } from './square-probing.hashmap'

import { djb2HashCode } from './hash-code'

/**
 * 
 * @class
 *
 * 一个比较合适的哈希表，采用 djb2 哈希算法，以及平方探测，用以解决冲突。
 *
 */
export class BetterHashmap<K = any, V = any> extends SquareProbingHashmap<K, V> {
  public constructor(toKeyStr: ToKeyStr<K>, toHashCode: ToHashCode = djb2HashCode) {
    super(toKeyStr, toHashCode)
  }
}
