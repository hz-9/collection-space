
const obj1 = {
  name: '假装文艺浪',
  hobby: '打篮球',
  fn: function (x, y) {
    console.log('爱好',this.hobby)
    console.log(x + y)
  }
}

const obj = {
  hobby: '敲代码'
}

// @ts-ignore
Function.prototype.myApply = function(context = globalThis, args = []) {
  if (typeof this !== 'function') throw TypeError('Function.prototype.myApply - what is trying to be bound is not callable')

  const customKey = Symbol('apply') // 一个不会重复的值，并非必须为 'fn'，可以是任意字符串。
  context[customKey] = this // 将被执行 apply 函数的函数对象进行绑定，并传入参数
  const result = context[customKey](...args)

  delete context[customKey]
  return result
}

obj1.fn(2,3)

// @ts-ignore
obj1.fn.myApple(obj,[1,2])

export = {}