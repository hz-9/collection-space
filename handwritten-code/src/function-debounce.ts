/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 11:17:37
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
  let timer: number | NodeJS.Timeout | undefined = undefined

  return function() {
    const context = this
    const args = arguments

    clearTimeout(timer)
    timer = setTimeout(() => {
      func.apply(context, args)
    }, delay)
  }
}
