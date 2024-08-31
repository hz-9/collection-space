/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:56:29
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-12 01:14:33
 */
import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import * as path from 'path'

// import { MyConsoleLogger } from './console.logger';
import { A4Log4jsLogger } from './log4js.logger'

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true })
  // app.useLogger(new MyConsoleLogger('HZ-9'));
  app.useLogger(new A4Log4jsLogger())

  app.getHttpAdapter().useStaticAssets(path.resolve(__dirname, '../', 'public'))

  await app.listen(3003)
}
bootstrap()
