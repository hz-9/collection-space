/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-11 00:36:47
 */
import { Module, MiddlewareConsumer } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'

import { LoggerMiddleware } from './middleware/logger.middleware'

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
