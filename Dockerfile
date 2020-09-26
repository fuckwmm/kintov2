FROM alpine:3.5
ENV CONFIG_JSON={"inbounds":[{"port":8080,"protocol":"vmess","settings":{"clients":[{"id":"822ebcae-8817-4db3-88d9-8612c3037f3f","alterId":4}]},"streamSettings":{"network":"ws","wsSettings":{"path":"/RtjgZcXZrQmbBUkO"}}}],"outbounds":[{"protocol":"freedom","settings":{}}]}
RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip \
 && mkdir /usr/bin/v2ray /etc/v2ray \
 && touch /etc/v2ray/config.json \
 && unzip /v2ray.zip -d /usr/bin/v2ray \
 && rm -rf /v2ray.zip /usr/bin/v2ray/*.sig /usr/bin/v2ray/doc /usr/bin/v2ray/*.json /usr/bin/v2ray/*.dat /usr/bin/v2ray/sys* \
 && chgrp -R 0 /etc/v2ray \
 && chmod -R g+rwX /etc/v2ray
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
ENTRYPOINT /configure.sh
EXPOSE 80
