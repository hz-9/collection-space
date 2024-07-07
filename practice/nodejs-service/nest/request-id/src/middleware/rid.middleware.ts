/**
 * @Author       : Chen Zhen
 * @Date         : 2024-05-10 00:00:00
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 23:01:18
 */
import { Injectable, NestMiddleware } from '@nestjs/common';
import type { NextFunction, Request, Response } from 'express';

import * as cls from 'cls-hooked';

const nsid = 'a6a29a6f-6747-4b5f-b99f-07ee96e32f88';

const ns = cls.createNamespace(nsid);

export const get = (key: any) => ns.get(key);
export const set = (key, value) => ns.set(key, value);

let id = 0;

const generateRId = (): string => {
  id += 1;
  return `${id}`;
};

/**
 * @public
 */
@Injectable()
export class RidMiddleware implements NestMiddleware {
  public use(request: Request, response: Response, next: NextFunction): void {
    ns.run(() => {
      const rid = generateRId();
      set('rid', rid);
      next();
    });
  }
}
