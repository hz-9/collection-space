该仓库是一个包含多个独立 Node.js 练习项目和脚本的集合，不同子项目采用了不同的包管理器策略，主要体现为 **pnpm** 和 **npm** 的混用。

### 1. 包管理器选择
*   **pnpm (主流)**: 大多数较新的或基于 TypeScript/Egg.js/NestJS 的项目（如 `practice/nodejs-service/egg/*`, `practice/nodejs-service/nest/*`, `handwritten-code`, `practice/vue3-frontend/*`）使用 `pnpm`。证据是这些目录下存在 `pnpm-lock.yaml` 文件。
*   **npm (传统/简单项目)**: 部分基于 Express/Koa 的简单示例项目（如 `practice/nodejs-service/express/*`, `practice/nodejs-service/koa/*`）使用 `npm`。证据是这些目录下存在 `package-lock.json` 文件。

### 2. 依赖声明与版本控制
*   **Manifest 文件**: 每个子项目根目录均包含 `package.json`，用于声明 `dependencies` 和 `devDependencies`。
*   **Lock 文件**: 
    *   `pnpm-lock.yaml`: 用于 pnpm 项目，锁定依赖树的具体版本和完整性哈希，确保跨环境一致性。
    *   `package-lock.json`: 用于 npm 项目，作用类似。
*   **私有/组织包**: 项目中使用了自定义的组织范围包，如 `@hz-9/eslint-config-airbnb-ts` 和 `@hz-9/prettier-config`。这些包通常从公共 registry 拉取（如 `registry.npmjs.org` 或 `registry.npmmirror.com`），但在企业内部可能配置了私有代理或镜像。

### 3. 架构与约定
*   **单体仓库风格 (Monorepo-like)**: 虽然没有使用标准的 Monorepo 工具（如 Lerna, Nx, Turborepo）进行统一管理，但通过目录结构隔离了多个独立项目。每个项目独立维护其依赖，互不共享 `node_modules`。
*   **引擎约束**: 部分项目（如 Egg.js 示例）在 `package.json` 中指定了 `engines` 字段（例如 `"node": ">=20.10.0"`），以约束运行环境版本。
*   **开发工具链统一**: 尽管框架不同，但大多数项目共享相似的 DevDependencies，如 `eslint`, `prettier`, `typescript`, 以及特定的配置包 `@hz-9/*`，体现了团队统一的代码规范和格式化标准。

### 4. 开发者注意事项
*   **安装依赖**: 进入具体子项目目录后，需根据存在的 lock 文件选择正确的命令：
    *   若存在 `pnpm-lock.yaml`，请运行 `pnpm install`。
    *   若存在 `package-lock.json`，请运行 `npm install`。
*   **不要混用**: 避免在同一项目中混用 `npm` 和 `pnpm` 安装依赖，这会导致 lock 文件冲突和依赖树不一致。
*   **私有包权限**: 如果 `@hz-9` 范围的包无法下载，可能需要检查 `.npmrc` 或 `.yarnrc` 配置，确保已登录私有 Registry 或配置了正确的镜像地址。