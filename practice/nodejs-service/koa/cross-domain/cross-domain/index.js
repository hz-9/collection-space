const Router = require("@koa/router");
const { bindCorsRouter } = require("./cors");
const { bindJsonpRouter } = require("./jsonp");

const crossDomainRouter = new Router();

crossDomainRouter.get("/sample", function (ctx, next) {
  ctx.body = { message: "This is sample for a Single Route." };
});

/**
 * 1. CORS
 */
bindCorsRouter(crossDomainRouter);

/**
 * 2. jsonp
 */
bindJsonpRouter(crossDomainRouter);

module.exports = { crossDomainRouter };
