import { EggLogger } from 'egg';
import { Inject, HTTPController, HTTPMethod, HTTPMethodEnum } from '@eggjs/tegg';

@HTTPController({
  path: '/cross-domain',
})
export class SampleCrossDomainController {
  @Inject()
  logger: EggLogger;

  @HTTPMethod({
    method: HTTPMethodEnum.GET,
    path: '/sample',
  })
  async sample() {
    return { message: 'This is sample for a Single Route.' };
  }
}
