import { EggAppConfig, EggAppInfo, PowerPartial } from 'egg'
import fs from 'node:fs'
import path from 'node:path'

export default (appInfo: EggAppInfo) => {
  const config = {} as PowerPartial<EggAppConfig>

  // override config from framework / plugin
  // use for cookie sign key, should change to your own and keep security
  config.keys = `${appInfo.name}_1720324213796_4631`

  // add your egg config in here
  config.middleware = []

  // add your special config in here
  const bizConfig = {
    sourceUrl: `https://github.com/eggjs/examples/tree/master/${appInfo.name}`,
  }

  config.siteFile = {
    '/favicon.ico': fs.readFileSync(path.join(__dirname, '../public', 'favicon.ico')),
  }

  // the return config will combines to EggAppConfig
  return {
    ...config,
    ...bizConfig,
  }
}
