#!/bin/bash

set -a
source ./.env
set +a

cd /home/plateerag

if ! command -v git &> /dev/null; then
  echo "Git이 설치되어 있지 않습니다. 설치를 시작합니다..."
  apt-get update && apt-get install -y git
fi

REPO_URL="https://github.com/X2bee/PlateeRAG.git"

if [ ! -d "/home/plateerag/src" ]; then
  echo "/home/plateerag/src 디렉터리가 없으므로 클론합니다..."
  git clone "${REPO_URL}" .
else
  if [ -d "/home/plateerag/.git" ]; then
    echo "/home/plateerag 디렉터리가 Git 저장소입니다. pull을 시도합니다..."
    cd /home/plateerag
    git remote set-url origin "${REPO_URL}"
    git pull
    cd ..
  else
    echo "/home/plateerag 디렉터리는 존재하지만 Git 저장소가 아닙니다. 삭제 후 클론합니다..."
    rm -rf /home/plateerag
    git clone "${REPO_URL}" /home/plateerag
  fi
fi

cd /home/plateerag
set -e

echo NEXT_PUBLIC_BACKEND_HOST=$NEXT_PUBLIC_BACKEND_HOST > ./.env
echo NEXT_PUBLIC_BACKEND_PORT=$NEXT_PUBLIC_BACKEND_PORT > ./.env

echo "📥 Installing dependencies..."
npm install

echo "✅ Setup complete"
echo "🚀 Starting the app..."
npm run build:embed
npm run build
npm start