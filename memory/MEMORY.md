# Claude Code Memory

## 최신 정보 반영 원칙 (최우선)
- **모든 작업에서 현재 시점(2026년) 기준의 최신 정보와 트렌드를 반영할 것**
- 학습 데이터 컷오프(2025년 5월) 이후 변화가 크므로, **확실하지 않은 정보는 반드시 웹 검색으로 확인**
- 특히 **공모전 프로젝트**: 최신 기술 트렌드, 정책, 시장 동향을 검색 후 반영 필수
- 프레임워크/라이브러리 버전, API 변경사항, 새로운 도구 등은 **추측하지 말고 공식 문서 확인**
- 연도를 2024년이나 2025년으로 착각하지 말 것 — **현재는 2026년**

## 프로젝트 생성 규칙
- **새 프로젝트는 항상 최신 버전의 프레임워크 사용** (예: `npx create-next-app@latest`, `npm create vite@latest`)
- 구버전으로 생성 후 업그레이드하면 breaking changes 대응에 불필요한 시간 소모

## 사용자 계정 정보
- **Claude Max 사용자** (구독 플랜)

## GitHub 규칙
- **개인 금융 데이터 프로젝트는 GitHub에 올리지 말 것** (거래내역, 투자 분석 등 민감 정보 포함)

## Playwright Settings
- **스크린샷**: `downloadsDir: "C:\\Users\\user\\Desktop\\playwright-output"` 에 저장
- **PDF**: 현재 작업 중인 프로젝트 폴더에 저장 (playwright-output 아님)
- `--output-dir` 서버 설정은 세션/트레이스용, 스크린샷에는 적용 안 됨

## 공모전 프로젝트: 예금보험공사 30주년

- **경로**: `C:\Users\user\Desktop\공모전\0327_예금보험공사 창립 30주년 기념 대국민 공모전_멀티모달\`
- **핵심 파일**: `prototype-ai-advisor.html` — AI 예금보호 상담 에이전트 프로토타입
- **컨셉**: "내 예금, 안전한가요?" — 에이전틱 AI가 금융 자산의 예금보험 보호 여부를 다단계 분석
- **구현**: 단일 HTML (2,073줄), 외부 API 없이 룰 기반 시뮬레이션
- **주요 기능**:
  - 랜딩 Hero + 3개 프리셋 시나리오 (직장인/MZ투자자/은퇴자)
  - 채팅 + 대시보드 Split Layout
  - 5단계 에이전틱 분석 시뮬레이션 (도구 호출 시각화)
  - 30개+ 금융기관 DB, 동일기관 1억원 한도 합산 로직
  - 도넛 차트, 바 차트, 자산 카드, 맞춤 제언 자동 생성
- **디자인**: Trust-Tech 다크 모드 (#0f1729), Plus Jakarta Sans + Pretendard + JetBrains Mono
- **검증**: Playwright 5개 테스트 전부 통과 (2026-03-01)
- **같은 폴더 기존 파일**: proposal-a/b/c 시리즈 HTML (제안서들)

## CUE Enhancer 프로젝트

- **경로**: `C:\Users\user\projects\2026_active\cue_enhancer\`
- **GitHub**: `yonghwan1106/cue_enhancer`
- **VPS**: 158.247.210.200 `/opt/cue_enhancer/` (venv, .env, DISPLAY=:99)
- **개요**: Claude Computer Use API 증강 미들웨어 (grounding, verification, memory, safety)
- **테스트**: `python -m pytest tests/ -q` → 169 tests
- **상세**: [cue-enhancer.md](cue-enhancer.md) 참조

## HTML to PDF Conversion (Playwright)
See [html-to-pdf.md](html-to-pdf.md) for detailed notes.

Key takeaways:
- `@page { margin }` in CSS reduces printable area — if cover/content height exceeds it, blank pages appear
- `clip-path` + `overflow: hidden` on elements cause Chromium PDF page-break miscalculation
- `page-break-inside: avoid` on large elements pushes them to next page, leaving blank space
- Always use `@page { margin: 0 }` and let content elements handle their own padding
- Use Playwright `page.pdf({ margin: '0mm' })` with `printBackground: true`

