/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-11 00:35:59
 */
import * as path from 'path'
import { NestFactory } from '@nestjs/core'

import { AppModule } from './app.module'
import { ConsoleLogger } from './middleware/console.logger'

;(async (): Promise<void> => {
  const app = await NestFactory.create(AppModule)
  app.useLogger(new ConsoleLogger('HZ-9'))

  app.getHttpAdapter().useStaticAssets(path.resolve(__dirname, '../', 'public'))

  await app.listen(3003)
})()
