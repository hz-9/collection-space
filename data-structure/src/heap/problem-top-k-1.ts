/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-02 10:58:22
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-02 11:04:08
 */

/**
 *
 * Top-k 问题。
 *
 * 排序方案。
 *
 */
export function findTopK(arr: number[], k: number): number[] {
  const sorted = [...arr].sort((a, b) => b - a)
  return sorted.slice(0, k)
}
