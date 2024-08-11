/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 23:31:08
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-12 00:36:48
 */
const fs = require("fs");
const path = require("path");
const Koa = require("koa");
const app = new Koa();

// logger
app.use(async (ctx, next) => {
  const start = Date.now();

  await next();

  const ms = Date.now() - start;
  console.log(`${ctx.method} ${ctx.url} - ${ms} ms`);
});

// response
app.use(async (ctx, next) => {
  if ('/favicon.ico' != ctx.path) {
    return next();
  }

  if ('GET' !== ctx.method && 'HEAD' !== ctx.method) {
    ctx.status = 'OPTIONS' == ctx.method ? 200 : 405;
    ctx.set('Allow', 'GET, HEAD, OPTIONS');
  } else {
    ctx.type = 'image/x-icon'
    ctx.body = fs.readFileSync(path.join(__dirname, "public", "favicon.ico"));
  }
});
app.use(async (ctx) => {
  ctx.body = "This is the koa service.";
});

app.listen(3001);
