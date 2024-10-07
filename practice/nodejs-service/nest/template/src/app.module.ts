/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-08 01:05:57
 */
import { Module } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
