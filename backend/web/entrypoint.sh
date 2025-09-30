#!/bin/bash
set -euo pipefail

: "${REPO_URL:?REPO_URL required}"
RUNNER_DIR=/actions-runner
RUNNER_WORK="${RUNNER_DIR}/_work"
RUNNER_NAME="${RUNNER_NAME:-backend-runner-$(hostname)}"

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

cd "/polarag_backend"

pm2 start "uv run python main.py " --name "backend" --no-daemon