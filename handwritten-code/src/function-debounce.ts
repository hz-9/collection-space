/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-06-16 10:52:54
 */

/**
 *
 * 函数防抖。n 秒后在执行该事件，若在 n 秒内被重复触发，则重新计时。
 * 
 * 一个最简单的实现。
 *
 * @param {() => any} func - 待执行函数
 * @param {number} delay - 等待时间
 */
export function debounce(func: () => any, delay: number): () => void {
  let timer: number | NodeJS.Timeout | undefined = undefined;

  return function() {
    clearTimeout(timer)
    timer = setTimeout(func, delay)
  }
}
