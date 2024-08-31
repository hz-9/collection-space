import { EggLogger, Context as ContentType } from 'egg'
import { Inject, HTTPController, HTTPMethod, HTTPMethodEnum, Context } from '@eggjs/tegg'

@HTTPController({
  path: '/cross-domain',
})
export class JsonpCrossDomainController {
  @Inject()
  logger: EggLogger

  @HTTPMethod({
    method: HTTPMethodEnum.GET,
    path: '/jsonp',
  })
  async jsonp(@Context() ctx: ContentType) {
    const responseData = { message: 'This is Jsonp for a Single Route.' }
    if (ctx.query.callback) {
      const text = `/**/ typeof ${ctx.query.callback} === 'function' && ${
        ctx.query.callback
      }(${JSON.stringify(responseData)});`
      ctx.set('X-Content-Type-Options', 'nosniff')
      ctx.set('Content-Type', 'text/javascript')
      ctx.body = text
    } else {
      ctx.body = responseData
    }

    // return responseData;
  }
}
