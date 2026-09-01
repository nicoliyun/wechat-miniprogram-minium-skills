#!/usr/bin/env bash
#
# 校验 skill 结构完整性（CI 与本地均可运行）
#   ./scripts/check.sh
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILL_DIR="${ROOT_DIR}/skill"
SKILL_NAME="wechat-miniprogram-minium"

RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
ERRORS=0
pass() { printf "${GREEN}  ✓${NC} %s\n" "$1"; }
err()  { printf "${RED}  ✗${NC} %s\n" "$1"; ERRORS=$((ERRORS + 1)); }

echo "校验 skill: ${SKILL_NAME}"
echo

# 1. 必备文件
[[ -f "${SKILL_DIR}/SKILL.md" ]] && pass "SKILL.md 存在" || err "SKILL.md 缺失"

# 2. frontmatter
if [[ -f "${SKILL_DIR}/SKILL.md" ]]; then
  head -1 "${SKILL_DIR}/SKILL.md" | grep -q '^---$' \
    && pass "frontmatter 起始分隔符正确" || err "SKILL.md 缺少 frontmatter 起始 '---'"

  NAME="$(grep -m1 -E '^name:[[:space:]]*' "${SKILL_DIR}/SKILL.md" | sed -E 's/^name:[[:space:]]*//' | tr -d '\r')"
  [[ "${NAME}" == "${SKILL_NAME}" ]] \
    && pass "name 字段与目录名一致 (${NAME})" || err "name 字段为 '${NAME}'，期望 '${SKILL_NAME}'"

  grep -qE '^description:' "${SKILL_DIR}/SKILL.md" \
    && pass "description 字段存在" || err "SKILL.md 缺少 description 字段"

  LINES="$(wc -l < "${SKILL_DIR}/SKILL.md" | tr -d ' ')"
  [[ ${LINES} -lt 500 ]] \
    && pass "SKILL.md 行数 ${LINES}（建议 < 500）" || err "SKILL.md 行数 ${LINES} 过多，建议拆分到 references"
fi

# 3. references
REF_COUNT="$(find "${SKILL_DIR}/references" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
[[ ${REF_COUNT} -ge 20 ]] \
  && pass "references 文档数 ${REF_COUNT}" || err "references 文档数仅 ${REF_COUNT}，疑似不完整"

# 4. templates
for f in config.json suite.json test/__init__.py test/first_test.py; do
  [[ -f "${SKILL_DIR}/templates/${f}" ]] && pass "templates/${f}" || err "templates/${f} 缺失"
done

# 5. JSON 合法性
for f in "${SKILL_DIR}"/templates/*.json; do
  python3 -c "import json,sys; json.load(open('${f}'))" 2>/dev/null \
    && pass "JSON 合法: $(basename "${f}")" || err "JSON 非法: $(basename "${f}")"
done

# 6. Python 语法
for f in "${SKILL_DIR}"/templates/test/*.py; do
  python3 -m py_compile "${f}" 2>/dev/null \
    && pass "Python 语法 OK: $(basename "${f}")" || err "Python 语法错误: $(basename "${f}")"
done
find "${SKILL_DIR}" -type d -name '__pycache__' -prune -exec rm -rf {} + 2>/dev/null || true

echo
if [[ ${ERRORS} -eq 0 ]]; then
  printf "${GREEN}全部校验通过${NC}\n"
  exit 0
else
  printf "${RED}${ERRORS} 项校验失败${NC}\n"
  exit 1
fi
