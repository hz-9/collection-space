/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 00:09:35
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 12:53:07
 */

/* eslint-disable no-console */

const logToken = {
  timestamp: () => {
    const timestamp = new Date(Date.now()).toLocaleString(undefined, {
      year: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric',
      day: '2-digit',
      month: '2-digit',
    })
    return timestamp.replace(/\//g, '-')
  },
  pid: () => () => process.pid.toString().padEnd(6),
  level: () => 'INFO'.padStart(7),
  marker: () => 'COMMON'.padStart(14),
  referrer: (ctx) => ctx.headers.referer || ctx.headers.referrer || '-',
}

exports.requestLogMiddleware = () => async (ctx, next) => {
  const start = Date.now()
  let error = null

  try {
    await next()
  } catch (err) {
    error = err
  }

  const ms = Date.now() - start
  const logMsg = [
    '[HZ-9]',
    logToken.pid(),
    '-',
    logToken.timestamp(),
    logToken.level(),
    `[${logToken.marker()}]`,
    ctx.ip,
    '-',
    `"${ctx.method} ${ctx.url} HTTP/${ctx.req.httpVersion}"`,
    ctx.response.status,
    ctx.response.length,
    `${ms}ms`,
    `"${logToken.referrer(ctx)}"`,
    `"${ctx.headers['user-agent']}"`,
  ].join(' ')
  if (error) {
    console.error(logMsg, error)
  } else {
    console.log(logMsg)
  }
}
