import { HTTPController, HTTPMethod, HTTPMethodEnum, Inject } from '@eggjs/tegg'
import { EggLogger } from 'egg'

// eslint-disable-next-line import/extensions
import { get } from '@/utils/http-content'

@HTTPController({
  path: '/',
})
export class HomeController {
  @Inject()
  logger: EggLogger

  @HTTPMethod({
    method: HTTPMethodEnum.GET,
    path: '/',
  })
  async index() {
    // eslint-disable-next-line no-console
    console.log('rid: ', get('rid'))
    return 'This is the egg service.'
  }
}
