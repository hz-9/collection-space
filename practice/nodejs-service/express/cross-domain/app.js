var createError = require('http-errors');
var express = require('express');
var path = require('path');
var logger = require('morgan');
var { crossDomainRouter } = require('./cross-domain/index');
var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

var indexRouter = express.Router();
indexRouter.get('/', function(req, res, next) {
  res.send('This is the express service.');
});
app.use('/favicon.ico', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'favicon.ico'));
});
app.use('/', indexRouter);
app.use('/cross-domain', crossDomainRouter);

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
