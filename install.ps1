# wechat-miniprogram-minium —— Skill 安装脚本 (Windows PowerShell)
#
# 用法（在 PowerShell 中执行）:
#   .\install.ps1                       安装到 %USERPROFILE%\.codebuddy\skills（默认）
#   .\install.ps1 -Claude               安装到 %USERPROFILE%\.claude\skills
#   .\install.ps1 -All                  同时安装到 CodeBuddy 与 Claude Code
#   .\install.ps1 -Target "D:\skills"   安装到自定义目录
#   .\install.ps1 -Force                覆盖已存在的同名 skill
#   .\install.ps1 -NoBackup             覆盖时不备份旧版本
#   .\install.ps1 -WhatIf               演练，只打印不落盘

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]]$Target = @(),
    [switch]$CodeBuddy,
    [switch]$Claude,
    [switch]$All,
    [switch]$Force,
    [switch]$NoBackup
)

$ErrorActionPreference = 'Stop'

$SkillName = 'wechat-miniprogram-minium'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $ScriptDir 'skill'

function Write-Info($msg) { Write-Host "[info]  $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "[ ok ]  $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "[warn]  $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "[fail]  $msg" -ForegroundColor Red; exit 1 }

if ($CodeBuddy) { $Target += (Join-Path $HOME '.codebuddy\skills') }
if ($Claude)    { $Target += (Join-Path $HOME '.claude\skills') }
if ($All)       { $Target += (Join-Path $HOME '.codebuddy\skills'); $Target += (Join-Path $HOME '.claude\skills') }
if ($Target.Count -eq 0) { $Target += (Join-Path $HOME '.codebuddy\skills') }

if (-not (Test-Path $SourceDir)) { Write-Fail "找不到 skill 源目录: $SourceDir" }
if (-not (Test-Path (Join-Path $SourceDir 'SKILL.md'))) { Write-Fail "源目录缺少 SKILL.md" }

Write-Info "skill: $SkillName"
Write-Info "源目录: $SourceDir"
Write-Info "目标:   $($Target -join ', ')"
Write-Host ''

foreach ($base in $Target) {
    $dest = Join-Path $base $SkillName

    if (Test-Path $dest) {
        if (-not $Force) {
            Write-Warn "已存在，跳过: $dest （加 -Force 覆盖）"
            continue
        }
        if (-not $NoBackup) {
            $backup = "$dest.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Write-Info "备份旧版本 -> $backup"
            if ($PSCmdlet.ShouldProcess($dest, 'Backup')) { Move-Item $dest $backup -Force }
        } else {
            Write-Info "删除旧版本: $dest"
            if ($PSCmdlet.ShouldProcess($dest, 'Remove')) { Remove-Item $dest -Recurse -Force }
        }
    }

    Write-Info "安装 -> $dest"
    if ($PSCmdlet.ShouldProcess($dest, 'Install')) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Copy-Item -Path (Join-Path $SourceDir '*') -Destination $dest -Recurse -Force
        Get-ChildItem -Path $dest -Recurse -Directory -Filter '__pycache__' |
            ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }

        if (-not (Test-Path (Join-Path $dest 'SKILL.md'))) {
            Write-Fail "安装后校验失败: $dest\SKILL.md 不存在"
        }
    }
    Write-Ok "完成: $dest"
}

Write-Host ''
Write-Ok '安装结束。重启 IDE / CLI 会话后生效。'
Write-Host ''
Write-Host '使用方式：在对话中直接描述需求即可触发，例如：'
Write-Host '  · 用 minium 给这个小程序写登录模块的自动化测试'
Write-Host '  · minium 元素定位不到怎么排查'
Write-Host '  · 帮我生成 config.json 和第一条用例'
