import { Controller, Get, Query, Res } from '@nestjs/common';
import type { Response } from 'express';

@Controller('/cross-domain')
export class JsonpCrossDomainController {
  @Get('/jsonp')
  jsonp(
    @Query('callback') callback: string | undefined,
    @Res() res: Response,
  ): void {
    const responseData = { message: 'This is Jsonp for a Single Route.' };

    if (callback) {
      const text = `/**/ typeof ${callback} === 'function' && ${
        callback
      }(${JSON.stringify(responseData)});`;
      res.set('Content-Type', 'text/javascript');
      res.set('X-Content-Type-Options', 'nosniff');
      res.send(text);
    } else {
      res.send(responseData);
    }
  }

  @Get('/jsonp2')
  jsonp2(@Res() res: Response): void {
    const responseData = { message: 'This is Jsonp for a Single Route.' };
    res.jsonp(responseData);
  }
}
