#!/bin/bash
set -e

cd /vllm/vllm_api
# requirements.txt 설치 (가상환경 내)
echo "필수 패키지를 설치합니다..."
pip install -r requirements.txt

# VLLM_MODEL_NAME 환경변수가 설정되어 있고 비어있지 않은 경우 자동 모델 서빙을 활성화
if [ -n "$VLLM_MODEL_NAME" ] && [ "$VLLM_MODEL_NAME" != "" ]; then
    echo "VLLM_MODEL_NAME이 설정되어 있습니다: $VLLM_MODEL_NAME"
    echo "자동 모델 서빙 모드로 실행합니다..."
    export AUTO_SERVE_MODEL=true
else
    echo "VLLM_MODEL_NAME이 설정되지 않았습니다. 수동 서빙 모드로 실행합니다..."
    export AUTO_SERVE_MODEL=false
fi

python3 main.py
