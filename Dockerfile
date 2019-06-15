FROM golang:1.12.6-alpine3.9 AS builder

ENV GO111MODULE on
ENV GOPROXY https://goproxy.io

RUN apk upgrade \
    && apk add git \
    && go get github.com/shadowsocks/go-shadowsocks2

FROM alpine:3.9 AS dist

LABEL maintainer="lianshufeng <251708339@qq.com>"

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}


COPY --from=builder /go/bin/go-shadowsocks2 /usr/bin/shadowsocks
COPY entrypoint.sh /entrypoint.sh

RUN apk upgrade --update \
    && apk add tzdata \
	&& chmod -R 777 /usr/bin/shadowsocks \
	&& chmod -R 777 /entrypoint.sh \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /var/cache/apk/*



ENTRYPOINT ["/entrypoint.sh"]
