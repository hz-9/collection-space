/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-04 19:18:58
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:38:52
 */

const obj1 = {
  name: 'katz',
  hobby: 'Play backetball',
  fn: function () {
    console.log('hobby', this.hobby)
  },
}

const obj = {
  hobby: 'Code typing',
}

// @ts-ignore
Function.prototype.myCall = function (context = globalThis, ...args) {
  if (typeof this !== 'function')
    throw new TypeError('Function.prototype.myCall - what is trying to be bound is not callable')

  const customKey = Symbol('apply') // A unique value, it doesn't have to be 'fn', it can be any string.
  context[customKey] = this // Bind the function object that will be executed by the call function and pass in the arguments.
  const result = context[customKey](...args)

  delete context[customKey]
  return result
}

obj1.fn()
// @ts-ignore
obj1.fn.myCall(obj)

export = {}
