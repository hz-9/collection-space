/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-13 01:06:40
 */
const fs = require('fs')
const path = require('path')
const Koa = require('koa')
const Router = require('@koa/router')

const { middleware } = require('./middleware/log4js.middleware')

const app = new Koa()

// logger
app.use(middleware)

// response
const router = new Router()
router
  .get('/favicon.ico', async (ctx, next) => {
    ctx.type = 'image/x-icon'
    ctx.body = fs.readFileSync(path.join(__dirname, 'public', 'favicon.ico'))
  })
  .get('/', async (ctx, next) => {
    ctx.body = 'This is the koa service.'
  })

app.use(router.routes()).use(router.allowedMethods())

app.listen(3001)
