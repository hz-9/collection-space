/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 00:09:35
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 11:27:15
 */
const logToken = {
  timestamp: () => {
    function pad2 (num) {
      var str = String(num)
      return (str.length === 1 ? '0' : '') + str
    }

    var dateTime = new Date()
    var year = dateTime.getUTCFullYear()
    var month = dateTime.getUTCMonth() + 1
    var date = dateTime.getUTCDate()

    var hour = dateTime.getUTCHours()
    var mins = dateTime.getUTCMinutes()
    var secs = dateTime.getUTCSeconds()
    return `${year}-${month}-${pad2(date)} ${pad2(hour)}:${pad2(mins)}:${pad2(secs)}`
  },
  level: () => 'INFO',
  marker: () => 'MARKER',
}

exports.middleware = async (ctx, next) => {
  const start = Date.now();

  try {
    await next();

    const ms = Date.now() - start;

    console.log(`[HZ-9] ${process.pid} - ${logToken.timestamp()} ${logToken.level()} [${logToken.marker()}] ${ctx.ip} - "${ctx.method} ${ctx.url} HTTP/${ctx.req.httpVersion}" ${ctx.response.status} ${ctx.response.length} ${ms} ms "${ctx.headers['user-agent']}"`)
  } catch (error) {
    const ms = Date.now() - start;

    console.error(`[HZ-9] ${process.pid} - ${logToken.timestamp()} ${logToken.level()} [${logToken.marker()}] ${ctx.ip} - "${ctx.method} ${ctx.url} HTTP/${ctx.req.httpVersion}" ${ctx.response.status} ${ctx.response.length} ${ms} ms "${ctx.headers['user-agent']}"`, error)
  }
}
