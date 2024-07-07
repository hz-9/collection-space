import { Injectable, Logger, NestMiddleware } from '@nestjs/common';
import type { NextFunction, Request, Response } from 'express';

/**
 *
 * @public
 *
 *  服务端应用程序，请求日志中间件。
 *
 */
@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  private _logger: Logger = new Logger('Request');

  public use(request: Request, response: Response, next: NextFunction): void {
    const sT = Date.now();

    const { method, originalUrl, httpVersion } = request;
    const userAgent = request.get('user-agent');

    const host = request.get('host');

    response.on('finish', () => {
      const { statusCode } = response;
      const contentLength = response.get('content-length');

      const t: number = Date.now() - sT;

      this._logger.log(
        `${host} - "${method} ${originalUrl} HTTP/${httpVersion}" ${statusCode} ${contentLength} ${t} ms "${userAgent}"`,
      );
    });

    next();
  }
}
