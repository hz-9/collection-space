import { HTTPController, HTTPMethod, HTTPMethodEnum, Inject } from '@eggjs/tegg'
import { EggLogger } from 'egg'

@HTTPController({
  path: '/cross-domain',
})
export class SampleCrossDomainController {
  @Inject()
  logger: EggLogger

  @HTTPMethod({
    method: HTTPMethodEnum.GET,
    path: '/sample',
  })
  async sample() {
    return { message: 'This is sample for a Single Route.' }
  }
}
