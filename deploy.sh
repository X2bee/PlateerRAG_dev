#!/bin/bash

PROFILE=$1

case $PROFILE in
    all)
        echo "✅ 프로필: all (backend + front)"
        COMPOSE_FILES="-f docker-compose.yml -f docker-compose-front.yaml"
        ;;
    backend)
        echo "✅ 프로필: backend"
        COMPOSE_FILES="-f docker-compose.yml"
        ;;
    frontend)
        echo "✅ 프로필: frontend"
        COMPOSE_FILES="-f docker-compose-front.yaml"
        ;;
    *)
        echo "🚨 오류: 유효한 프로필을 먼저 선택해주세요."
        echo ""
        echo "사용법: $0 [all|backend|frontend] [명령어] [옵션]"
        echo "  예시) $0 all start"
        echo "        $0 backend stop"
        echo "        $0 frontend logs my-app"
        exit 1
        ;;
esac

COMMAND=$2

if [ -z "$COMMAND" ]; then
    echo "🚨 오류: 실행할 명령어를 입력하세요."
    echo "사용법: $0 $PROFILE [start|stop|restart|logs|...]"
    exit 1
fi

case $COMMAND in
    start)
        echo "🚀 Docker Compose를 시작합니다..."
        docker compose $COMPOSE_FILES up -d
        ;;
    stop)
        echo "🛑 Docker Compose를 종료합니다..."
        docker compose $COMPOSE_FILES down
        ;;
    restart)
        echo "🔄 Docker Compose를 재시작합니다..."
        docker compose $COMPOSE_FILES down -v
        docker compose $COMPOSE_FILES up -d
        ;;
    logs)
        # ✅ 서비스 이름은 세 번째 인자로 받습니다.
        SERVICE_NAME=$3
        if [ -z "$SERVICE_NAME" ]; then
            echo "📜 모든 서비스의 로그를 확인합니다 (Ctrl+C로 종료)..."
            docker logs -f
        else
            echo "📜 '$SERVICE_NAME' 서비스의 로그를 확인합니다 (Ctrl+C로 종료)..."
            docker logs -f "$SERVICE_NAME"
        fi
        exit 0
        ;;
    build)
        echo "🏗️ 이미지를 다시 빌드하며 Docker Compose를 시작합니다..."
        docker compose $COMPOSE_FILES up --build -d
        ;;
    down-v)
        echo "🧹 볼륨(데이터)까지 모두 삭제하며 Docker Compose를 종료합니다..."
        docker compose $COMPOSE_FILES down -v
        ;;
    *)
        echo "🚨 알 수 없는 명령어입니다: $COMMAND"
        echo "사용법: $0 $PROFILE [start|stop|restart|logs [서비스이름]|...]"
        exit 1
        ;;
esac

echo "✅ 작업이 완료되었습니다."