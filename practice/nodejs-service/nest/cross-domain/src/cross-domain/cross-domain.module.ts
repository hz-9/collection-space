import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common'
import { SampleCrossDomainController } from './sample.cross-domain.controller'
import { JsonpCrossDomainController } from './jsonp.cross-domain.controller'
import { CorsCrossDomainController } from './cors.cross-domain.controller'
import * as cors from 'cors'
import type { CorsOptions } from 'cors'

@Module({
  imports: [],
  controllers: [CorsCrossDomainController, JsonpCrossDomainController, SampleCrossDomainController],
  providers: [],
})
export class CrossDomainModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    const corsOptions: CorsOptions = {
      /**
       * Docs: https://www.npmjs.com/package/cors#configuration-options
       */
    }

    consumer.apply(cors(corsOptions)).forRoutes(CorsCrossDomainController)
  }
}
