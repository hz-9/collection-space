/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 22:41:34
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 23:07:02
 */
var cls = require('cls-hooked');

var nsid = 'a6a29a6f-6747-4b5f-b99f-07ee96e32f88';
var ns = cls.createNamespace(nsid);

let id = 0

const generateRId = () => {
  id += 1
  return `${id}`
}

const middleware = (req, res, next) => {
  ns.run(() => {
    const rid = generateRId()
    set('rid', rid);
    next()
  });
}

const get = (key, value) => ns.get(key, value)
const set = (key, value) => ns.set(key, value)

module.exports = {
  middleware,
  get: get,
  set: set,
};
