var createError = require('http-errors');
var express = require('express');
var path = require('path');
var logger = require('morgan');
// require('./with-morgan')

var log4js = require('log4js');
require('./with-log4js')

var indexRouter = require('./routes/index');

var app = express();

// var newLogFormat = '[HZ-9] :pid - :timestamp :level [:marker] :req[host] - ":method :url HTTP/:http-version" :status :res[content-length] :response-time ms ":user-agent"'
// app.use(logger(newLogFormat));

var logger = log4js.getLogger('default');
var requestFormat = ':remote-addr - ":method :url HTTP/:http-version" :status :res[content-length] :response-time ms ":user-agent"'
app.use(log4js.connectLogger(logger, { format: requestFormat  }));

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/', indexRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
