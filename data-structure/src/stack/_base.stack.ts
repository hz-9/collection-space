/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 01:29:40
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 16:43:39
 */

/**
 *
 * @class
 *
 *  栈基类
 *
 */
export abstract class Stack<T = any> {
  /**
   * 栈内元素数量
   */
  public abstract get size(): number
  
  /**
   * 栈内是否为空
   */
  public abstract get isEmpty(): boolean

  /**
   * 
   * 在栈顶添加一个新元素。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 待添加的元素
   * 
   */
  public abstract push(val: T): void

  /**
   * 
   * 返回栈顶的元素，但不从栈内移除。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @returns 栈顶的元素，若栈为空，则返回 undefined
   * 
   */
  public abstract peek(): T | undefined

  /**
   * 
   * 返回栈顶的元素，并从栈内移除。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @returns 栈顶的元素，若栈为空，则返回 undefined
   * 
   */
  public abstract pop(): T | undefined

  /**
   * 
   * 清空栈内所有元素。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   */
  public abstract clear(): void
}