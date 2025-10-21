## Docker 개발 환경 설정

### 사전 요구사항

- Docker Desktop 설치 ([다운로드](https://www.docker.com/products/docker-desktop))
- Docker Compose 설치 (Docker Desktop에 포함)

### 초기 설정

#### 1. 환경 변수 파일 생성

`.env.template` 파일을 복사하여 `.env` 파일을 생성하세요:

```bash
cp .env.template .env
```

`.env` 파일을 열어 실제 값으로 수정하세요:

```bash
# 기본값 (개발 환경)
MYSQL_ROOT_PASSWORD=1111
MYSQL_DATABASE=oneday_db
MYSQL_USER=root
MYSQL_PASSWORD=1111
```

**중요**: `.env` 파일은 Git에 커밋되지 않습니다. 팀원들은 각자 `.env` 파일을 생성해야 합니다.

#### 2. Docker Compose 시작

```bash
# 컨테이너 시작 (백그라운드)
docker-compose up -d

# 로그 확인 (초기화 진행 상황)
docker-compose logs -f mysql
```

초기화가 완료되면 `Ctrl + C`로 로그 모니터링을 종료하세요.

#### 3. 데이터베이스 연결 확인

```bash
# MySQL 컨테이너 접속
docker exec -it oneday_mysql mysql -uroot -p1111

# 데이터베이스 확인
mysql> USE oneday_db;
mysql> SHOW TABLES;
mysql> exit;
```

#### 4. 헬스체크 확인

```bash
docker-compose ps
```

`healthy` 상태가 표시되면 애플리케이션을 시작할 수 있습니다.

### 일반 사용법

#### 컨테이너 시작

```bash
docker-compose up -d
```

#### 컨테이너 중지

```bash
docker-compose stop
```

#### 컨테이너 삭제

```bash
docker-compose down
```

#### 데이터 완전 초기화

```bash
# 컨테이너 및 볼륨 삭제
docker-compose down -v

# 다시 시작
docker-compose up -d
```

**주의**: 이 명령은 모든 데이터를 삭제합니다!

### 트러블슈팅

#### 1. 포트 충돌 (Port 3306 already in use)

로컬에 MySQL이 이미 실행 중인 경우, `.env` 파일에서 포트를 변경하세요:

```bash
DB_PORT=13306
```

#### 2. 초기화 스크립트가 실행되지 않는 경우

```bash
# 볼륨 완전 삭제 후 재시작
docker-compose down -v
docker-compose up -d
```

#### 3. 환경 변수를 인식하지 못하는 경우

```bash
# .env 파일 존재 확인
ls -la .env

# .env 파일 내용 확인
cat .env

# Docker Compose 재시작
docker-compose down
docker-compose up -d
```

### 애플리케이션 연동

기존 `DatabaseConfig.getInstance().getConnection()` 코드는 변경 없이 그대로 사용 가능합니다:

```java
// 기존 코드 그대로 동작
try(Connection conn = DatabaseConfig.getInstance().getConnection()){
	// SQL 실행
	}
```

### 데이터베이스 설정 정보

| 항목        | 값                  | 출처                 |
|-----------|--------------------|--------------------|
| 데이터베이스명   | oneday_db          | .env               |
| 포트        | 3306               | .env               |
| 사용자명      | root               | .env               |
| 비밀번호      | 1111               | .env               |
| 문자 인코딩    | utf8mb4            | docker-compose.yml |
| Collation | utf8mb4_unicode_ci | docker-compose.yml |
| 타임존       | Asia/Seoul         | .env               |

### 추가 명령어

#### 데이터베이스 백업

```bash
docker exec oneday_mysql mysqladump -uroot -p1111 oneday_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

#### 백업 복원

```bash
docker exec -i oneday_mysql mysql -uroot -p1111 oneday_db < backup.sql
```

#### 컨테이너 내부 접속

```bash
docker exec -it oneday_mysql bash
```

### 파일 체크리스트

프로젝트를 시작하기 전에 다음 파일들이 있는지 확인하세요:

- [x] `docker-compose.yml` - Docker Compose 설정
- [x] `.env` - 환경 변수 (Git에 포함되지 않음)
- [x] `.env.template` - 환경 변수 템플릿 (Git에 커밋)
- [x] `tableV2.sql` - 초기화 스크립트
- [x] `.gitignore` - `.env` 파일 제외 설정

### 참고사항

- `.env` 파일은 **절대 Git에 커밋하지 마세요**
- 팀원들은 `.env.template`을 복사하여 각자 `.env` 파일을 생성합니다
- `tableV2.sql` 파일은 **최초 컨테이너 생성 시에만** 실행됩니다
- 개발 중 데이터를 유지하려면 `docker-compose down` 대신 `docker-compose stop`을 사용하세요
