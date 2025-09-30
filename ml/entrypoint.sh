#!/bin/bash
# entrypoint.sh (수정)
set -euo pipefail

: "${REPO_URL:?REPO_URL required}"
RUNNER_DIR=/actions-runner
RUNNER_WORK="${RUNNER_DIR}/_work"
RUNNER_NAME="${RUNNER_NAME:-xgenml-runner-$(hostname)}"

cd "${RUNNER_DIR}"

# GitHub Actions Runner 설정
if [ ! -f .runner ]; then
  : "${ACCESS_TOKEN:?ACCESS_TOKEN registration token required (one-time)}"
  /actions-runner/config.sh --url "${REPO_URL}" \
              --token "${ACCESS_TOKEN}" \
              --name "${RUNNER_NAME}" \
              --work "${RUNNER_WORK}" \
              --unattended --replace
fi

# Runner 백그라운드 실행
/actions-runner/run.sh &

# ⭐ 초기 코드 clone (최초 실행 시에만)
cd /xgenml
if [ ! -d ".git" ]; then
  echo "Cloning repository for the first time..."
  git clone https://github.com/X2bee/XgenML.git /tmp/xgenml-temp
  mv /tmp/xgenml-temp/.git /xgenml/
  mv /tmp/xgenml-temp/* /xgenml/ 2>/dev/null || true
  rm -rf /tmp/xgenml-temp
  
  # 초기 의존성 설치
  pip install --upgrade pip
  pip install --no-cache-dir -e .
fi

# PM2로 애플리케이션 시작
pm2 start "uvicorn src.xgenml.api:app --host 0.0.0.0 --port 8001 --workers 2" --name "xgenml" --no-daemon
