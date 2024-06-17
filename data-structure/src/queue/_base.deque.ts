/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-30 20:09:00
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 11:20:19
 */

import { Queue } from './_base.queue'

/**
 *
 * @class
 * 
 *  双向队列基类
 * 
 */
export abstract class Deque<T = any> extends Queue<T> {
  /**
   * 
   * 在队列头部添加一个新元素。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 待添加的元素
   * 
   */
  public abstract unshift(value: T): void

  /**
   * 
   * 返回队列尾的元素，并从队列内移除。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   * @returns 队列顶的元素，队列栈为空，则返回 undefined
   * 
   */
  public abstract pop(): T | undefined
}
