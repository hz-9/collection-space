/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 22:41:34
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-11 22:30:12
 */
const cls = require('cls-hooked')

const nsid = 'a6a29a6f-6747-4b5f-b99f-07ee96e32f88'
const ns = cls.createNamespace(nsid)

let id = 0

const generateRId = () => {
  id += 1
  return `${id}`
}

const get = (key, value) => ns.get(key, value)
const set = (key, value) => ns.set(key, value)

const ridMiddleware = (req, res, next) => {
  ns.run(() => {
    const rid = generateRId()
    set('rid', rid)
    next()
  })
}

module.exports = {
  ridMiddleware,
  get,
  set,
}
