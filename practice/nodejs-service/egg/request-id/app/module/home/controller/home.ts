import { EggLogger } from 'egg'
import { Inject, HTTPController, HTTPMethod, HTTPMethodEnum } from '@eggjs/tegg'

import { get } from '../../../utils/http-content'

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
    console.log('rid: ', get('rid'))
    return 'This is the egg service.'
  }
}
