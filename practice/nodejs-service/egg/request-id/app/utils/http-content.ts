/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 14:42:05
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 14:44:23
 */
import cls from 'cls-hooked'

const nsid = 'a6a29a6f-6747-4b5f-b99f-07ee96e32f88'

export const ns = cls.createNamespace(nsid)

export const get = (key: any) => ns.get(key)
export const set = (key, value) => ns.set(key, value)
