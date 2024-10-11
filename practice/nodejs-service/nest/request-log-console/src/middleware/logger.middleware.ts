import { Injectable, Logger, NestMiddleware } from '@nestjs/common'
import type { NextFunction, Request, Response } from 'express'

const logToken = {
  remoteAddr: (req: Request) => req.headers['x-forwarded-for'] || req.ip || req.socket.remoteAddress,
  httpInfo: (req: Request) =>
    `${req.method} ${req.url} ${req.protocol}/${req.httpVersionMajor}.${req.httpVersionMinor}`,
  status: (res: Response) => res.statusCode,
  contentLength: (res: Response) => res.get('content-length'),
  // responseTime: (res: Response) => res.respon,
  referrer: (req: Request) => req.headers.referer || req.headers.referrer || '-',
  userAgent: (req) => req.headers['user-agent'],
}

/**
 *
 * @public
 *
 */
@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  private _logger: Logger = new Logger('Request')

  public use(request: Request, response: Response, next: NextFunction): void {
    const start = Date.now()

    response.on('finish', () => {
      const responseTime = Date.now() - start
      this._logger.log([
        logToken.remoteAddr(request),
        '-',
        `"${logToken.httpInfo(request)}"`,
        logToken.status(response),
        logToken.contentLength(response),
        `${responseTime}ms`,
        `"${logToken.referrer(request)}"`,
        `"${logToken.userAgent(request)}"`,
      ].join(' '))
    })

    next()
  }
}
