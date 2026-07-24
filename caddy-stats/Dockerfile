FROM oven/bun:1 AS source

ARG REPO_URL=https://github.com/Lukino2000/caddy-stats.git
ARG REPO_REF=146f842959ee95043ff16f838de076e0531eafca

WORKDIR /src

RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN git clone "${REPO_URL}" /src/repo \
  && cd /src/repo \
  && git checkout --detach "${REPO_REF}" \
  && test "$(git rev-parse HEAD)" = "${REPO_REF}"


FROM oven/bun:1 AS ui-build
WORKDIR /app/receiver_ui

COPY --from=source /src/repo/receiver_ui/package.json ./
RUN bun install

COPY --from=source /src/repo/receiver_ui/ ./
RUN bun run build


FROM oven/bun:1 AS app
WORKDIR /app

COPY --from=source /src/repo/package.json /src/repo/bun.lock ./
RUN bun install --frozen-lockfile

COPY --from=source /src/repo/receiver/ ./receiver/
COPY --from=ui-build /app/ui ./receiver_ui/dist
COPY --from=source /src/repo/.env.example ./

RUN mkdir -p /data /config
COPY --from=source /src/repo/receiver/config.json /config/config.json

ENV CS_USEPG=0
ENV CS_DATAFOLDER=/data
ENV CS_CONFIGFOLDER=/config

VOLUME ["/data", "/config"]

EXPOSE 5000
EXPOSE 37000

CMD ["bun", "receiver/src/main.ts"]