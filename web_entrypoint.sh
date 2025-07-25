#!/bin/bash

if ! command -v git &> /dev/null; then
  echo "Git이 설치되어 있지 않습니다. 설치를 시작합니다..."
  apt-get update && apt-get install -y git
fi

REPO_URL="https://github.com/X2bee/PlateeRAG_backend"

if [ ! -d "/home/plateerag/" ]; then
  echo "/home/plateerag/ 디렉터리가 없으므로 클론합니다..."
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

set -e

cd /home/plateerag
echo "필수 패키지를 설치합니다..."
pip install -r requirements.txt

python3 main.py 
