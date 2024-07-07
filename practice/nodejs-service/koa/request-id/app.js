/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 11:11:08
 */
const Koa = require('koa');
const { middleware, get } = require('./middleware/rid.middleware');
const app = new Koa();

// logger
app.use(middleware);

// response
app.use(async ctx => {
  console.log(get('rid'));
  ctx.body = 'This is the koa service.';
});

app.listen(3000);
