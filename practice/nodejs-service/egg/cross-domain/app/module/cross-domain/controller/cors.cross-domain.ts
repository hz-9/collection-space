import { Context, HTTPController, HTTPMethod, HTTPMethodEnum, Inject } from '@eggjs/tegg'
import { Context as ContentType, EggLogger } from 'egg'

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
    // eslint-disable-next-line no-console
    console.log('ctx', ctx)
    return { message: 'This is CORS-enabled for a Single Route.' }
  }
}
