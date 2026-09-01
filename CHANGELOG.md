# 更新日志

本项目版本遵循 [语义化版本](https://semver.org/lang/zh-CN/)：`主版本.次版本.修订号`。
`minium-doc` 一列表示所依据的微信官方 minium 文档/框架版本。

## [1.0.0] - 2026-09-01  (minium v1.6.0)

首次发布，基于微信官方 minium 文档全量封装。

**新增**

- `SKILL.md`：369 行主文档，包含
  - 核心对象模型（Minium / App / Page / Element / Native / H5Page）
  - 六步标准工作流（环境检查 → 项目骨架 → 配置 → 用例 → 运行 → 报告）
  - config.json 全部常用配置项速查
  - minitest / miniwxml / minireport 命令行速查
  - 元素定位（8 类选择器、跨自定义组件 `>>>`、`miniwxml` 排查流程、`auto_fix`）
  - MiniTest 属性方法、14 个用例修饰器、DDT 数据驱动
  - App / Page / Element / Native 常用 API 速查
  - Mock 与 Hook 用法、uni-app / taro 框架的 `wx._MINI_WX_PROXY_` 适配
  - Android / iOS / 云真机配置要点与版本坑
  - 10 条编写规范 Checklist、10 类常见错误排查表
- `references/`：20 篇官方文档快照 + `api/` 下 14 个类的完整 API 文档
- `templates/`：可直接复制的项目脚手架（config.json / suite.json / test 包 / 示例用例）
- 安装与分发：`install.sh`（macOS/Linux）、`install.ps1`（Windows）、`Makefile`、`package.sh`、`scripts/check.sh`
