/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-31 20:03:15
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-01 00:32:18
 */

import { Tree, TreeNode } from './_base.tree'

import type { OrderTraverseCallback } from '../types/index'

export class BinarySearchTree<T = any> extends Tree<T> {
  protected _addNode(node: TreeNode<T> | undefined, value: T): TreeNode<T> {
    if (!node) {
      this._size += 1
      return new TreeNode(value)
    }

    const compareResult = this._compareFn(value, node.val)

    if (compareResult < 0) {
      node.left = this._addNode(node.left, value)
      return node
    }
    
    if (compareResult > 0) {
      node.right = this._addNode(node.right, value)
      return node
    }

    return node
  }

  protected _hasNode(node: TreeNode<T> | undefined, value: T): boolean {
    if (!node) return false

    const compareResult = this._compareFn(value, node.val)
    if (compareResult < 0) return this._hasNode(node.left, value)
    if (compareResult > 0) return this._hasNode(node.right, value)
    return true
  }

  protected _removeNode(node: TreeNode<T> | undefined, value: T): TreeNode<T> | undefined {
    if (!node) return undefined

    const compareResult = this._compareFn(value, node.val)

    if (compareResult < 0) {
      node.left = this._removeNode(node.left, value)
      return node
    }

    if (compareResult > 0) {
      node.right = this._removeNode(node.right, value)
      return node
    }

    if (!node.left && !node.right) {
      this._size += 1
      return undefined
    }

    if (!node.left) {
      this._size += 1
      return node.right
    }
    if (!node.right) {
      this._size += 1
      return node.left
    }

    const rightMinNode = this._minNode(node.right)!
    node.val = rightMinNode.val
    node.right = this._removeNode(node.right, rightMinNode.val)
    return node
  }

  protected _minNode(node: TreeNode<T> | undefined): TreeNode<T> | undefined {
    let node_: TreeNode<T> | undefined = node

    while (node_?.left) {
      node_ = node_?.left
    }
   
    return node_
  }

  protected _maxNode(node: TreeNode<T> | undefined): TreeNode<T> | undefined {
    let node_: TreeNode<T> | undefined = node

    while (node_?.right) {
      node_ = node_?.right
    }
   
    return node_
  }

  protected _inOrderTraverseNode(node: TreeNode<T> | undefined, callback: OrderTraverseCallback<T>): void {
    if (node) {
      this._inOrderTraverseNode(node.left, callback)
      callback(node.val)
      this._inOrderTraverseNode(node.right, callback)
    }
  }

  protected _preOrderTraverseNode(node: TreeNode<T> | undefined, callback: OrderTraverseCallback<T>): void {
    if (node) {
      callback(node.val)
      this._preOrderTraverseNode(node.left, callback)
      this._preOrderTraverseNode(node.right, callback)
    }
  }

  protected _postOrderTraverseNode(node: TreeNode<T> | undefined, callback: OrderTraverseCallback<T>): void {
    if (node) {
      this._postOrderTraverseNode(node.left, callback)
      this._postOrderTraverseNode(node.right, callback)
      callback(node.val)
    }
  }
}
