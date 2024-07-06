/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-04 19:18:47
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 11:15:19
 */

function fn(x,y) {
  console.log(this.hobby)
  console.log(x + y)
}

let obj = {
  hobby: '敲代码'
}

// @ts-ignore
Function.prototype.myBind = function(context = globalThis, ...args) {
  if (typeof this !== 'function') throw TypeError('Function.prototype.mybind - what is trying to be bound is not callable.')

  const Self = this
  const Bound = function(...args2) {
    return Self.apply(this instanceof Bound ? this : context, [...args, ...args2])
  }

  // 维护原型关系
  const NOP = function() {}
  if (this.prototype) {
    NOP.prototype = this.prototype; 
  }
  // 下行的代码使 Bound.prototype 是 NOP 的实例,因此
  // 返回的 Bound 若作为 new 的构造函数，new 生成的新对象作为 this 传入 Bound，新对象的 __proto__ 就是 NOP 的实例。
  Bound.prototype = new NOP();

  return Bound
}

fn(2,3)
// @ts-ignore
console.log(typeof fn.myBind(obj,1,2))
// @ts-ignore
fn.myBind(obj,1,2)()

export = {}
