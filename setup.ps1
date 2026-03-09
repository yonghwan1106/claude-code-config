# Claude Code 환경 설정 복원 스크립트 (PowerShell)
# 도서관 등 다른 Windows PC에서 사용할 때 실행

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = "$env:USERPROFILE\.claude"
$ProjectsDir = "$ClaudeDir\projects\C--Users-user\memory"

Write-Host "=== Claude Code 환경 설정 복원 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 디렉토리 생성
Write-Host "[1/5] 디렉토리 생성..." -ForegroundColor Yellow
$dirs = @(
    "$ClaudeDir\skills\email-composer",
    "$ClaudeDir\skills\html-to-pdf",
    "$ClaudeDir\skills\news-writer\references",
    "$ClaudeDir\hud",
    "$ProjectsDir"
)
foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
}

# 2. 핵심 설정 파일 복사
Write-Host "[2/5] 설정 파일 복사..." -ForegroundColor Yellow
Copy-Item "$ScriptDir\dot-claude\settings.json" "$ClaudeDir\settings.json" -Force
Copy-Item "$ScriptDir\dot-claude\CLAUDE.md" "$ClaudeDir\CLAUDE.md" -Force

# 3. 글로벌 CLAUDE.md 복사
Write-Host "[3/5] 글로벌 CLAUDE.md 복사..." -ForegroundColor Yellow
Copy-Item "$ScriptDir\global-CLAUDE.md" "$env:USERPROFILE\CLAUDE.md" -Force

# 4. Skills 복사
Write-Host "[4/5] Skills 복사..." -ForegroundColor Yellow
Copy-Item "$ScriptDir\dot-claude\skills\email-composer\SKILL.md" "$ClaudeDir\skills\email-composer\SKILL.md" -Force
Copy-Item "$ScriptDir\dot-claude\skills\html-to-pdf\SKILL.md" "$ClaudeDir\skills\html-to-pdf\SKILL.md" -Force
Copy-Item "$ScriptDir\dot-claude\skills\news-writer\SKILL.md" "$ClaudeDir\skills\news-writer\SKILL.md" -Force
Copy-Item "$ScriptDir\dot-claude\skills\news-writer\references\article-types.md" "$ClaudeDir\skills\news-writer\references\article-types.md" -Force
Copy-Item "$ScriptDir\dot-claude\skills\news-writer\references\seo-guide.md" "$ClaudeDir\skills\news-writer\references\seo-guide.md" -Force

# 5. HUD & Memory 복사
Write-Host "[5/5] HUD & Memory 복사..." -ForegroundColor Yellow
Copy-Item "$ScriptDir\dot-claude\hud\omc-hud.mjs" "$ClaudeDir\hud\omc-hud.mjs" -Force
Copy-Item "$ScriptDir\memory\MEMORY.md" "$ProjectsDir\MEMORY.md" -Force
Copy-Item "$ScriptDir\memory\html-to-pdf.md" "$ProjectsDir\html-to-pdf.md" -Force

Write-Host ""
Write-Host "=== 설정 복원 완료! ===" -ForegroundColor Green
Write-Host ""
Write-Host "추가 작업:" -ForegroundColor Cyan
Write-Host "  1. claude 로그인: claude login"
Write-Host "  2. OMC 설치: /oh-my-claudecode:omc-setup"
Write-Host "  3. MCP 서버 확인: claude mcp list"
Write-Host ""
Write-Host "※ settings.local.json (권한 설정)은 사용하면서 자동 생성됩니다."
Write-Host "※ .credentials.json은 로그인 시 자동 생성됩니다."
