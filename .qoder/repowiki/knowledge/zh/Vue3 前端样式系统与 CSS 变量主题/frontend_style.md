该仓库包含一个基于 Vue 3 的前端示例项目 (`practice/vue3-frontend/cross-domain`)，其前端样式系统遵循以下约定：

### 1. 核心方法与工具
- **CSS 方法论**：采用原生 CSS 结合 Vue 的 `<style scoped>` 机制。未使用 Sass/Less 等预处理器，也未引入 Tailwind CSS 或大型 UI 组件库。
- **设计令牌 (Design Tokens)**：通过 CSS 自定义属性（CSS Variables）在 `src/assets/base.css` 中定义全局颜色、背景和字体变量。支持基于 `prefers-color-scheme` 的自动深色模式切换。
- **响应式策略**：使用原生 CSS Media Queries (`@media (min-width: 1024px)`) 实现桌面端与移动端的布局适配。

### 2. 关键文件与结构
- **全局样式入口**：`src/assets/main.css` 导入 `base.css` 并定义应用级布局（如 `#app` 的最大宽度和网格布局）。
- **基础变量定义**：`src/assets/base.css` 定义了语义化的颜色变量（如 `--color-background`, `--color-text`）以及重置样式（Reset CSS）。
- **公共静态样式**：`public/common.css` 提供了用于非构建环境（如 iframe 或静态 HTML 页面）的基础样式，复用了部分 CSS 变量逻辑。
- **组件样式**：各 `.vue` 组件（如 `App.vue`, `main-content.vue`）使用 `<style scoped>` 封装局部样式，避免全局污染。

### 3. 架构与约定
- **主题系统**：基于 CSS 变量的轻量级主题系统。通过 `:root` 定义浅色/深色模式的变量映射，利用浏览器原生能力实现主题切换，无需 JavaScript 干预。
- **布局规范**：
  - 移动端优先或单列布局为默认状态。
  - 在大屏幕（>=1024px）下，`body` 启用 Flex 居中，`#app` 启用 Grid 双列布局。
- **字体栈**：使用现代系统字体栈（Inter, -apple-system, Segoe UI, Roboto 等），确保跨平台一致性。

### 4. 开发建议
- **新增样式**：应在组件的 `<style scoped>` 块中编写局部样式。若需复用视觉属性，请引用 `base.css` 中定义的 CSS 变量，而非硬编码颜色值。
- **主题扩展**：如需新增主题色，请在 `base.css` 的 `:root` 中添加对应的 CSS 变量，并在深色模式媒体查询中提供适配值。
- **避免全局污染**：除非必要，严禁在组件中使用非 scoped 的全局样式选择器。