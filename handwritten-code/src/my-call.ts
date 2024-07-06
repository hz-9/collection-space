/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-04 19:18:58
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 11:15:25
 */

var obj1 = {
  name: '假装文艺浪',
  hobby: '打篮球',
  fn: function () {
    console.log('爱好', this.hobby)
  }
}

let obj = {
  hobby: '敲代码'
}

// @ts-ignore
Function.prototype.myCall = function(context = globalThis, ...args) {
  if (typeof this !== 'function') throw new TypeError('Function.prototype.myCall - what is trying to be bound is not callable')

  const customKey = Symbol('apply') // 一个不会重复的值，并非必须为 'fn'，可以是任意字符串。
  context[customKey] = this // 将被执行 call 函数的函数对象进行绑定，并传入参数
  const result = context[customKey](...args)

  delete context[customKey]
  return result
}

obj1.fn()
// @ts-ignore
obj1.fn.myCall(obj)

export = {}
