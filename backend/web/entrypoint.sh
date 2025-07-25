#!/bin/bash
set -e

/actions-runner/config.sh --url "${REPO_URL}" --token "${ACCESS_TOKEN}" --name "backend-runner-$(hostname)" --work "/actions-runner/_work" --unattended --replace

cleanup() {
    echo "Deregistering runner..."
    /actions-runner/config.sh remove --token "${ACCESS_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

/actions-runner/run.sh &

pm2 start "python3 main.py " --name "backend" --no-daemon