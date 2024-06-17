/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 17:08:59
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 17:25:28
 */

import type { ToHashCode } from './_base.hashmap'

/**
 * loselose 散列函数
 */
export const loseloseHashCode: ToHashCode = (tableKey: string): number => {  
  let hash = 0
  for (let i = 0; i < tableKey.length; i += 1) {
    hash += tableKey.charCodeAt(i)
  }
  return hash % 37
}

/**
 * djb2 散列函数。比 loselose 散列函数更好
 */
export const djb2HashCode: ToHashCode = (tableKey: string): number => {  
  let hash = 5381

  for (let i = 0; i < tableKey.length; i += 1) {
    hash += (hash * 33) + tableKey.charCodeAt(i)
  }

  return hash % 1013
}
