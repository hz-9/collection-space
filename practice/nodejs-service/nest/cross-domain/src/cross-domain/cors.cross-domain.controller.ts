import { Controller, Get } from '@nestjs/common';

@Controller('/cross-domain')
export class CorsCrossDomainController {
  @Get('/cors')
  cors(): { message: string } {
    return { message: 'This is CORS-enabled for a Single Route.' };
  }
}
