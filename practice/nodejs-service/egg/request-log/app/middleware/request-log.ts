/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 13:29:47
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 14:40:50
 */
import { Context, EggLogger } from 'egg';

// eslint-disable-next-line no-undef-init
let requestLogger: EggLogger | undefined = undefined;

export default function requestLogMiddleware(): any {
  return async (ctx: Context, next: () => Promise<any>) => {
    const st = Date.now();

    await next();

    const { ip, method, url, protocol, req, headers } = ctx.request;
    const { status, length } = ctx.response;
    const logMsg: string = `${ip} - "${method} ${url} ${protocol}/${req.httpVersion}" ${status} ${length} ${Date.now() - st} ms "${headers['user-agent']}"`;
    if (!requestLogger) {
      requestLogger = ctx.app.getLogger('request');
    }

    requestLogger.info(logMsg);
  };
}
