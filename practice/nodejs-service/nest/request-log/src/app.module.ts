/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:56:29
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 18:05:59
 */
import { Module, MiddlewareConsumer } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'

import { LoggerMiddleware } from './logger.middleware'

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {
  public configure(consumer: MiddlewareConsumer): void {
    consumer.apply(LoggerMiddleware).forRoutes('*')
  }
}
