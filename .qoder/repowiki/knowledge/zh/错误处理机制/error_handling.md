该仓库是一个包含多个 Web 框架（Express, Koa, Egg, NestJS）示例代码和手写工具函数（如 Promise）的集合，**不存在统一的、跨项目的错误处理架构**。错误处理策略高度依赖于各个子项目所使用的具体技术栈，且多为框架默认的简单实现或基础的手写逻辑。

### 1. 各框架/模块的错误处理方式

#### Express 示例
- **模式**：使用标准的 Express 错误处理中间件（4个参数：`err, req, res, next`）。
- **实现**：在 `app.js` 末尾定义全局错误处理器。对于 404 错误，使用 `http-errors` 库创建错误对象并传递给 `next()`。
- **特点**：区分开发环境和生产环境，仅在开发环境下暴露详细错误信息 (`res.locals.error`)。
- **关键文件**：`practice/nodejs-service/express/*/app.js`

#### Egg.js 示例
- **模式**：依赖 Egg 框架内置的错误处理和日志系统。
- **实现**：示例中未展示自定义的全局错误拦截器或统一的错误响应格式。主要通过中间件（如 `request-log.ts`）记录请求状态，间接反映错误（如 500 状态码）。
- **特点**：利用 `ctx.app.getLogger` 进行日志记录，遵循 Egg 的约定优于配置原则。
- **关键文件**：`practice/nodejs-service/egg/request-log/app/middleware/request-log.ts`

#### NestJS 示例
- **模式**：使用 NestJS 默认的全局异常过滤器。
- **实现**：示例代码为最基础的模板，未定义自定义的 `ExceptionFilter` 或统一的错误响应 DTO。
- **特点**：依赖框架默认的 HTTP 异常处理行为。
- **关键文件**：`practice/nodejs-service/nest/template/src/main.ts`

#### 手写代码 (Handwritten Code)
- **模式**：基础的 JavaScript `try...catch` 和 `throw` 语句。
- **实现**：在 `my-promise.ts` 中，通过 `try...catch` 捕获执行器（executor）和回调函数中的同步错误，并将其转换为 Promise 的 reject 状态。在 `my-call.ts` 等工具函数中，通过 `throw new TypeError(...)` 进行参数校验。
- **特点**：展示了底层异步错误传播的基本原理。
- **关键文件**：`handwritten-code/src/my-promise.ts`, `handwritten-code/src/my-call.ts`

### 2. 开发者建议
由于本仓库是示例集合，若要在实际项目中应用，建议：
1. **统一错误格式**：无论使用何种框架，应定义统一的错误响应结构（如 `{ code, message, data }`）。
2. **全局拦截**：在 NestJS 中使用 `@Catch()` 装饰器，在 Express/Koa 中使用全局中间件来统一处理未捕获异常。
3. **日志记录**：结合 `request-log` 示例，确保所有错误都被正确记录到日志系统中，便于排查。