/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 11:33:00
 */
const Koa = require('koa');
// const { middleware } = require('./middleware/console.middleware')
const { middleware } = require('./middleware/log4js.middleware')


const app = new Koa();

// logger
app.use(middleware);

// response
app.use(async ctx => {
  ctx.body = 'This is the koa service.';
});

app.listen(3000);
