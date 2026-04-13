FROM caddy:builder AS builder

RUN xcaddy build \
	--with github.com/caddyserver/transform-encoder \
	--with github.com/Lukino2000/caddy-dns-gidinet@v0.0.13 \
	--with github.com/Lukino2000/caddy-check-and-redirect@v0.0.1 \
	--with github.com/oltdaniel/caddy-ipinfo-free

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
