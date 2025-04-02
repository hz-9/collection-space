const cors = require('cors')

exports.bindCorsRouter = (crossDomainRouter) => {
  const corsOptions = {
    /**
     * Docs: https://www.npmjs.com/package/cors#configuration-options
     */
  }

  crossDomainRouter.get('/cors', cors(corsOptions), (req, res) => {
    res.json({ message: 'This is CORS-enabled for a Single Route.' })
  })

  module.exports = { crossDomainRouter }
}
