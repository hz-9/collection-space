const express = require('express')
const { bindCorsRouter } = require('./cors')
const { bindJsonpRouter } = require('./jsonp')

const crossDomainRouter = express.Router()

crossDomainRouter.get('/sample', (req, res) => {
  res.json({ message: 'This is sample for a Single Route.' })
})

/**
 * 1. CORS
 */
bindCorsRouter(crossDomainRouter)

/**
 * 2. jsonp
 */
bindJsonpRouter(crossDomainRouter)

module.exports = { crossDomainRouter }
