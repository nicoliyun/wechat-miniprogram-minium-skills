#!/usr/bin/env bash
#
# 打包 skill 为可分发的 .skill 压缩包
#   ./package.sh           使用 VERSION 文件（缺省 1.0.0）
#   ./package.sh 1.2.0     指定版本号
#
set -euo pipefail

SKILL_NAME="wechat-miniprogram-minium"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skill"
DIST_DIR="${SCRIPT_DIR}/dist"

VERSION="${1:-}"
if [[ -z "${VERSION}" ]]; then
  if [[ -f "${SCRIPT_DIR}/VERSION" ]]; then
    VERSION="$(tr -d '[:space:]' < "${SCRIPT_DIR}/VERSION")"
  else
    VERSION="1.0.0"
  fi
fi

[[ -d "${SOURCE_DIR}" ]] || { echo "[fail] 找不到 skill 源目录: ${SOURCE_DIR}" >&2; exit 1; }
[[ -f "${SOURCE_DIR}/SKILL.md" ]] || { echo "[fail] 缺少 SKILL.md" >&2; exit 1; }

if ! command -v zip >/dev/null 2>&1; then
  echo "[fail] 未找到 zip 命令，请先安装（macOS 自带；Linux: apt install zip）" >&2
  exit 1
fi

mkdir -p "${DIST_DIR}"
OUT="${DIST_DIR}/${SKILL_NAME}-${VERSION}.skill"
rm -f "${OUT}"

# 压缩包内以 SKILL.md 为根，便于各工具直接导入
( cd "${SOURCE_DIR}" && zip -rq "${OUT}" . -x '*.DS_Store' -x '__pycache__/*' -x '*.pyc' )

echo "[ ok ] 已生成: ${OUT}"
echo "       大小: $(du -h "${OUT}" | cut -f1)"
echo "       条目: $(unzip -Z1 "${OUT}" | wc -l | tr -d ' ') 个文件"
