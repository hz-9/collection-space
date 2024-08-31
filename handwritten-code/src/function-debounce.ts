/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:38:10
 */

/**
 *
 * A simple implementation of the debounce function.
 *
 * Executes the event after n seconds. If triggered repeatedly within n seconds, the timer is reset.
 *
 * @param {() => any} func - The function to be executed
 * @param {number} delay - The waiting time
 */
export function debounce(func: () => any, delay: number): () => void {
  let timer: number | NodeJS.Timeout | undefined = undefined

  return function () {
    const context = this
    const args = arguments

    clearTimeout(timer)
    timer = setTimeout(() => {
      func.apply(context, args)
    }, delay)
  }
}
