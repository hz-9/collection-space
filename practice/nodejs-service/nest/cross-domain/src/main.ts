/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:06:46
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-08 01:06:00
 */
import * as path from 'path'
import { NestFactory } from '@nestjs/core'

import { AppModule } from './app.module'

;(async (): Promise<void> => {
  const app = await NestFactory.create(AppModule)

  app.getHttpAdapter().useStaticAssets(path.resolve(__dirname, '../', 'public'))

  await app.listen(3003)
})()
