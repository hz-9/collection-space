/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 11:16:45
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-08 02:14:53
 */

const morgan = require('morgan')

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

morgan.token('pid', () => padRight(process.pid, 6))

morgan.token('timestamp', () => {
  const dateTime = new Date()
  const year = dateTime.getUTCFullYear()
  const month = dateTime.getUTCMonth() + 1
  const date = dateTime.getUTCDate()

  const hour = dateTime.getUTCHours()
  const mins = dateTime.getUTCMinutes()
  const secs = dateTime.getUTCSeconds()
  return `${year}-${pad2(month)}-${pad2(date)} ${pad2(hour)}:${pad2(mins)}:${pad2(secs)}`
})

morgan.token('level', () => padLeft('INFO', 7))

morgan.token('marker', () => padLeft('COMMON', 14))

exports.requestLogMiddleware = () => {
  const newLogFormat =
    '[HZ-9] :pid - :timestamp :level [:marker] :remote-addr - ":method :url HTTP/:http-version" :status :res[content-length] :response-time[0]ms ":referrer" ":user-agent"'

  return morgan(newLogFormat)
}
