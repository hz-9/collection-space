/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-29 01:33:33
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-29 02:03:41
 */

/**
 * 一个集合扩展类
 */
export class SetPlus<T = any> extends Set<T> {

  /**
   *
   * 与某集合取合集。
   * 
   * @param otherSet
   * 
   * @returns SetPlus 实例。
   *
   */
  public union(otherSet: Set<T>): SetPlus<T> {
    otherSet.forEach(v => this.add(v))
    return this
  }

  /**
   *
   * 与某集合取交集。
   * 
   * @param otherSet
   * 
   * @returns SetPlus 实例。
   *
   */
  public intersection(otherSet: Set<T>): SetPlus<T> {
    this.forEach(v => {
      if (!otherSet.has(v)) {
        this.delete(v)
      }
    })

    return this
  }

  /**
   *
   * 与某集合取差集。当前实例存在，而 otherSet 不存在的元素。
   * 
   * @param otherSet
   * 
   * @returns SetPlus 实例。
   *
   */
  public difference(otherSet: Set<T>): SetPlus<T> {
    this.forEach(v => {
      if (otherSet.has(v)) {
        this.delete(v)
      }
    })

    return this
  }

  /**
   *
   * 判断 otherSet 是否为当前实例的子集。
   * 
   * @param otherSet
   * 
   * @returns 判断结果
   *
   */
  public isSubsetOf(otherSet: Set<T>): boolean {
    if (otherSet.size > this.size) return false

    for (let v of otherSet.values()) {
      if (!this.has(v)) return false
    }

    return true
  }


  /**
   *
   * 进行类型转换。
   * 
   * @returns 转换为 Map 对象。
   *
   */
  public toSet(): Set<T> {
    const set = new Set<T>()
    this.forEach(v => set.add(v))
    return set
  }
  
  /**
   *
   * 取得两个 Set 的合集，并返回 SetPlus 实例。静态函数。
   * 
   * @param setA 
   * @param setB 
   * 
   * @returns 合集，使用 SetPlus 实例。
   *
   */
  public static union<T = any>(setA: Set<T>, setB: Set<T>): SetPlus<T> {
    const set = new SetPlus<T>()

    setA.forEach(v => set.add(v))
    setB.forEach(v => set.add(v))

    return set
  }

  /**
   *
   * 取得两个 Set 的交集，并返回 SetPlus 实例。静态函数。
   * 
   * @param setA 
   * @param setB 
   * 
   * @returns 交集，使用 SetPlus 实例。
   */
  public static intersection<T = any>(setA: Set<T>, setB: Set<T>): SetPlus<T> {
    const set = new SetPlus<T>()

    setA.forEach(v => {
      if (setB.has(v)) {
        set.add(v)
      }
    })

    return set
  }

  /**
   *
   * 取得 SetA 存在，SetB 不存在的元素，并返回 SetPlus 实例。静态函数。
   * 
   * @param setA 
   * @param setB 
   * 
   * @returns 差集，使用 SetPlus 实例。
   */
  public static difference<T = any>(setA: Set<T>, setB: Set<T>): SetPlus<T> {
    const set = new SetPlus<T>()

    setA.forEach(v => {
      if (!setB.has(v)) {
        set.add(v)
      }
    })

    return set
  }

  /**
   *
   * SetB 是否为 SetA 的子集。
   * 
   * @param setA 
   * @param setB 
   * 
   * @returns 判断结果。
   *
   */
  public static isSubsetOf<T = any>(setA: Set<T>, setB: Set<T>): boolean {
    if (setB.size > setA.size) return false

    for (let v of setB.values()) {
      if (!setA.has(v)) return false
    }

    return true
  }
}
