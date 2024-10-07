/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-08 00:26:16
 */
const fs = require('fs')
const path = require('path')
const Koa = require('koa')
const Router = require('@koa/router')
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

app.listen(3001)
