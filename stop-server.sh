#!/bin/bash
echo "⏹️  Tomcat 개발 서버를 중지합니다..."
echo "===================================="

# Docker Compose 서비스 중지
docker-compose down

echo ""
echo "✅ 서버가 성공적으로 중지되었습니다!"
echo "🗑️  완전 삭제 (볼륨 포함): docker-compose down -v"