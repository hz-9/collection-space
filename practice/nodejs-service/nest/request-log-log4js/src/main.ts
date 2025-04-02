/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-11 01:21:22
 */
import * as path from 'path'
import { NestFactory } from '@nestjs/core'

import { AppModule } from './app.module'
import { Log4jsLogger } from './middleware/log4js.logger'

;(async (): Promise<void> => {
  const app = await NestFactory.create(AppModule)
  app.useLogger(new Log4jsLogger('HZ-9'))

  app.getHttpAdapter().useStaticAssets(path.resolve(__dirname, '../', 'public'))

  await app.listen(3003)
})()
