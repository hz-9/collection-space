exports.bindJsonpRouter = (crossDomainRouter) => {
  // const corsOptions = {
  //   /**
  //    * Docs: https://github.com/koajs/cors/?tab=readme-ov-file#corsoptions
  //    */
  // }

  crossDomainRouter.get('/jsonp', (ctx) => {
    const responseData = { message: 'This is Jsonp for a Single Route.' }
    // eslint-disable-next-line no-console
    console.log('req.query.callback', ctx.query.callback)
    if (ctx.query.callback) {
      const text = `/**/ typeof ${ctx.query.callback} === 'function' && ${
        ctx.query.callback
      }(${JSON.stringify(responseData)});`
      ctx.set('X-Content-Type-Options', 'nosniff')
      ctx.set('Content-Type', 'text/javascript')
      ctx.body = text
    } else {
      ctx.body = responseData
    }
  })

  module.exports = { crossDomainRouter }
}
