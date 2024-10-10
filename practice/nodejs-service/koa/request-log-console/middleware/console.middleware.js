/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 00:09:35
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-10 18:38:15
 */

/* eslint-disable no-console */

function padLeft(text, length, char = ' ') {
  let str = String(text)
  while (str.length < length) {
    str = char + str
  }
  return str
}
function padRight(text, length, char = ' ') {
  const str = String(text)
  if (str.length >= length) return str
  return str + char.repeat(length - str.length)
}
function pad2(num) {
  const str = String(num)
  if (str.length >= 2) return str
  return `0${str}`
}

const logToken = {
  timestamp: () => {
    const dateTime = new Date()
    const year = dateTime.getUTCFullYear()
    const month = dateTime.getUTCMonth() + 1
    const date = dateTime.getUTCDate()

    const hour = dateTime.getUTCHours()
    const mins = dateTime.getUTCMinutes()
    const secs = dateTime.getUTCSeconds()
    return `${year}-${pad2(month)}-${pad2(date)} ${pad2(hour)}:${pad2(mins)}:${pad2(secs)}`
  },
  pid: () => padRight(process.pid, 6),
  level: () => padLeft('INFO', 7),
  marker: () => padLeft('COMMON', 14),
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
