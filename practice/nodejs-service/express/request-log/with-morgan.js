var logger = require('morgan');

logger.token('pid', function(req, res) {
  return process.pid;
});

function pad2 (num) {
  var str = String(num)
  return (str.length === 1 ? '0' : '') + str
}

logger.token('timestamp', function(req, res) {
  var dateTime = new Date()
  var year = dateTime.getUTCFullYear()
  var month = dateTime.getUTCMonth()
  var date = dateTime.getUTCDate()

  var hour = dateTime.getUTCHours()
  var mins = dateTime.getUTCMinutes()
  var secs = dateTime.getUTCSeconds()
  return `${year}-${pad2(month)}-${pad2(date)} ${pad2(hour)}:${pad2(mins)}:${pad2(secs)}`
});

logger.token('level', function(req, res) {
  return `INFO`
});

logger.token('marker', function(req, res) {
  return `COMMON`
});