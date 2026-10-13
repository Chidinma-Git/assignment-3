FROM alpine:3.20

RUN apk add --no-cache \
    bash \
    iproute2 \
    busybox-extras \
    bind-tools

WORKDIR /app

COPY app/ /app/

RUN chmod +x /app/*.sh

ENTRYPOINT ["/app/app.sh"]
