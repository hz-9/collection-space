import fs from 'node:fs'
import path from 'node:path'
import { EggAppConfig, EggAppInfo, PowerPartial, LoggerLevel } from 'egg'

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
  config.keys = appInfo.name + '_1720324213796_4631'

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
        const meta_: LoggerMeta = meta as LoggerMeta
        const marker = 'Request'

        return [
          '[HZ-9]',
          meta_.pid.toString().padEnd(6, ' '),
          '-',
          meta_.date.substring(0, 19),
          meta_.level.padStart(7, ' '),
          `[${marker.padStart(14, ' ')}]`,
          meta_.message,
        ].join(' ')
      },
      contextFormatter: (meta?: any): string => {
        if (!meta) return ''
        const meta_: LoggerMeta = meta as LoggerMeta
        const marker = 'Request'

        return [
          '[HZ-9]',
          meta_.pid.toString().padEnd(6, ' '),
          '-',
          meta_.date.substring(0, 19),
          meta_.level.padStart(7, ' '),
          `[${marker.padStart(14, ' ')}]`,
          meta_.message,
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
