# Dockerfile (수정)
FROM python:3.12.11

ARG RUNNER_VERSION="2.326.0"
ARG TARGETARCH=x64

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y curl tar git ca-certificates tini \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m runner

RUN mkdir -p /xgenml /actions-runner && \
    chown -R runner:runner /xgenml /actions-runner

USER runner

ENV PATH="/home/runner/.local/bin:${PATH}"

RUN cd /actions-runner && \
    curl -o runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./runner.tar.gz && rm runner.tar.gz

USER root
RUN cd /actions-runner && ./bin/installdependencies.sh

USER runner

WORKDIR /xgenml

# ⭐ 이 부분 수정: 빌드 시점이 아닌 런타임에 clone
# RUN git clone https://github.com/X2bee/XgenML.git ./  # 삭제
# RUN pip install --upgrade pip && pip install --no-cache-dir .  # 삭제

# 대신 entrypoint.sh에서 초기 설정 시 한 번만 clone

ENV ARTIFACT_BASE_URI="file:///tmp/artifacts" \
    MLFLOW_TRACKING_URI="" \
    S3_ENDPOINT_URL="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_DEFAULT_REGION="ap-northeast-2" \
    PORT=8001

COPY --chown=runner:runner ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fsS "http://127.0.0.1:${PORT}/openapi.json" || exit 1

EXPOSE 8001

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/xgenml/entrypoint.sh"]
