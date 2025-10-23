FROM node:21.2.0

ARG RUNNER_VERSION="2.326.0"
ARG TARGETARCH=x64

RUN apt-get update && apt-get install -y curl tar git && npm install -g pm2

RUN useradd -m runner

RUN chown -R runner:runner /home/plateerag

USER runner

WORKDIR /home/plateerag

RUN git clone -b deploy https://github.com/X2bee/PlateeRAG ./
RUN npm install

COPY --chown=runner:runner ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/home/plateerag/entrypoint.sh"]