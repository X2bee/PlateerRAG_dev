FROM python:3.12.11

ARG RUNNER_VERSION="2.326.0"
ARG TARGETARCH=x64

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y curl tar git poppler-utils \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2 \
    && pip install uv \
    && apt-get install -y libreoffice-writer libreoffice-calc --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN useradd -m runner

RUN mkdir -p /polarag_backend /actions-runner && \
    chown -R runner:runner /polarag_backend /actions-runner

USER runner

ENV PATH="/home/runner/.local/bin:${PATH}"

RUN cd /actions-runner && \
    curl -o runner.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${TARGETARCH}-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./runner.tar.gz && rm runner.tar.gz

WORKDIR /polarag_backend

RUN git clone -b deploy https://github.com/X2bee/PlateeRAG_backend ./
RUN uv sync

COPY --chown=runner:runner ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

CMD ["/polarag_backend/entrypoint.sh"]