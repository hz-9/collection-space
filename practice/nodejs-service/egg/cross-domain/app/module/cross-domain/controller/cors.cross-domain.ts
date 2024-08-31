import { EggLogger, Context as ContentType } from 'egg'
import { Inject, HTTPController, HTTPMethod, HTTPMethodEnum, Context } from '@eggjs/tegg'

@HTTPController({
  path: '/cross-domain',
})
export class CorsCrossDomainController {
  @Inject()
  logger: EggLogger

  @HTTPMethod({
    method: HTTPMethodEnum.GET,
    path: '/cors',
  })
  async cors(@Context() ctx: ContentType) {
    console.log('ctx', ctx)
    return { message: 'This is CORS-enabled for a Single Route.' }
  }
}
