/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:30:30
 */

/**
 *
 * Simulate the implementation of the 'instanceof' keyword.
 *
 * @param left - The left-hand side parameter of 'instanceof'.
 * @param right - The right-hand side parameter of 'instanceof'.
 *
 * @returns The result of the type check.
 */
export function myInstanceof(left: any, right: any): boolean {
  if (right === null || (typeof right !== 'object' && typeof right !== 'function')) {
    throw new TypeError("Right-hand side of 'instanceof' is not an object")
  }

  let r = right.prototype
  let l = left.__proto__

  // If not found, keep looping until the parent type or ancestor type is reached.
  while (true) {
    if (l === null) {
      return false
    }
    if (l === r) {
      return true
    }

    l = l.__proto__ // Get the __proto__ of the ancestor type.
  }
}
