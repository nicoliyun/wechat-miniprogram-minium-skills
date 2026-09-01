SKILL_NAME := wechat-miniprogram-minium
CODEBUDDY_SKILLS := $(HOME)/.codebuddy/skills
CLAUDE_SKILLS    := $(HOME)/.claude/skills
DIST_DIR         := dist

.DEFAULT_GOAL := help
.PHONY: help install install-claude install-all uninstall reinstall package clean check

help: ## 查看帮助
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

install: ## 安装到 CodeBuddy (~/.codebuddy/skills)
	@bash install.sh --codebuddy

install-claude: ## 安装到 Claude Code (~/.claude/skills)
	@bash install.sh --claude

install-all: ## 同时安装到 CodeBuddy 与 Claude Code
	@bash install.sh --all

reinstall: ## 覆盖重装（自动备份旧版本）
	@bash install.sh --all --force

uninstall: ## 卸载
	@rm -rf "$(CODEBUDDY_SKILLS)/$(SKILL_NAME)" "$(CLAUDE_SKILLS)/$(SKILL_NAME)" && echo "已卸载 $(SKILL_NAME)"

package: ## 打包为 dist/$(SKILL_NAME).skill
	@bash package.sh

clean: ## 清理打包产物
	@rm -rf $(DIST_DIR) && echo "已清理 $(DIST_DIR)"

check: ## 校验 skill 结构完整性
	@bash scripts/check.sh
