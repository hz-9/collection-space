/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 18:11:00
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 18:20:12
 */
var log4js = require('log4js');

log4js.configure({
  appenders: {
      default: {
        type: 'console',
        layout: {
          type: 'pattern',
          pattern: '[HZ-9] %-6z - %d{yyyy-MM-dd hh:mm:ss} %7p [%14.14x{name}] %m',
          tokens: {
            // name: (logEvent) => (logEvent.context && logEvent.context.name) || '-',
            name: () => 'COMMON'
          },
        }
      },
  },
  categories: {
      default: { appenders: ['default'], level: 'info' }
  }
});
