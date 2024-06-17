/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-01 00:20:20
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-01 00:44:56
 */

import { TreeNode } from './_base.tree'

import { BinarySearchTree } from './binary-search.tree'

export class AdelsonVelskiiLandiTree<T = any> extends BinarySearchTree<T> {
  protected _addNode(node: TreeNode<T> | undefined, value: T): TreeNode<T> {
    // TODO 并未完全掌握，对流程图理解不细致
    if (!node) {
      this._size += 1
      return new TreeNode(value)
    }

    const compareResult = this._compareFn(value, node.val)

    if (compareResult < 0) {
      node.left = this._addNode(node.left, value)
    } else if (compareResult > 0) {
      node.right = this._addNode(node.right, value)
    } else {
      return node
    }

    // 进行平衡操作 AVL 旋转
    const balanceFactor = this._getBalanceFactor(node)
    if (balanceFactor === 2) {
      const compareResult = this._compareFn(value, node.left!.val)

      if (compareResult < 0) {
        return this._rotationLL(node)
      }

      return this._rotationLR(node)
    }

    if (balanceFactor === -2) {
      const compareResult = this._compareFn(value, node.left!.val)

      if (compareResult > 0) {
        return this._rotationRR(node)
      }

      return this._rotationRL(node)
    }

    return node
  }

  protected _removeNode(node: TreeNode<T> | undefined, value: T): TreeNode<T> | undefined {
    // TODO 并未完全掌握，对流程图理解不细致

    node = super._removeNode(node, value)
    if (!node) return undefined

    const balanceFactor = this._getBalanceFactor(node)
    if (balanceFactor === 2) {
      const balanceFactorLeft = this._getBalanceFactor(node.left!)
      if (balanceFactorLeft === 0 || balanceFactorLeft === 1) {
        return this._rotationLL(node)
      }

      if (balanceFactorLeft === -1) {
        return this._rotationLR(node.left!)
      }
    }

    if (balanceFactor === -2) {
      const balanceFactorLeft = this._getBalanceFactor(node.right!)
      if (balanceFactorLeft === 0 || balanceFactorLeft === -1) {
        return this._rotationRR(node)
      }

      if (balanceFactorLeft === 1) {
        return this._rotationRL(node.right!)
      }
    }

    return node
  }

  /**
   * 获取节点高度。
   *
   * @param {TreeNode<T> | undefined} node - 节点
   *
   * @returns 节点高度。若节点缺失，则为 -1
   */
  protected _getNodeHeight(node: TreeNode<T> | undefined): number {
    if (!node) return -1
    return Math.max(this._getNodeHeight(node.left), this._getNodeHeight(node.right)) + 1
  }

  /**
   * 获取节点高度差距
   *
   * @param {TreeNode<T> | undefined} node - 节点
   *
   * @returns 高度差。通常为 -2, -1, 0, 1, 2 五个整数
   */
  protected _getBalanceFactor(node: TreeNode<T>): number {
    const diff = this._getNodeHeight(node.left) - this._getNodeHeight(node.right)
    return diff
  }

  protected _rotationLL(node: TreeNode<T>): TreeNode<T> {
    const tmp: TreeNode<T> = node.left!
    node.left = tmp.right
    tmp.right = node
    return tmp
  }

  protected _rotationRR(node: TreeNode<T>): TreeNode<T> {
    const tmp: TreeNode<T> = node.right!
    node.right = tmp.left
    tmp.left = node
    return tmp
  }

  protected _rotationLR(node: TreeNode<T>): TreeNode<T> {
    node.left = this._rotationRR(node.left!)
    return this._rotationLL(node) 
  }

  protected _rotationRL(node: TreeNode<T>): TreeNode<T> {
    node.right = this._rotationRR(node.right!)
    return this._rotationLL(node) 
  }
}
