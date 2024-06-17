/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-28 01:40:30
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 10:53:49
 */

import { DoublyLinkedListNode, DoublyLinkedList } from './doubly.linked-list'

/**
 *
 * @class
 * 
 *  循环链表。
 * 
 *  循环链表可以集成单向链表，也可以继承双向链表，此处继承双向链表实现。
 * 
 */
export class CircularLinkedList<T = any> extends DoublyLinkedList<T> {
  public push(value: T): boolean {
    const node = new DoublyLinkedListNode(value)

    if (!this._head || !this._tail) {
      this._head = node
      this._tail = node

      node.next = node
      node.prev = node
    } else {
      this._tail.next = node
      node.prev = this._tail
      this._tail = node

      // 重新关联 this._head、this._tail
      this._tail.next = this._head
      this._head.prev = this._tail
    }

    this._size += 1

    return true
  }

  public popNode(): DoublyLinkedListNode<T> | undefined {
    if (!this._tail || !this._head) return undefined

    let temp: DoublyLinkedListNode<T> = this._tail

    if (temp.prev === temp) {
      this._head = undefined
      this._tail = undefined
    } else {
      this._tail.prev!.next = this._head
      this._head.prev = this._tail.prev
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

      node.next = node
      node.prev = node
    } else {
      this._head.prev = node
      node.next = this._head
      this._head = node

      // 重新关联 this._head、this._tail
      this._tail.next = this._head
      this._head.prev = this._tail
    }

    this._size += 1

    return true
  }

  public shiftNode(): DoublyLinkedListNode<T> | undefined {
    if (!this._tail || !this._head) return undefined

    let temp: DoublyLinkedListNode<T> = this._head

    if (temp.next === temp) {
      this._head = undefined
      this._tail = undefined
    } else {
      this._head.next!.prev = this._tail
      this._tail.next = this._head.next
    }

    temp.prev = undefined
    temp.next = undefined

    this._size -= 1
    return temp
  }
}
