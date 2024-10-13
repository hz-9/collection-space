/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 22:52:35
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 12:43:45
 */
import { Controller, Get } from '@nestjs/common'
import { AppService } from './app.service'

import { get } from './middleware/rid.middleware'

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    console.log('rid: ', get('rid'))
    return this.appService.getHello()
  }
}
