#!/bin/bash
# Claude Code 환경 설정 복원 스크립트
# 도서관 등 다른 PC에서 사용할 때 실행

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
PROJECTS_DIR="$CLAUDE_DIR/projects/C--Users-user/memory"

echo "=== Claude Code 환경 설정 복원 ==="
echo ""

# 1. ~/.claude 디렉토리 생성
echo "[1/5] 디렉토리 생성..."
mkdir -p "$CLAUDE_DIR/skills/email-composer"
mkdir -p "$CLAUDE_DIR/skills/html-to-pdf"
mkdir -p "$CLAUDE_DIR/skills/news-writer/references"
mkdir -p "$CLAUDE_DIR/hud"
mkdir -p "$PROJECTS_DIR"

# 2. 핵심 설정 파일 복사
echo "[2/5] 설정 파일 복사..."
cp "$SCRIPT_DIR/dot-claude/settings.json" "$CLAUDE_DIR/settings.json"
cp "$SCRIPT_DIR/dot-claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

# 3. 글로벌 CLAUDE.md 복사
echo "[3/5] 글로벌 CLAUDE.md 복사..."
cp "$SCRIPT_DIR/global-CLAUDE.md" "$HOME/CLAUDE.md"

# 4. Skills 복사
echo "[4/5] Skills 복사..."
cp "$SCRIPT_DIR/dot-claude/skills/email-composer/SKILL.md" "$CLAUDE_DIR/skills/email-composer/SKILL.md"
cp "$SCRIPT_DIR/dot-claude/skills/html-to-pdf/SKILL.md" "$CLAUDE_DIR/skills/html-to-pdf/SKILL.md"
cp "$SCRIPT_DIR/dot-claude/skills/news-writer/SKILL.md" "$CLAUDE_DIR/skills/news-writer/SKILL.md"
cp "$SCRIPT_DIR/dot-claude/skills/news-writer/references/article-types.md" "$CLAUDE_DIR/skills/news-writer/references/article-types.md"
cp "$SCRIPT_DIR/dot-claude/skills/news-writer/references/seo-guide.md" "$CLAUDE_DIR/skills/news-writer/references/seo-guide.md"

# 5. HUD & Memory 복사
echo "[5/5] HUD & Memory 복사..."
cp "$SCRIPT_DIR/dot-claude/hud/omc-hud.mjs" "$CLAUDE_DIR/hud/omc-hud.mjs"
cp "$SCRIPT_DIR/memory/MEMORY.md" "$PROJECTS_DIR/MEMORY.md"
cp "$SCRIPT_DIR/memory/html-to-pdf.md" "$PROJECTS_DIR/html-to-pdf.md"

echo ""
echo "=== 설정 복원 완료! ==="
echo ""
echo "추가 작업:"
echo "  1. claude 로그인: claude login"
echo "  2. OMC 설치: /oh-my-claudecode:omc-setup"
echo "  3. MCP 서버 확인: claude mcp list"
echo ""
echo "※ settings.local.json (권한 설정)은 사용하면서 자동 생성됩니다."
echo "※ .credentials.json은 로그인 시 자동 생성됩니다."
