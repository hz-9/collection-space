var log4js = require('log4js')

log4js.configure({
  appenders: {
    default: {
      type: 'console',
      layout: {
        type: 'pattern',
        pattern: '[HZ-9] %-6z - %d{yyyy-MM-dd hh:mm:ss} %7p [%14.14x{name}] %m',
        tokens: {
          // name: (logEvent) => (logEvent.context && logEvent.context.name) || '-',
          name: () => 'COMMON',
        },
      },
    },
  },
  categories: {
    default: { appenders: ['default'], level: 'info' },
  },
})

var logger = log4js.getLogger('default')

exports.middleware = async (ctx, next) => {
  const start = Date.now()
  try {
    await next()

    const ms = Date.now() - start
    logger.info(
      `${ctx.ip} - "${ctx.method} ${ctx.url} HTTP/${ctx.req.httpVersion}" ${ctx.response.status} ${ctx.response.length} ${ms} ms "${ctx.headers['user-agent']}"`
    )
  } catch (error) {
    const ms = Date.now() - start

    logger.error(
      `${ctx.ip} - "${ctx.method} ${ctx.url} HTTP/${ctx.req.httpVersion}" ${ctx.response.status} ${ctx.response.length} ${ms} ms "${ctx.headers['user-agent']}"`,
      error
    )
  }
}
