/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 11:26:48
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:39:01
 */

function myNew(foo, ...args) {
  const obj = Object.create(foo.prototype)
  const result = foo.apply(obj, args)
  return result instanceof Object ? result : obj
}

function Foo(name) {
  this.name = name
}

const newObj = myNew(Foo, 'zhangsan')
console.log(newObj) // Foo {name: "zhangsan"}
console.log(newObj instanceof Foo) // true
console.log(newObj instanceof Object) // true
