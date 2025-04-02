/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 13:29:47
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2025-04-02 13:17:00
 */
import { Context, EggLogger } from 'egg'

let requestLogger: EggLogger | null = null

const logToken = {
  // remoteAddr: (req: Context['request']) => req.headers['x-forwarded-for'] || req.ip || req.socket.remoteAddress,
  remoteAddr: (req: Context['request']) => req.headers['x-forwarded-for'] || req.socket.remoteAddress,
  httpInfo: (req: Context['request']) =>
    `${req.method} ${req.url} ${req.protocol}/${req.req.httpVersionMajor}.${req.req.httpVersionMinor}`,
  status: (res: Context['response']) => res.status,
  contentLength: (res: Context['response']) => res.length,
  referrer: (req: Context['request']) => req.headers.referer || req.headers.referrer || '-',
  userAgent: (req) => req.headers['user-agent'],
}

export default function requestLogMiddleware(): any {
  return async (ctx: Context, next: () => Promise<any>) => {
    if (!requestLogger) {
      requestLogger = ctx.app.getLogger('request')
    }

    const start = Date.now()

    await next()

    const ms = Date.now() - start

    const logMsg = [
      logToken.remoteAddr(ctx.request),
      '-',
      `"${logToken.httpInfo(ctx.request)}"`,
      logToken.status(ctx.response),
      logToken.contentLength(ctx.response),
      `${ms}ms`,
      `"${logToken.referrer(ctx.request)}"`,
      `"${logToken.userAgent(ctx.request)}"`,
    ].join(' ')

    requestLogger.info(logMsg)
  }
}
