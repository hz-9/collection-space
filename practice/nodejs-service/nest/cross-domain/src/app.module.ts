/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 19:43:22
 */
import { Module } from '@nestjs/common'

import { AppController } from './app.controller'
import { AppService } from './app.service'
import { CrossDomainModule } from './cross-domain/cross-domain.module'

@Module({
  imports: [CrossDomainModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
