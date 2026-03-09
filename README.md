# Claude Code 환경 설정 백업

다른 PC(도서관 등)에서 Claude Code 환경을 빠르게 복원하기 위한 설정 파일 모음.

## 포함된 설정

| 파일 | 설명 |
|------|------|
| `dot-claude/settings.json` | 핵심 설정 (MCP 서버, 플러그인, 훅, 언어 등) |
| `dot-claude/CLAUDE.md` | oh-my-claudecode 멀티에이전트 설정 |
| `global-CLAUDE.md` | 프로젝트 워크플로우 규칙 (GitHub 계정, 경로 등) |
| `dot-claude/skills/` | 커스텀 스킬 (email-composer, html-to-pdf, news-writer) |
| `dot-claude/hud/omc-hud.mjs` | OMC HUD 상태표시줄 스크립트 |
| `memory/` | 자동 메모리 파일 (MEMORY.md, html-to-pdf.md) |

## 제외된 파일 (보안)

- `.credentials.json` — 인증 토큰 (로그인 시 자동 생성)
- `settings.local.json` — 권한 설정 (사용하면서 자동 생성)
- `history.jsonl` — 대화 이력

---

## 사용법: 다른 PC에서 환경 복원

### 사전 준비

1. **Node.js 설치**: https://nodejs.org (LTS 버전)
2. **Claude Code 설치**:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
3. **Git 설치** (없는 경우): https://git-scm.com

### 방법 1: 자동 설치 (권장)

```bash
# 1. 레포 클론
git clone https://github.com/yonghwan1106/claude-code-config.git
cd claude-code-config

# 2-A. Git Bash에서 실행
bash setup.sh

# 2-B. 또는 PowerShell에서 실행
powershell -ExecutionPolicy Bypass -File setup.ps1

# 3. Claude 로그인
claude login

# 4. OMC 플러그인 설치 (Claude Code 안에서)
# /oh-my-claudecode:omc-setup
```

### 방법 2: 수동 설치

```bash
# 1. 레포 클론
git clone https://github.com/yonghwan1106/claude-code-config.git
cd claude-code-config

# 2. 디렉토리 생성
mkdir -p ~/.claude/skills/email-composer
mkdir -p ~/.claude/skills/html-to-pdf
mkdir -p ~/.claude/skills/news-writer/references
mkdir -p ~/.claude/hud
mkdir -p ~/.claude/projects/C--Users-user/memory

# 3. 파일 복사
cp dot-claude/settings.json ~/.claude/settings.json
cp dot-claude/CLAUDE.md ~/.claude/CLAUDE.md
cp global-CLAUDE.md ~/CLAUDE.md
cp -r dot-claude/skills/* ~/.claude/skills/
cp dot-claude/hud/omc-hud.mjs ~/.claude/hud/omc-hud.mjs
cp memory/* ~/.claude/projects/C--Users-user/memory/

# 4. Claude 로그인
claude login
```

### 복원 후 확인사항

- `claude mcp list` — MCP 서버 목록 확인
- MCP 서버(cue, supabase 등)는 해당 패키지가 설치되어 있어야 동작
- `settings.local.json`은 도구 사용 시 권한을 허용하면 자동 생성됨

---

## 설정 업데이트 (집 PC에서)

설정을 변경한 후 GitHub에 반영하려면:

```bash
cd ~/projects/2026_active/claude-code-config

# 최신 설정 파일 덮어쓰기
cp ~/.claude/settings.json dot-claude/settings.json
cp ~/.claude/CLAUDE.md dot-claude/CLAUDE.md
cp ~/CLAUDE.md global-CLAUDE.md
cp -r ~/.claude/skills/* dot-claude/skills/
cp ~/.claude/hud/omc-hud.mjs dot-claude/hud/omc-hud.mjs
cp ~/.claude/projects/C--Users-user/memory/* memory/

# 커밋 & 푸시
git add -A
git commit -m "설정 업데이트"
git push
```

도서관에서는 `git pull`로 최신 설정을 받은 후 다시 `setup.sh` 실행.
