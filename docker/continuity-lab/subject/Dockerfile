FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    coreutils \
    curl

COPY entrypoint.sh /vrp-lab-adapter

RUN chmod +x /vrp-lab-adapter

ENTRYPOINT ["/vrp-lab-adapter"]
