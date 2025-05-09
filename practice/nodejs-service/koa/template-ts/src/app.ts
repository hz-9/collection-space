/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 23:34:24
 */
import Router from '@koa/router'
import Koa from 'koa'
import fs from 'node:fs'
import path from 'node:path'

const app = new Koa()

// logger
app.use(async (ctx, next) => {
  const start = Date.now()

  await next()

  const ms = Date.now() - start
  console.log(`${ctx.method} ${ctx.url} - ${ms} ms`)
})

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

server.on('error', (error: any) => {
  if (error?.syscall !== 'listen') {
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
  const bind = typeof addr === 'string' ? `Pipe ${addr}` : `Port ${addr?.port}`
  console.log(`Listening on ${bind}`)
})
