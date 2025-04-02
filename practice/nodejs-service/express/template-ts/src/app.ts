/**
 * @Author       : Chen Zhen
 * @Date         : 2024-10-13 22:43:55
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 23:22:53
 */
import express, { type Request, type Response } from 'express'
import createError from 'http-errors'
import logger from 'morgan'
import path from 'node:path'

const app = express()

app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

const indexRouter = express.Router()
indexRouter.get('/', (req, res) => {
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

app.use((err: any, req: Request, res: Response) => {
  // set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error = req.app.get('env') === 'development' ? err : {}

  // render the error page
  res.status(err.status || 500)
  res.render('error')
})

export default app
