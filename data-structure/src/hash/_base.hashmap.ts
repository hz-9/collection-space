/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 12:39:45
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 18:34:29
 */

/**
 *
 * @class
 * 
 *  一个键值对。
 * 
 */
export class KeyValue<K = any, V = any> {
  public readonly key: K

  public readonly value: V

  public constructor (key: K, value: V) {
    this.key = key

    this.value = value
  }
}

/**
 * 一个空的 KeyValue
 */
export const EMPTY_KEY_VALUE: KeyValue<any, any> = new KeyValue(Symbol('__EMPTY_KEY_VALUE__'), Symbol('__EMPTY_KEY_VALUE__'))

export type ToKeyStr<K> = (key: K) => string

export type ToHashCode = (keyStr: string) => number

/**
 * @class
 * 
 *  一个 Hash 表基类。
 * 
 */
export abstract class Hashmap<K = any, V = any> {
  /**
   * 哈希表内元素数量
   */
  public abstract get size(): number

  /**
   * 哈希表内是否为空
   */
  public abstract get isEmpty(): boolean

  /**
   *
   * 添加键值对至哈希表。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   *
   * @param {K} key - 键对象
   * @param {V} value - 值信息
   * 
   * @returns 是否添加成功。false 时，可能为该键已存在数据。
   */
  public abstract set(key: K, value: V): boolean

  /**
   *
   * 根据键从哈希表中获取值。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {K} key - 键对象
   * 
   * @returns 值对象。若无该对象，则返回 undefined。
   */
  public abstract get(key: K): V | undefined

  /**
   *
   * 判断在哈希表中是否有该键的值。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {K} key - 键对象
   *
   * @returns 是否有该键的值。
   */
  public abstract has(key: K): boolean


  /**
   * 
   * 在哈希表中删除该键。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {K} key - 键对象
   * 
   * @returns 是否删除成功。
   *
   */
  public abstract remove(key: K): boolean

  /**
   * 
   * 清空队哈希表中所有信息。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   */
  public abstract clear(): void
}

