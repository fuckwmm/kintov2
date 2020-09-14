FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git bash curl
WORKDIR /go/src/v2ray.com/core
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

FROM alpine
ENV CONFIG="{"inbounds":[{"port":8080,"protocol":"vmess","settings":{"clients":[{"id":"822ebcae-8817-4db3-88d9-8612c3037f3f","alterId":4}]},"streamSettings":{"network":"ws","wsSettings":{"path":"/RtjgZcXZrQmbBUkO"}}}],"outbounds":[{"protocol":"freedom","settings":{}}]}"
COPY --from=builder /tmp/v2ray.tgz /tmp
RUN apk update && apk add --no-cache tor ca-certificates && \
    tar xvfz /tmp/v2ray.tgz -C /usr/bin && \
    rm -rf /tmp/v2ray.tgz
    
CMD nohup tor & \
    v2ray -config $CONFIG
