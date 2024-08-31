/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-07 11:16:45
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-07 11:19:40
 */

var morgan = require('morgan')

morgan.token('pid', function (req, res) {
  return process.pid
})

function pad2(num) {
  var str = String(num)
  return (str.length === 1 ? '0' : '') + str
}

morgan.token('timestamp', function (req, res) {
  var dateTime = new Date()
  var year = dateTime.getUTCFullYear()
  var month = dateTime.getUTCMonth() + 1
  var date = dateTime.getUTCDate()

  var hour = dateTime.getUTCHours()
  var mins = dateTime.getUTCMinutes()
  var secs = dateTime.getUTCSeconds()
  return `${year}-${pad2(month)}-${pad2(date)} ${pad2(hour)}:${pad2(mins)}:${pad2(secs)}`
})

morgan.token('level', function (req, res) {
  return `INFO`
})

morgan.token('marker', function (req, res) {
  return `COMMON`
})

exports.getMiddleware = () => {
  var newLogFormat =
    '[HZ-9] :pid - :timestamp :level [:marker] :req[host] - ":method :url HTTP/:http-version" :status :res[content-length] :response-time ms ":user-agent"'

  return morgan(newLogFormat)
}
