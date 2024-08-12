exports.bindJsonpRouter = (crossDomainRouter) => {
  const corsOptions = {
    // ...
  }

  crossDomainRouter.get('/jsonp', function (req, res, next) {
    const responseData = { message: 'This is Jsonp for a Single Route.' }
    if (req.query.callback) {
      const text = `/**/ typeof ${req.query.callback} === 'function' && ${req.query.callback}(${JSON.stringify(responseData)});`
      res.set('X-Content-Type-Options', 'nosniff');
      res.set('Content-Type', 'text/javascript');
      res.send(text);
    } else {
      res.json(responseData);
    }
  });

  crossDomainRouter.get('/jsonp2', function (req, res, next) {
    res.jsonp({ message: 'This is Jsonp for a Single Route.' });
  });

  module.exports = { crossDomainRouter }
}
