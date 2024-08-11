import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as path from 'path';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app
    .getHttpAdapter()
    .useStaticAssets(path.resolve(__dirname, '../', 'public'));

  await app.listen(3003);
}
bootstrap();
