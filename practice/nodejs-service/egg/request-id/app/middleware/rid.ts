/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 22:41:34
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 12:34:41
 */
import { Context } from 'egg'

import { generateRId, ns, set } from '../utils/http-content'

export default function ridMiddleware(): any {
  return async (_ctx: Context, next: () => Promise<any>) => {
    ns.run(async () => {
      set('rid', generateRId())
      await next()
    })
  }
}
