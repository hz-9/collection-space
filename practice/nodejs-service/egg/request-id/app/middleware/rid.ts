/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 22:41:34
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 14:47:14
 */

import { Context } from 'egg';

import { ns, set } from '../utils/http-content';

let id = 0;

const generateRId = () => {
  id += 1;
  return `${id}`;
};

export default function ridMiddleware(): any {
  return async (_ctx: Context, next: () => Promise<any>) => {
    ns.run(() => {
      const rid = generateRId();
      set('rid', rid);
      next();
    });
  };
}
