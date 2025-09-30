#!/bin/bash
set -euo pipefail

: "${REPO_URL:?REPO_URL required}"
RUNNER_DIR=/actions-runner
RUNNER_WORK="${RUNNER_DIR}/_work"
RUNNER_NAME="${RUNNER_NAME:-frontend-runner-$(hostname)}"

cd "${RUNNER_DIR}"

if [ ! -f .runner ]; then
  : "${ACCESS_TOKEN:?ACCESS_TOKEN registration token required (one-time)}"
  /actions-runner/config.sh --url "${REPO_URL}" \
              --token "${ACCESS_TOKEN}" \
              --name "${RUNNER_NAME}" \
              --work "${RUNNER_WORK}" \
              --unattended --replace
fi

/actions-runner/run.sh &

cd /home/plateerag
echo NEXT_PUBLIC_BACKEND_HOST=$NEXT_PUBLIC_BACKEND_HOST > ./.env

npm run build
npm run build:embed
pm2 start "npm run start" --name "frontend" --no-daemon