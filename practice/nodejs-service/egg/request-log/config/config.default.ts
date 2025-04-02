import { EggAppConfig, EggAppInfo, LoggerLevel, PowerPartial } from 'egg'
import fs from 'node:fs'
import path from 'node:path'

type LoggerMeta = {
  level: LoggerLevel
  date: string
  pid: number
  hostname: string
  message: string
  paddingMessage?: string
  ctx?: any
  raw: boolean
  formatter?: () => string
  [key: string]: any
}

export default (appInfo: EggAppInfo) => {
  const config = {} as PowerPartial<EggAppConfig>

  // override config from framework / plugin
  // use for cookie sign key, should change to your own and keep security
  config.keys = `${appInfo.name}_1720324213796_4631`

  // add your egg config in here
  config.middleware = ['requestLog']

  // add your special config in here
  const bizConfig = {
    sourceUrl: `https://github.com/eggjs/examples/tree/master/${appInfo.name}`,
  }

  config.siteFile = {
    '/favicon.ico': fs.readFileSync(path.join(__dirname, '../public', 'favicon.ico')),
  }

  config.logger = {
    dir: './logs',
  }

  config.customLogger = {
    request: {
      file: 'request.log',
      formatter: (meta?: any): string => {
        if (!meta) return ''
        const loggerMeta: LoggerMeta = meta as LoggerMeta
        const marker = 'Request'

        return [
          '[HZ-9]',
          loggerMeta.pid.toString().padEnd(6, ' '),
          '-',
          loggerMeta.date.substring(0, 19),
          loggerMeta.level.padStart(7, ' '),
          `[${marker.padStart(14, ' ')}]`,
          loggerMeta.message,
        ].join(' ')
      },
      contextFormatter: (meta?: any): string => {
        if (!meta) return ''
        const loggerMeta: LoggerMeta = meta as LoggerMeta
        const marker = 'Request'

        return [
          '[HZ-9]',
          loggerMeta.pid.toString().padEnd(6, ' '),
          '-',
          loggerMeta.date.substring(0, 19),
          loggerMeta.level.padStart(7, ' '),
          `[${marker.padStart(14, ' ')}]`,
          loggerMeta.message,
        ].join(' ')
      },
    },
  }

  // the return config will combines to EggAppConfig
  return {
    ...config,
    ...bizConfig,
  }
}
