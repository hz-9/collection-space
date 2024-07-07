/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:56:29
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 18:17:09
 */
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

import { MyConsoleLogger } from './console.logger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  app.useLogger(new MyConsoleLogger('HZ-9'));

  await app.listen(3000);
}
bootstrap();
