/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-04 19:18:47
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:38:25
 */

function fn(x, y) {
  console.log(this.hobby)
  console.log(x + y)
}

const obj = {
  hobby: 'Code typing',
}

// @ts-ignore
Function.prototype.myBind = function (context = globalThis, ...args) {
  if (typeof this !== 'function')
    throw TypeError('Function.prototype.mybind - what is trying to be bound is not callable.')

  const Self = this
  const Bound = function (...args2) {
    return Self.apply(this instanceof Bound ? this : context, [...args, ...args2])
  }

  // Maintain prototype relationship
  const NOP = function () {}
  if (this.prototype) {
    NOP.prototype = this.prototype
  }
  // The following code makes Bound.prototype an instance of NOP, so
  // if Bound is used as a constructor with the new keyword, the newly created object passed as this to Bound will have its __proto__ as an instance of NOP.
  Bound.prototype = new NOP()

  return Bound
}

fn(2, 3)
// @ts-ignore
console.log(typeof fn.myBind(obj, 1, 2))
// @ts-ignore
fn.myBind(obj, 1, 2)()

export = {}
