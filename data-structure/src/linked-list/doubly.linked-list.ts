/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-28 01:40:30
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-06-17 13:20:12
 */

import { LinkedListNode, LinkedList } from './_base.linked-list'

/**
 *
 * @class
 * 
 *  双向链表节点
 * 
 */
export class DoublyLinkedListNode<T = any> extends LinkedListNode<T> {
  /**
   * 上一个节点。
   */
  public prev: DoublyLinkedListNode<T> | undefined

  declare public next: DoublyLinkedListNode<T> | undefined

  public constructor(val: T, prev?: DoublyLinkedListNode<T>, next?: DoublyLinkedListNode<T>) {
    super(val, next)

    this.prev = prev
  }
}

/**
 *
 * @class
 * 
 *  双向链表
 * 
 */
export class DoublyLinkedList<T = any> extends LinkedList<T, DoublyLinkedListNode<T>> {
  public push(value: T): boolean {
    const node = new DoublyLinkedListNode(value)

    if (!this._head || !this._tail) {
      this._head = node
      this._tail = node
    } else {
      this._tail.next = node
      node.prev = this._tail

      this._tail = node
    }

    this._size += 1

    return true
  }

  public popNode(): DoublyLinkedListNode<T> | undefined {
    if (!this._tail || !this._head) return undefined

    let temp: DoublyLinkedListNode<T> = this._tail

    if (!temp.prev) {
      this._head = undefined
      this._tail = undefined
    } else {
      this._tail = temp.prev

      this._tail.next = undefined
    }

    temp.prev = undefined
    temp.next = undefined

    this._size -= 1
    return temp
  }

  public unshift(value: T): boolean {
    const node = new DoublyLinkedListNode(value)

    if (!this._head || !this._tail) {
      this._head = node
      this._tail = node
    } else {
      node.next = this._head
      this._head.next = node

      this._head = node
    }

    this._size += 1

    return true
  }

  public shiftNode(): DoublyLinkedListNode<T> | undefined {
    if (!this._tail || !this._head) return undefined

    let temp: DoublyLinkedListNode<T> = this._head

    if (!temp.next) {
      this._head = undefined
      this._tail = undefined
    } else {
      this._head = temp.next
      this._head.prev = undefined
    }

    temp.prev = undefined
    temp.next = undefined

    this._size -= 1
    return temp
  }

  public addAt(index, value): boolean {
    if (index < 0 || index > this.size) return false

    if (index === 0) {
      this.unshift(value)
      return true
    }

    if (index === this.size - 1) {
      this.push(value)
      return true
    }

    const currentNode = this.getNodeAt(index)

    if (!currentNode) return false

    const node = new DoublyLinkedListNode(value, currentNode.prev, currentNode)

    if (currentNode.prev) currentNode.prev.next = node
    currentNode.prev = node

    this._size += 1
    return true
  }

  public removeAt(index): boolean {
    if (index < 0 || index > this.size) return false

    if (index === 0) {
      this.shiftNode()
      return true
    }

    if (index === this.size - 1) {
      this.popNode()
      return true
    }

    const currentNode = this.getNodeAt(index)
    if (!currentNode) return false

    if (currentNode.prev) currentNode.prev.next = currentNode.next
    if (currentNode.next) currentNode.next.prev = currentNode.prev

    this._size -= 1
    return true
  }

  public remove(value: T) {
    if (this._equalsFn(this.first, value)) {
      this.shiftNode()
      return true
    }

    if (this._equalsFn(this.last, value)) {
      this.popNode()
      return true
    }

    const currentNode = this.getNode(value)
    if (!currentNode) return false

    if (currentNode.prev) currentNode.prev.next = currentNode.next
    if (currentNode.next) currentNode.next.prev = currentNode.prev

    this._size -= 1
    return true
  }
}
