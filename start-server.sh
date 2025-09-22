#!/bin/bash
echo "🚀 Tomcat 개발 서버를 시작합니다..."
echo "=================================="

# OS 환경 확인
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "💻 Windows 환경에서 실행 중..."
else
    echo "💻 Unix 계열 환경에서 실행 중..."
fi

# Docker 실행 여부 확인
if ! docker --version > /dev/null 2>&1; then
    echo "❌ Docker가 설치되어 있지 않거나 실행되지 않았습니다."
    echo "   Docker Desktop을 설치하고 실행해주세요."
    exit 1
fi

# Docker Compose로 서비스 시작
echo "🐳 Docker Compose 서비스 시작 중..."
docker-compose up -d

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 서버가 성공적으로 시작되었습니다!"
    echo "🌐 접속 URL: http://localhost:8080"
    echo "📁 WAR 배포: webapps/ 폴더에 파일 복사"
    echo "📋 로그 확인: docker-compose logs -f tomcat"
    echo "⏹️  서버 중지: docker-compose down"
    echo ""
    echo "서버 상태 확인 중..."
    sleep 3
    docker-compose ps
else
    echo "❌ 서버 시작에 실패했습니다."
    echo "   Docker Desktop이 실행 중인지 확인해주세요."
    exit 1
fi