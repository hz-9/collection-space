/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-04 19:18:50
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:38:22
 */
const obj1 = {
  name: 'katz',
  hobby: 'Play backetball',
  fn: function (x, y) {
    console.log('Hobby: ', this.hobby)
    console.log(x + y)
  },
}

const obj = {
  hobby: 'Code typing',
}

// @ts-ignore
Function.prototype.myApply = function (context = globalThis, args = []) {
  if (typeof this !== 'function')
    throw TypeError('Function.prototype.myApply - what is trying to be bound is not callable')

  const customKey = Symbol('apply') // A unique value, it doesn't have to be 'fn', it can be any string.
  context[customKey] = this // Bind the function object to be executed by the apply function and pass in the arguments
  const result = context[customKey](...args)

  delete context[customKey]
  return result
}

obj1.fn(2, 3)

// @ts-ignore
obj1.fn.myApple(obj, [1, 2])

export = {}
