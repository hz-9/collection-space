/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 11:16:45
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 12:52:28
 */

const morgan = require('morgan')

morgan.token('pid', () => process.pid.toString().padEnd(6))

morgan.token('timestamp', () => {
  const timestamp = new Date(Date.now()).toLocaleString(undefined, {
    year: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric',
    day: '2-digit',
    month: '2-digit',
  })
  return timestamp.replace(/\//g, '-')
})

morgan.token('level', () => 'INFO'.padStart(7))

morgan.token('marker', () => 'COMMON'.padStart(14))

exports.requestLogMiddleware = () => {
  const newLogFormat =
    '[HZ-9] :pid - :timestamp :level [:marker] :remote-addr - ":method :url HTTP/:http-version" :status :res[content-length] :response-time[0]ms ":referrer" ":user-agent"'

  return morgan(newLogFormat)
}
