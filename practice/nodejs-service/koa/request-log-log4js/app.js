/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-10 18:37:30
 */
const fs = require('fs')
const path = require('path')
const Koa = require('koa')
const Router = require('@koa/router')
const app = new Koa()

const { requestLogMiddleware } = require('./middleware/log4js.middleware')

app.use(requestLogMiddleware())

// response
const router = new Router()
router
  .get('/favicon.ico', async (ctx) => {
    ctx.type = 'image/x-icon'
    ctx.body = fs.readFileSync(path.join(__dirname, 'public', 'favicon.ico'))
  })
  .get('/', async (ctx) => {
    ctx.body = 'This is the koa service.'
  })

app.use(router.routes()).use(router.allowedMethods())

const port = Number(process.env.PORT || '3001')
const server = app.listen(port)

server.on('error', (error) => {
  if (error.syscall !== 'listen') {
    throw error
  }

  const bind = typeof port === 'string' ? `Pipe ${port}` : `Port ${port}`

  switch (error.code) {
    case 'EACCES':
      console.error(`${bind} requires elevated privileges`)
      process.exit(1)
      break
    case 'EADDRINUSE':
      console.error(`${bind} is already in use`)
      process.exit(1)
      break
    default:
      throw error
  }
})

server.on('listening', () => {
  const addr = server.address()
  const bind = typeof addr === 'string' ? `Pipe ${addr}` : `Port ${addr.port}`
  console.log(`Listening on ${bind}`)
})
