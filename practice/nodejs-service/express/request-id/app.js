const createError = require('http-errors')
const express = require('express')
const path = require('path')
const logger = require('morgan')

const { ridMiddleware, get } = require('./middleware/rid.middleware')

const app = express()

app.use(ridMiddleware)

app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

const indexRouter = express.Router()
indexRouter.get('/', (req, res) => {
  // eslint-disable-next-line no-console
  console.log('rid:', get('rid'))
  res.send('This is the express service.')
})

app.use('/favicon.ico', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'favicon.ico'))
})
app.use('/', indexRouter)

// catch 404 and forward to error handler
app.use((req, res, next) => {
  next(createError(404))
})

// error handler
app.use((err, req, res) => {
  // set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error = req.app.get('env') === 'development' ? err : {}

  // render the error page
  res.status(err.status || 500)
  res.render('error')
})

module.exports = app
