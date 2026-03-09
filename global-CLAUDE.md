# Claude Code Global Settings

## Project Workflow Rules

### New Project Creation
When creating a new project:

1. **Location**: 프로젝트 유형에 따라 저장 경로가 다름
   - **공모전 프로젝트**: `C:\Users\user\Desktop\공모전\{해당 공모전 폴더}\`에 저장
   - **개발 프로젝트**: `C:\Users\user\projects\{year}_active\`에 저장
     - Use current year (e.g., `2026_active`)
     - Project folder name should be kebab-case (e.g., `my-new-project`)

2. **GitHub Repository**: After project setup is complete:
   - Initialize git: `git init`
   - Create GitHub repository using `mcp__github__create_repository`
   - Repository name should match project folder name
   - Add remote and push initial commit

3. **Standard Initial Commit Message**:
   ```
   Initial commit: [Project Name]

   [Brief description of the project]

   🤖 Generated with Claude Code

   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

### GitHub Account
- Default GitHub username: `yonghwan1106`
- Create repositories as public by default (unless specified otherwise)

### Project Structure Conventions
- Use appropriate framework for the task (Next.js, Python, etc.)
- Include proper `.gitignore` file
- Korean language support when needed (UTF-8 encoding)

---

## Infrastructure & MCP Setup (2026-01-28 기록)

### Vultr VPS
- **IP**: 158.247.210.200
- **리전**: Seoul
- **플랜**: $5/월 (Cloud Compute)
- **크레딧 잔액**: $45.80 (약 7개월분)
- **대역폭**: 3.00 TB 할당, 사용량 거의 없음
- **상태**: Running
- **용도**: PocketBase 서버 호스팅

### MCP 서버 목록 (활성)
| 서버 | 용도 |
|------|------|
| **context-7** | 라이브러리 문서 조회 (Smithery) |
| **playwright** | 브라우저 자동화/테스트 |
| **vercel** | 배포/프로젝트 관리 |
| **github** | GitHub 저장소/PR/이슈 관리 |
| **pocketbase-mcp** | PocketBase DB 관리 (`@fadlee/pocketbase-mcp`, URL: `http://158.247.210.200:8090`) |
| **supabase** | Supabase DB 관리 |
| **Railway** | Railway 배포/서비스 관리 |

### 데이터베이스 선택 기준
| DB | 장점 | 사용 케이스 |
|----|------|-------------|
| **Supabase** | 클라우드 관리형, SQL 직접 실행, 실시간 구독, OAuth 내장 | 빠른 프로토타이핑, 복잡한 쿼리 필요 시 |
| **PocketBase** | 셀프호스팅(Vultr VPS), 비용 절감, 데이터 완전 소유 | 장기 운영, 데이터 통제 필요 시 |

- Supabase: **app per schema** 방식 사용 중
- PocketBase: MCP 연결 완료로 Claude가 직접 DB 설계/관리 가능 (2026-01-28~)
