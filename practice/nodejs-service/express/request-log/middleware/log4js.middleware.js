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

exports.getMiddleware = () => {
  var logger = log4js.getLogger('default');
  var requestFormat = ':remote-addr - ":method :url HTTP/:http-version" :status :res[content-length] :response-time ms ":user-agent"'
  
  return log4js.connectLogger(logger, { format: requestFormat  })
}
