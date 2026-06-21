该仓库是一个 Web 项目脚本与示例集合，其日志系统（logging_system）主要体现在 `practice/nodejs-service` 目录下的多个 Node.js 框架（Egg.js, Express, Koa, NestJS）示例中。由于是示例性质，不存在全仓库统一的日志基础设施，但展示了高度一致的**日志格式化规范**和**中间件集成模式**。

### 1. 核心系统与工具
- **主要框架**：`log4js` (Express, Koa, NestJS), `morgan` (Express), Egg.js 内置 Logger, 原生 `console` (Koa)。
- **统一标识**：所有日志输出均强制包含 `[HZ-9]` 前缀，用于在混合部署或聚合日志中快速识别来源。

### 2. 关键文件与实现
- **Egg.js**: 
  - `practice/nodejs-service/egg/request-log/config/config.default.ts`: 配置自定义 Logger `request`，定义 `formatter` 和 `contextFormatter` 以统一输出格式。
  - `practice/nodejs-service/egg/request-log/app/middleware/request-log.ts`: 实现请求日志中间件，手动组装日志字符串并调用 `ctx.app.getLogger('request').info()`。
- **Express/Koa (log4js)**:
  - `practice/nodejs-service/express/request-log-log4js/middleware/log4js.middleware.js`: 使用 `log4js.connectLogger` 结合自定义 `pattern` 布局。
  - `practice/nodejs-service/koa/request-log-log4js/middleware/log4js.middleware.js`: 适配 Koa 上下文，将 `ctx.req/res` 传递给 log4js。
- **NestJS**:
  - `practice/nodejs-service/nest/request-log-log4js/src/middleware/log4js.logger.ts`: 继承 `ConsoleLogger` 并内部委托给 `log4js`，重写 `verbose/debug/log/warn/error` 方法以支持 Context 标记。
- **Express (morgan)**:
  - `practice/nodejs-service/express/request-log-morgan/middleware/morgan.middleware.js`: 通过 `morgan.token` 自定义 PID、时间戳、Level 等字段，拼接成统一格式。

### 3. 架构约定与格式化规范
- **标准日志格式**：
  `[HZ-9] {PID} - {Timestamp} {Level} [{Marker}] {Message}`
  - **PID**: 6位右对齐。
  - **Timestamp**: `yyyy-MM-dd hh:mm:ss`。
  - **Level**: 7位右对齐 (如 `   INFO`)。
  - **Marker**: 14位右对齐 (如 `        COMMON`, `       Request`)。
- **请求日志内容**：
  `{RemoteAddr} - "{Method} {Url} HTTP/{Version}" {Status} {ContentLength} {ResponseTime}ms "{Referrer}" "{UserAgent}"`

### 4. 开发者建议
- **一致性优先**：在不同框架中迁移时，应保持上述 `[HZ-9]` 开头的日志格式不变，以便于运维侧的日志解析（如 Grok 模式）。
- **中间件封装**：请求日志应通过中间件自动注入，避免在业务代码中手动记录基础 HTTP 信息。
- **Context 标记**：在 NestJS 等多模块应用中，利用 `log4js` 的 Context 功能动态切换 Marker，以区分不同模块的日志输出。