#!/bin/bash
set -euo pipefail

cd /home/plateerag
echo NEXT_PUBLIC_BACKEND_HOST=$NEXT_PUBLIC_BACKEND_HOST > ./.env

npm run build
npm run build:embed
npm run start