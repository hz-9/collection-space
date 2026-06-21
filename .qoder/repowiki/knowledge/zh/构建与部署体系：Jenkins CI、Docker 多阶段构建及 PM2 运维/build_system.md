该仓库采用以 **Jenkins** 为核心的持续集成/持续部署（CI/CD）体系，结合 **Docker** 容器化技术与 **PM2** 进程管理器，构建了针对 Node.js 后端服务与 Vue3 前端应用的标准化构建与发布流程。

### 1. 核心构建工具与策略
- **包管理工具**：全面采用 `pnpm`（版本 ^9.0.0）进行依赖管理，利用其硬链接机制优化磁盘空间与安装速度。在 Docker 构建中，通过 `pnpm prune --prod` 剔除开发依赖以减小镜像体积。
- **编译与打包**：
  - **前端 (Vue3)**：使用 Vite 进行构建，产物存放于 `dist` 目录。
  - **后端 (Egg/Nest/Express/Koa)**：TypeScript 项目通过 `tsc` 或框架 CLI（如 `nest build`）编译为 JavaScript，随后启动生产环境服务。
- **多阶段构建 (Multi-stage Builds)**：Dockerfile 普遍采用两阶段构建模式。第一阶段基于 `node:20.x` 安装依赖并编译代码；第二阶段将静态资源或编译后的代码拷贝至轻量级运行时环境（如 `nginx:alpine` 或精简的 Node 镜像），显著降低最终镜像大小。

### 2. CI/CD 流水线设计 (Jenkins)
仓库在 `ci&cd/jenkins/jenkinsfile/` 目录下提供了模块化的 Jenkinsfile 模板，支持不同场景的自动化流程：
- **服务类 (service.*.Jenkinsfile)**：
  - **构建**：在 Docker 容器内执行 `npm install` 和编译。
  - **归档**：将工作区打包为带时间戳的 `.tar.gz` 文件并归档。
  - **部署**：通过 `sshPublisher` 插件将制品推送到远程服务器，解压后利用 **PM2** (`pm2 start process.yml`) 实现零停机重启与服务守护。
- **网站类 (website.*.Jenkinsfile)**：
  - **构建**：执行 `npm run build` 生成静态资源。
  - **部署**：将静态文件分发至 Nginx 服务器指定目录。
- **版本管理**：采用时间戳格式（`yyyyMMddHHmmss`）作为版本号，确保制品的唯一性与可追溯性。

### 3. 本地开发与测试环境
- **Docker Compose 编排**：在 `practice/docker-env/` 下提供 `docker-compose.yml`，一键拉起包含 Nginx、Express、Koa、Egg、Nest 等多服务的跨域测试环境。通过自定义网络别名（aliases）模拟真实域名解析。
- **脚本化工具**：提供 `build.sh`、`up.sh`、`down.sh` 等 Shell 脚本，简化环境准备、合并配置及容器启停操作。
- **Node 版本控制**：根目录及各子项目均包含 `.nvmrc` 文件，强制统一 Node.js 运行版本（主要为 v20.x），避免环境差异导致的构建失败。

### 4. 开发者规范
- **依赖安装**：所有项目必须使用 `pnpm install`，禁止直接使用 `npm install` 以免产生冲突的 lock 文件。
- **容器化标准**：新增服务需配套编写 `dockerfile`，遵循“构建与运行分离”原则，并在 `.dockerignore` 中排除 `node_modules` 等非必要文件。
- **部署配置**：生产环境部署需配套 `process.yml` (PM2) 或 Nginx 配置文件，并确保 Jenkins 任务中配置的 SSH 凭据与服务器路径一致。