/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-20 22:05:59
 */

/**
 * 函数节流。n 秒内只运行一次，若在 n 秒内重复触发，只有一次生效。
 * 
 * 一个最简单的实现。
 *
 * @param {() => any} func - 待执行函数
 * @param {number} delay - 等待时间
 */
export function throttle(func: () => any, delay: number): () => void {
  let timer: number | NodeJS.Timeout | undefined = undefined;

  return function() {
    if (timer === undefined) {
      timer = setTimeout(() => {
        func()
        timer = undefined
      }, delay)
    }
  }
}
