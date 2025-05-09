import { HTTPController, HTTPMethod, HTTPMethodEnum, Inject } from '@eggjs/tegg'
import { EggLogger } from 'egg'

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
    return 'This is the egg service.'
  }
}
