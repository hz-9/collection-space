/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 17:56:29
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 22:46:22
 */
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

// import { MyConsoleLogger } from './console.logger';
import { A4Log4jsLogger } from './log4js.logger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  // app.useLogger(new MyConsoleLogger('HZ-9'));
  app.useLogger(new A4Log4jsLogger());

  await app.listen(3000);
}
bootstrap();
