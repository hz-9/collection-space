import { Controller, Get } from '@nestjs/common';

@Controller('/cross-domain')
export class SampleCrossDomainController {
  @Get('/sample')
  getHello(): { message: string } {
    return { message: 'This is sample for a Single Route.' };
  }
}
