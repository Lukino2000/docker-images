FROM oven/bun:1 AS source

ARG REPO_URL=https://github.com/Lukino2000/yazio-web-viewer.git
ARG REPO_REF

WORKDIR /src

RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN git clone "${REPO_URL}" /src/repo \
  && test -n "${REPO_REF}" \
  && cd /src/repo \
  && git checkout --detach "${REPO_REF}" \
  && test "$(git rev-parse HEAD)" = "${REPO_REF}"


FROM oven/bun:1 AS build
WORKDIR /app

COPY --from=source /src/repo/package.json /src/repo/bun.lock ./
RUN bun install --frozen-lockfile

COPY --from=source /src/repo/ ./

ENV NITRO_PRESET=bun

# SYNC_CRON is consumed by Nitro at build time.
ARG SYNC_CRON="0 * * * *"
ENV SYNC_CRON=${SYNC_CRON}

RUN bun run build


FROM oven/bun:1 AS runtime
WORKDIR /app

COPY --from=build /app/.output ./.output

ENV NODE_ENV=production
ENV PORT=3000
ENV DB_PATH=/data/yazio.db

VOLUME ["/data"]

EXPOSE 3000

CMD ["bun", ".output/server/index.mjs"]
