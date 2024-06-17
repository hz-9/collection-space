/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-28 01:40:30
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-31 10:53:21
 */

import { LinkedListNode, LinkedList } from './_base.linked-list'

/**
 *
 * @class
 * 
 *  单向链表节点
 * 
 */
export class SinglyLinkedListNode<T = any> extends LinkedListNode<T> {}

/**
 *
 * @class
 * 
 *  单向链表
 * 
 */
export class SinglyLinkedList<T = any> extends LinkedList<T, SinglyLinkedListNode<T>> {
  public push(value: T): boolean {
    const node = new SinglyLinkedListNode(value)

    if (!this._head || !this._tail) {
      this._head = node
      this._tail = node
    } else {
      this._tail.next = node
      this._tail = node
    }

    this._size += 1

    return true
  }

  public popNode(): SinglyLinkedListNode<T> | undefined {
    if (!this._tail || !this._head) return undefined
    
    let temp: SinglyLinkedListNode<T> | undefined = undefined
    let current: SinglyLinkedListNode<T> = this._head

    if (!current.next) {
      temp = this._head
      this._head = undefined
      this._tail = undefined
    } else {
      while (current.next!.next) {
        current = current.next!
      }
  
      temp = current.next
      current.next = undefined
      this._tail = current
    }

    this._size -= 1
    return temp
  }

  public unshift(value: T): boolean {
    const node = new SinglyLinkedListNode(value)

    if (!this._head || !this._tail) {
      this._head = node
      this._tail = node
    } else {
      node.next = this._head
      this._head = node
    }

    this._size += 1

    return true
  }

  public shiftNode(): SinglyLinkedListNode<T> | undefined {
    if (!this._tail || !this._head) return undefined

    let temp: SinglyLinkedListNode<T> | undefined = this._head

    if (!temp.next) {
      this._head = undefined
      this._tail = undefined
    } else {
      this._head = temp.next
    }

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

    const prevNode = this.getNodeAt(index - 1)

    if (!prevNode) return false

    const node = new SinglyLinkedListNode(value, prevNode.next)
    prevNode.next = node
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

    const prevNode = this.getNodeAt(index - 1)

    if (!prevNode) return false

    prevNode.next = prevNode.next?.next

    this._size -= 1

    return true
  }

  public remove(value: T): boolean {
    if (this._equalsFn(this.first, value)) {
      this.shiftNode()
      return true
    }

    if (this._equalsFn(this.last, value)) {
      this.popNode()
      return true
    }

    let prev = this._head
    let current = this._head?.next

    while (current) {
      if (this._equalsFn(current.val, value)) {
        prev = current.next
        return true
      }

      prev = current
      current = current.next
    }

    return false
  }
}
