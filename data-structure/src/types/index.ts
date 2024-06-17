/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 17:52:10
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-13 23:24:38
 */

/**
 * .find 遍历函数 回调参数类型
 */
export type FindCallback<T> = (value: T) => boolean

/**
 * 中序遍历、先序遍历、后序遍历 回调函数
 */
export type OrderTraverseCallback<T> = (value: T) => void

/**
 * 广度优先搜索、深度优先搜索 回调函数。
 */
export type SearchCallback<T, E> = (value: T, edge: E) => void
