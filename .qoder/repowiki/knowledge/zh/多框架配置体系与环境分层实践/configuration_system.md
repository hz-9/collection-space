该仓库是一个包含多种 Node.js 后端框架（Egg.js, Express, Koa, NestJS）和前端框架（Vue3）的示例集合。其配置系统呈现出明显的**框架原生驱动**与**环境分层**特征，缺乏统一的跨项目配置抽象层。

### 1. 核心配置模式

#### Egg.js：约定式环境分层
Egg.js 项目严格遵循其框架约定的配置加载机制，通过 `config` 目录下的文件实现环境隔离：
- **基础配置** (`config.default.ts`)：定义所有环境共享的配置，如 `keys`、`security`（CSRF、域名白名单）、`cors` 策略等。支持通过函数形式接收 `appInfo` 动态生成配置。
- **环境覆盖** (`config.local.ts`, `config.prod.ts`)：针对特定环境（本地开发、生产）提供增量覆盖或全量替换。目前示例中多为空对象，表明主要依赖默认配置。
- **插件管理** (`plugin.ts`)：独立管理插件的启用状态与包名，如 `egg-cors`、`egg-tracer` 及 Tegg 模块套件，实现了配置与插件声明的解耦。

#### Vue3 + Vite：构建时配置与代理
前端项目使用 `vite.config.ts` 进行构建工具链配置：
- **路径别名**：通过 `resolve.alias` 配置 `@` 指向 `src` 目录。
- **开发代理**：在 `server.proxy` 中定义多条规则（如 `/proxy/3000`），将请求转发至本地不同端口的后端服务，解决开发环境的跨域问题。

#### Express / Koa / NestJS：代码即配置
这些框架的示例项目倾向于在入口文件（如 `app.js`, `main.ts`）或模块定义中直接硬编码配置：
- **Express/Koa**：中间件注册、静态资源路径、错误处理逻辑直接写在应用初始化脚本中。
- **NestJS**：通过 `@Module` 装饰器和 `main.ts` 中的 `NestFactory.create` 进行模块化配置，端口号等参数通常直接写在启动脚本中。

### 2. 关键配置文件
- `practice/nodejs-service/egg/*/config/config.*.ts`: Egg.js 环境分层配置的核心。
- `practice/nodejs-service/egg/*/config/plugin.ts`: Egg.js 插件开关与映射。
- `practice/vue3-frontend/cross-domain/vite.config.ts`: 前端构建与开发服务器代理配置。
- `practice/nodejs-service/*/package.json`: 通过 `scripts` 字段定义不同环境的启动命令（如 `egg-bin dev --port 3002`）。

### 3. 开发规范与建议
- **环境隔离**：在 Egg.js 项目中，严禁在 `config.default.ts` 中写入敏感的环境特定信息（如数据库密码），应利用 `config.local.ts` 或环境变量注入。
- **配置合并逻辑**：理解 Egg.js 的 `PowerPartial` 类型与配置合并策略，确保在覆盖配置时不会意外删除深层嵌套的默认项。
- **代理一致性**：前端 `vite.config.ts` 中的代理路径应与后端路由前缀保持同步，避免联调时的 404 错误。