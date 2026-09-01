# wechat-miniprogram-minium

> 把微信官方 [minium](https://minitest.weixin.qq.com/#/minium/Python/readme) 小程序自动化测试框架的全部知识，封装成一个可被 AI 编程助手直接加载、直接照做的 **Skill**。
>
> 装上它之后，你只需要用自然语言说「用 minium 给登录模块写自动化测试」，助手就会按规范产出环境检查、`config.json`、用例代码、定位策略与排错方案。

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![minium](https://img.shields.io/badge/minium-v1.6.0-blue.svg)](https://minitest.weixin.qq.com/#/minium/Python/readme)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)](#快速安装)

---

## 目录

- [它能做什么](#它能做什么)
- [快速安装](#快速安装)
- [使用方式](#使用方式)
- [目录结构](#目录结构)
- [Skill 内容清单](#skill-内容清单)
- [用模板起一个新项目](#用模板起一个新项目)
- [更新与卸载](#更新与卸载)
- [打包分发](#打包分发)
- [发布到 Git 仓库](#发布到-git-仓库)
- [常见问题](#常见问题)
- [贡献](#贡献)
- [许可证与版权声明](#许可证与版权声明)

---

## 它能做什么

| 场景 | Skill 提供的能力 |
| :-- | :-- |
| 从零搭建 | 环境检查清单（含「安全模式服务端口」等高频坑）、目录骨架、`config.json` 全套配置项 |
| 编写用例 | MiniTest 基类用法、14 个用例修饰器、DDT 数据驱动、断言集合、10 条编写规范 |
| 元素定位 | 8 类选择器语法、跨自定义组件 `>>>` 穿透、xpath 取舍、`miniwxml` 离线排查流程、`auto_fix` |
| 解除依赖 | Mock / Hook 微信 API、Callback 监听、uni-app / taro 的 `wx._MINI_WX_PROXY_` 适配 |
| 原生交互 | Native 授权弹窗、Modal、支付、地图选点、输入、性能采集 |
| 真机执行 | Android / iOS（WDA 三种配置方式）/ 云真机，含真机调试 1.0 与 2.0 的版本坑 |
| 运行报告 | `minitest` 全参数、`suite.json` 测试计划、报告生成与静态托管 |
| 排错 | 10 类常见报错的现象 → 原因 → 处理对照表 |

**设计原则**：`SKILL.md` 只放「工作流 + 速查表」（369 行，避免撑爆上下文），完整 API 签名与官方原文放 `references/`，按需渐进加载。

---

## 快速安装

### 方式一：一键脚本（推荐）

```bash
git clone https://github.com/<your-name>/wechat-miniprogram-minium.git
cd wechat-miniprogram-minium

./install.sh                 # 安装到 ~/.codebuddy/skills（默认）
./install.sh --claude        # 安装到 ~/.claude/skills（Claude Code）
./install.sh --all           # 两者都装
./install.sh -t /path/to/skills   # 自定义目录（其他 Agent 同理）
```

常用参数：

| 参数 | 说明 |
| :-- | :-- |
| `-t, --target DIR` | 自定义安装目录 |
| `--codebuddy` / `--claude` / `--all` | 预设目标 |
| `-f, --force` | 覆盖已安装的同名 Skill（自动备份为 `*.bak.<时间戳>`） |
| `--no-backup` | 覆盖时不备份 |
| `-n, --dry-run` | 演练，只打印不落盘 |
| `-h, --help` | 帮助 |

Windows（PowerShell）：

```powershell
.\install.ps1
.\install.ps1 -All -Force
.\install.ps1 -Target "D:\skills"
```

### 方式二：Make

```bash
make install          # 安装到 CodeBuddy
make install-claude   # 安装到 Claude Code
make install-all      # 两者都装
make reinstall        # 覆盖重装（自动备份）
make uninstall        # 卸载
make check            # 校验 Skill 结构完整性
make package          # 打包为 dist/*.skill
```

### 方式三：手动复制

把 `skill/` 整个目录复制到你的 skills 目录，并**重命名为 `wechat-miniprogram-minium`**：

```bash
cp -R skill ~/.codebuddy/skills/wechat-miniprogram-minium
```

> ⚠️ 目录名必须与 `SKILL.md` 中的 `name` 字段一致，否则部分工具无法识别。

---

## 使用方式

安装后**重启 IDE / CLI 会话**，然后在对话中直接用自然语言描述需求即可，无需记命令：

```
用 minium 给这个小程序写登录模块的自动化测试
帮我生成 config.json 和第一条用例
minium 元素定位不到怎么排查
真机调试 1.0 取不到元素怎么办
把这个用例改成数据驱动
```

触发关键词：`minium`、小程序自动化测试、`config.json`、`MiniElementNotFoundError`、Mock/Hook、真机调试、`minitest` 命令等。

---

## 目录结构

```
wechat-miniprogram-minium/
├── README.md              # 本文件
├── LICENSE                # MIT（含第三方文档版权声明）
├── CHANGELOG.md
├── VERSION
├── Makefile               # make install / uninstall / package / check
├── install.sh             # macOS / Linux 安装脚本
├── install.ps1            # Windows 安装脚本
├── package.sh             # 打包为 .skill
├── scripts/check.sh       # 结构完整性校验（可接 CI）
└── skill/                 # ★ Skill 本体
    ├── SKILL.md           # 主文档：工作流 + 速查表
    ├── references/        # 20 篇官方文档快照
    │   └── api/           # 14 个类的完整 API 文档
    └── templates/         # 项目脚手架
        ├── config.json
        ├── suite.json
        ├── .gitignore
        └── test/
            ├── __init__.py
            └── first_test.py
```

---

## Skill 内容清单

### `SKILL.md`（主文档）

1. 使用边界
2. 核心对象模型（`Minium → App → Page → Element`，以及 `Native` / `H5Page`）
3. 六步标准工作流 SOP
4. 配置要点表
5. 命令行速查
6. 元素定位（最高频故障点）
7. 用例编写规范（MiniTest / 修饰器 / DDT / 断言）
8. 常用 API 速查（App / Page / Element / Native）
9. Mock / Hook
10. 真机与云真机
11. 10 条编写规范 Checklist
12. 10 类常见错误排查表
13. 参考资料索引
14. 执行前必读提醒

### `references/`（按需加载）

| 文件 | 内容 |
| :-- | :-- |
| `01-quickstart.md` | 运行环境、安装、环境检查、最小可运行示例 |
| `02-first-case.md` | 目录结构、第一个 case、运行与查看结果 |
| `03-config.md` | 全部配置项、Android/iOS `device_desire`、`mock_native_modal`、`mock_request` |
| `04-cli.md` / `05-suite.md` | 命令行工具 / 测试计划 |
| `06-result-report.md` | 结果目录结构与报告生成、托管方式 |
| `07-framework-intro.md` | 测试框架做了哪些封装 |
| `08-MiniTest.md` | MiniTest 属性与方法 |
| `09-assert.md` / `10-modifier.md` / `11-callback.md` | 断言 / 修饰器 / Callback |
| `12-selector.md` | 元素定位（含自定义组件判别、排查流程） |
| `13-mock-hook.md` | mock/hook 原理、验证方法、第三方框架适配 |
| `14-network-panel.md` | 网络请求日志与自定义监听 |
| `15-multi-accounts.md` | 多账号并行配置 |
| `16-real-device.md` | Android/iOS 真机、WDA 配置、云真机对比 |
| `17-h5-test.md` | 内嵌 H5（仅 Android 真机） |
| `18-samples.md` | 官方示例：UI / 单页面 / 原生组件 / mock / 接口 / DDT |
| `19-faq.md` / `20-update-log.md` | 反馈渠道 / 版本更新日志 |
| `api/*.md` | Minium、App、Page、Element 及 Form / View / Custom / Video / Audio / Live 子类、Native、H5Page、H5Element |

文档内部链接已重写为官方线上地址，可直接点击跳转。

---

## 用模板起一个新项目

```bash
# 1. 复制脚手架到你的测试工程
cp -R ~/.codebuddy/skills/wechat-miniprogram-minium/templates ./miniprogram-autotest
cd miniprogram-autotest

# 2. 填写三项真实信息（JSON 不支持注释，勿加 //）
#    project_path / dev_tool_path / platform
vim config.json

# 3. 安装框架并自检
pip3 install minium
minitest -v

# 4. 跑通第一条用例
minitest -m test.first_test -c config.json -g

# 5. 查看报告（静态站点，不能直接双击 html）
python3 -m http.server 12345 -d outputs
# 浏览器打开 http://localhost:12345
```

模板默认路径：

| 平台 | `dev_tool_path` 默认值 |
| :-- | :-- |
| macOS | `/Applications/wechatwebdevtools.app/Contents/MacOS/cli` |
| Windows | `C:/Program Files (x86)/Tencent/微信web开发者工具/cli.bat` |

---

## 更新与卸载

```bash
# 更新（拉取最新代码后覆盖重装，旧版本自动备份）
git pull && ./install.sh --all --force

# 卸载
make uninstall
# 或
rm -rf ~/.codebuddy/skills/wechat-miniprogram-minium ~/.claude/skills/wechat-miniprogram-minium
```

---

## 打包分发

```bash
./package.sh            # 读取 VERSION，生成 dist/wechat-miniprogram-minium-1.0.0.skill
./package.sh 1.2.0      # 指定版本
```

产物为标准 zip，包内以 `SKILL.md` 为根，可直接导入支持 `.skill` 的工具，或解压后按「方式三：手动复制」安装。

---

## 发布到 Git 仓库

```bash
cd wechat-miniprogram-minium
git init
git add .
git commit -m "feat: wechat-miniprogram-minium skill v1.0.0"
git branch -M main
git remote add origin https://github.com/<your-name>/wechat-miniprogram-minium.git
git push -u origin main
```

发布建议：

- 打 tag：`git tag v1.0.0 && git push --tags`
- 在仓库 About 填好描述与 Topics：`minium` `wechat` `miniprogram` `automation` `testing` `skill` `ai-agent`
- 把 README 顶部的徽章链接里的 `<your-name>` 替换为你的 GitHub 用户名
- CI 可加一步 `make check`，保证 Skill 结构不被改坏

---

## 常见问题

**Q：装完没生效？**
A：重启 IDE / CLI 会话。Skill 一般在会话启动时加载。

**Q：目录名能改吗？**
A：不建议。若必须改，需同步修改 `skill/SKILL.md` 中 frontmatter 的 `name` 字段，`scripts/check.sh` 会校验二者一致。

**Q：文档会不会过时？**
A：`references/` 是 minium v1.6.0（2024-10-09）的快照。若你使用更新的版本，以 [官方文档](https://minitest.weixin.qq.com/#/minium/Python/readme) 为准，欢迎提 PR 更新。

**Q：支持 JS 版 minium 吗？**
A：不支持。本 Skill 仅覆盖 Python 版。

**Q：`references/` 里的文档能直接商用分发吗？**
A：那是微信官方文档的整理快照，原文著作权归腾讯 / 微信团队所有，仅作离线参考。若你 fork 后对外分发，请保留 `LICENSE` 中的第三方内容声明，或删除 `references/` 后只分发 `SKILL.md` 与 `templates/`。

---

## 贡献

欢迎 PR：

1. 修正 `SKILL.md` 中的事实错误（附官方链接佐证）
2. 补充高频排错场景
3. 同步新版 minium 的 API 与配置变更（同步更新 `CHANGELOG.md` 与 `VERSION`）
4. 优化 `templates/` 脚手架

提交前请跑一遍 `make check`。

---

## 许可证与版权声明

- 本项目的编排、脚本、模板采用 [MIT License](./LICENSE)，可自由使用、修改、分发。
- `skill/references/` 下的文档为微信官方《minium 文档》的整理快照，原文著作权归腾讯 / 微信团队所有，仅作离线参考，不因本项目而改变其权利归属。
- `minium` 为微信团队开源的小程序自动化测试框架，本仓库是非官方的第三方知识封装，与腾讯 / 微信官方无隶属关系。
