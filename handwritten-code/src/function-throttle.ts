/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:38:15
 */

/**
 * A simple implementation of throttle function.
 *
 * Executes the function only once within n seconds. If triggered repeatedly within n seconds, only one execution takes effect.
 *
 * @param {() => any} func - The function to be executed.
 * @param {number} delay - The waiting time.
 */
export function throttle(func: () => any, delay: number): () => void {
  let timer: number | NodeJS.Timeout | undefined = undefined

  return function () {
    if (timer === undefined) {
      const context = this
      const args = arguments

      timer = setTimeout(() => {
        func.apply(context, args)
        timer = undefined
      }, delay)
    }
  }
}
