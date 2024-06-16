/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-20 19:37:14
 */

/**
 *
 * 模拟实现 instanceof 关键字
 *
 * @param left - instanceof 左侧参数
 * @param right - instanceof 右侧参数
 *
 * @returns 类型判断结果
 */
export function myInstanceof(left: any, right: any): boolean {
  if (right === null || (typeof right !== 'object' && typeof right !== 'function')) {
    throw new TypeError("Right-hand side of 'instanceof' is not an object")
  }

  let r = right.prototype
  let l = left.__proto__

  // 若找不到就到一直循环到父类型或祖类型
  while (true) {
    if (l === null) {
      return false
    }
    if (l === r) {
      return true
    }

    l = l.__proto__ // 获取祖类型的__proto__
  }
}
