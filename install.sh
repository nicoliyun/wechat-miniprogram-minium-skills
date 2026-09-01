#!/usr/bin/env bash
#
# wechat-miniprogram-minium —— Skill 安装脚本 (macOS / Linux)
#
# 用法:
#   ./install.sh                   安装到 ~/.codebuddy/skills（默认）
#   ./install.sh --claude          安装到 ~/.claude/skills
#   ./install.sh --all             同时安装到 CodeBuddy 与 Claude Code
#   ./install.sh -t /path/to/dir   安装到自定义 skills 目录
#   ./install.sh --force           覆盖已存在的同名 skill
#   ./install.sh --no-backup       覆盖时不备份旧版本
#   ./install.sh -n                演练，只打印不落盘
#   ./install.sh -h                查看帮助
#
set -euo pipefail

SKILL_NAME="wechat-miniprogram-minium"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skill"

TARGETS=()
FORCE=0
DO_BACKUP=1
DRY_RUN=0

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { printf "${BLUE}[info]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[ ok ]${NC}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${NC}  %s\n" "$*"; }
fail()  { printf "${RED}[fail]${NC}  %s\n" "$*" >&2; exit 1; }

usage() {
  sed -n '3,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)   [[ $# -ge 2 ]] || fail "--target 需要跟一个目录路径"; TARGETS+=("$2"); shift 2 ;;
    --codebuddy)   TARGETS+=("${HOME}/.codebuddy/skills"); shift ;;
    --claude)      TARGETS+=("${HOME}/.claude/skills"); shift ;;
    --all)         TARGETS+=("${HOME}/.codebuddy/skills" "${HOME}/.claude/skills"); shift ;;
    -f|--force)    FORCE=1; shift ;;
    --no-backup)   DO_BACKUP=0; shift ;;
    -n|--dry-run)  DRY_RUN=1; shift ;;
    -h|--help)     usage ;;
    *)             fail "未知参数: $1（用 -h 查看帮助）" ;;
  esac
done

[[ ${#TARGETS[@]} -eq 0 ]] && TARGETS=("${HOME}/.codebuddy/skills")

# ---------- 前置校验 ----------
[[ -d "${SOURCE_DIR}" ]] || fail "找不到 skill 源目录: ${SOURCE_DIR}"
[[ -f "${SOURCE_DIR}/SKILL.md" ]] || fail "源目录缺少 SKILL.md: ${SOURCE_DIR}/SKILL.md"

FRONT_NAME="$(grep -m1 -E '^name:[[:space:]]*' "${SOURCE_DIR}/SKILL.md" | sed -E 's/^name:[[:space:]]*//' | tr -d '\r')"
if [[ -n "${FRONT_NAME}" && "${FRONT_NAME}" != "${SKILL_NAME}" ]]; then
  warn "SKILL.md 中的 name(${FRONT_NAME}) 与安装目录名(${SKILL_NAME}) 不一致，已按目录名为准"
fi

info "skill: ${SKILL_NAME}"
info "源目录: ${SOURCE_DIR}"
info "目标:   ${TARGETS[*]}"
[[ ${DRY_RUN} -eq 1 ]] && warn "演练模式，不会写入任何文件"
echo

# ---------- 安装 ----------
install_to() {
  local base="$1"
  local dest="${base}/${SKILL_NAME}"

  if [[ -d "${dest}" ]]; then
    if [[ ${FORCE} -eq 0 ]]; then
      warn "已存在，跳过: ${dest}（加 --force 覆盖）"
      return 0
    fi
    if [[ ${DO_BACKUP} -eq 1 ]]; then
      local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
      info "备份旧版本 -> ${backup}"
      [[ ${DRY_RUN} -eq 1 ]] || mv "${dest}" "${backup}"
    else
      info "删除旧版本: ${dest}"
      [[ ${DRY_RUN} -eq 1 ]] || rm -rf "${dest}"
    fi
  fi

  info "安装 -> ${dest}"
  if [[ ${DRY_RUN} -eq 0 ]]; then
    mkdir -p "${dest}"
    cp -R "${SOURCE_DIR}/." "${dest}/"
    # 清理模板目录可能残留的编译产物
    find "${dest}" -type d -name '__pycache__' -prune -exec rm -rf {} + 2>/dev/null || true
    find "${dest}" -type f -name '*.pyc' -delete 2>/dev/null || true
    [[ -f "${dest}/SKILL.md" ]] || fail "安装后校验失败: ${dest}/SKILL.md 不存在"
  fi
  ok "完成: ${dest}"
}

for t in "${TARGETS[@]}"; do
  install_to "$t"
done

echo
ok "安装结束。重启 IDE / CLI 会话后生效。"
echo
echo "使用方式：在对话中直接描述需求即可触发，例如："
echo "  · 用 minium 给这个小程序写登录模块的自动化测试"
echo "  · minium 元素定位不到怎么排查"
echo "  · 帮我生成 config.json 和第一条用例"
echo
echo "脚手架模板: ${TARGETS[0]}/${SKILL_NAME}/templates"
echo "离线文档:   ${TARGETS[0]}/${SKILL_NAME}/references"
