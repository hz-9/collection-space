/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 23:28:24
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:39:03
 */

import { MyPromise } from './my-promise'
const assert = require('assert')

module.exports = {
  defer: function () {
    let dfd: Record<string, any> = {}
    dfd.promise = new MyPromise((resolve, reject) => {
      dfd.resolve = resolve
      dfd.reject = reject
    })
    return dfd
  },
  deferred: function () {
    let dfd: Record<string, any> = {}
    dfd.promise = new MyPromise((resolve, reject) => {
      dfd.resolve = resolve
      dfd.reject = reject
    })
    return dfd
  },
  defineGlobalPromise: function (global) {
    global.MyPromise = MyPromise
    global.assert = assert
  },
  removeGlobalPromise: function (global) {
    delete global.MyPromise
  },
}
