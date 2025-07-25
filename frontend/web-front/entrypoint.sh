#!/bin/bash
set -e

/actions-runner/config.sh --url "${REPO_URL}" --token "${ACCESS_TOKEN}" --name "frontend-runner-$(hostname)" --work "/actions-runner/_work" --unattended --replace

cleanup() {
    echo "Deregistering runner..."
    /actions-runner/config.sh remove --token "${ACCESS_TOKEN}"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

/actions-runner/run.sh &

cd /home/plateerag
echo NEXT_PUBLIC_BACKEND_HOST=$NEXT_PUBLIC_BACKEND_HOST > ./.env

npm run build
npm run build:embed
pm2 start "npm run start" --name "frontend" --no-daemon