/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 23:46:43
 */
const Koa = require('koa');
const app = new Koa();

// logger
app.use(async (ctx, next) => {
  const start = Date.now();

  await next();
  
  const ms = Date.now() - start;
  console.log(`${ctx.method} ${ctx.url} - ${ms} ms`);
});


// response

app.use(async ctx => {
  ctx.body = 'This is the koa service.';
});

app.listen(3000);
