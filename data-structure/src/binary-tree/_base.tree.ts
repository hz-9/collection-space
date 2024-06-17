/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 20:03:20
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-01 00:09:40
 */

import { defaultEquals, defaultCompare } from '../utils/index'

import type { OrderTraverseCallback } from '../types/index'

/**
 * @class
 * 
 *  树结构节点
 * 
 */
export class TreeNode<T = any> {
  public val: T
  
  public left?: TreeNode<T>

  public right?: TreeNode<T>

  public constructor(val: T, left?: TreeNode<T>, right?: TreeNode<T>) {
    this.val = val

    this.left = left

    this.right = right
  }
}

export abstract class Tree<T = any> {
  protected _size: number

  protected _root?: TreeNode<T>

  /**
   * 相等判断函数
   */
  protected readonly _equalsFn: (a?: T, b?: T) => boolean

  /**
   * 相等判断函数
   */
  protected readonly _compareFn: (a?: T, b?: T) => number

  public constructor(equalsFn = defaultEquals, compareFn = defaultCompare) {
    this._equalsFn = equalsFn

    this._compareFn = compareFn

    this._size = 0
  }

  /**
   * 树节点数量
   */
  public get size(): number {
    return this._size
  }

  /**
   * 树是否为空
   */
  public get isEmpty(): boolean {
    return this._size === 0
  }

  /**
   * 
   * 添加一个元素。重复的键，不会重复添加。
   *
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 待添加的元素
   *
   */
  public add(value: T): void {
    this._root = this._addNode(this._root, value)
  }

  /**
   * 
   * 加入某元素至某节点中
   * 
   * @param {TreeNode<T> | undefined} node - 基准接节点
   * @param {T} value - 待添加的元素
   */
  protected abstract _addNode(node: TreeNode<T> | undefined, value: T): TreeNode<T>

  /**
   * 
   * 是否存在某元素。
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 咨询的元素
   * 
   * @returns 是否存在。
   */
  public has(value: T): boolean {
    return this._hasNode(this._root, value)
  }

  /**
   * 
   * 某节点下，是否有某元素
   * 
   * @param {TreeNode<T> | undefined} node - 基准接节点
   * @param {T} value - 待添加的元素
   */
  protected abstract _hasNode(node: TreeNode<T> | undefined, value: T): boolean

  /**
   * 
   * 移除一个元素。。
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {T} value - 待移除的元素
   *
   */
  public remove(value: T): void {
    this._removeNode(this._root, value)
  }

  /**
   * 
   * 在某节点下删除某元素
   * 
   * @param {TreeNode<T> | undefined} node - 基准接节点
   * @param {T} value - 待删除的元素
   */
  protected abstract _removeNode(node: TreeNode<T> | undefined, value: T): TreeNode<T> | undefined

  /**
   * 
   * 查询树结构的最小值。
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @returns 树结构最小值。若树结构为空，则返回 undefined.
   */
  public min(): T | undefined {
    return this._minNode(this._root)?.val
  }

  /**
   * 
   * 在某节点下获取最小元素
   * 
   * @param {TreeNode<T> | undefined} node - 基准接节点
   */
  protected abstract _minNode(node: TreeNode<T> | undefined): TreeNode<T> | undefined

  /**
   * 
   * 查询树结构的最大值。
   * 
   * 时间复杂度: O(log n)
   *
   * 空间复杂度: O(1)
   * 
   * @returns 树结构最大值。若树结构为空，则返回 undefined.
   */
  public max(): T | undefined {
    return this._maxNode(this._root)?.val
  }

  /**
   * 
   * 在某节点下获取最大元素
   * 
   * @param {TreeNode<T> | undefined} node - 基准接节点
   */
  protected abstract _maxNode(node: TreeNode<T> | undefined): TreeNode<T> | undefined


  /**
   * 
   * 通过中序遍历方式遍历所有节点。
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {OrderTraverseCallback<T>} callback - 遍历的回调函数
   *
   */
  public inOrderTraverse(callback: OrderTraverseCallback<T>): void {
    this._inOrderTraverseNode(this._root, callback)
  }

  /**
   * 
   * 中序遍历该节点
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {OrderTraverseCallback<T>} callback - 遍历的回调函数
   *
   */
  protected abstract _inOrderTraverseNode(node: TreeNode<T> | undefined, callback: OrderTraverseCallback<T>): void

  /**
   * 
   * 通过先序遍历方式遍历所有节点。
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {OrderTraverseCallback<T>} callback - 遍历的回调函数
   *
   */
  public preOrderTraverse(callback: OrderTraverseCallback<T>): void {
    this._preOrderTraverseNode(this._root, callback)
  }

  /**
   * 
   * 先序遍历该节点
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {OrderTraverseCallback<T>} callback - 遍历的回调函数
   *
   */
  protected abstract _preOrderTraverseNode(node: TreeNode<T> | undefined, callback: OrderTraverseCallback<T>): void

  /**
   * 
   * 通过后序遍历方式遍历所有节点。
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {OrderTraverseCallback<T>} callback - 遍历的回调函数
   *
   */
  public postOrderTraverse(callback: OrderTraverseCallback<T>): void {
    this._postOrderTraverseNode(this._root, callback)
  }

  /**
   * 
   * 先序遍历该节点
   * 
   * 时间复杂度: O(n)
   *
   * 空间复杂度: O(1)
   * 
   * @param {OrderTraverseCallback<T>} callback - 遍历的回调函数
   *
   */
  protected abstract _postOrderTraverseNode(node: TreeNode<T> | undefined, callback: OrderTraverseCallback<T>): void

  /**
   * 
   * 清除树结构。
   * 
   * 时间复杂度: O(1)
   *
   * 空间复杂度: O(1)
   * 
   */
  public clear(): void {
    this._root = undefined
    this._size = 0
  }
}

