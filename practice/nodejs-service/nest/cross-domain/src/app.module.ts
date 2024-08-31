import { Module } from '@nestjs/common'
import { AppController } from './app.controller'
import { AppService } from './app.service'
import { CrossDomainModule } from './cross-domain/cross-domain.module'

@Module({
  imports: [CrossDomainModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
