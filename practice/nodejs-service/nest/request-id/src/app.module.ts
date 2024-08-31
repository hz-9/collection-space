/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 22:52:35
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 23:00:01
 */
import { MiddlewareConsumer, Module } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'

import { RidMiddleware } from './middleware/rid.middleware'

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {
  public configure(consumer: MiddlewareConsumer): void {
    consumer.apply(RidMiddleware).forRoutes('*')
  }
}
