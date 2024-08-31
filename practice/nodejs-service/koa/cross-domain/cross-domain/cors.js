const cors = require('@koa/cors')

exports.bindCorsRouter = (crossDomainRouter) => {
  const corsOptions = {
    // ...
  }

  crossDomainRouter.get('/cors', cors(corsOptions), function (ctx, next) {
    ctx.body = { message: 'This is CORS-enabled for a Single Route.' }
  })

  module.exports = { crossDomainRouter }
}
