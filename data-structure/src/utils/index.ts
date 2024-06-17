/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 20:20:14
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-02 12:49:15
 */

/**
 * 
 * 判断 a 与 b 是否相等
 * 
 * @param a 
 * @param b 
 * @returns 判断结果
 *
 */
export const defaultEquals = <T>(a?: T, b?: T): boolean => a === b

/**
 * 
 * 比较 a 与 b 大小关系
 * 
 * @param a 
 * @param b 
 * @returns 判断结果
 *
 */
export const defaultCompare = <T>(a: T, b: T): number => {
  if (a === b) return 0
  return a < b ? -1 : 1
}

/**
 * 
 * 从数组中，移除元素
 * 
 * @param array - 待处理的元素
 * @param callback - 判断的数组
 *
 * @returns 移除的元素组成的数组。
 *
 */
export const arrayRemove = function <T>(array: Array<T>, callback: (item: T, index: number, array: T[]) => boolean): T[] {
  let i = -1
  let len = array ? array.length : 0
  const result: Array<T> = []

  while (++i < len) {
    const value = array[i]
    if (callback(value, i, array)) {
      result.push(value)
  
      Array.prototype.splice.call(array, i--, 1)
      len--
    }
  }

  return result
}
