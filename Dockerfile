FROM acrisliu/shadowsocks-libev

MAINTAINER LENTIN "lentin@outlook.com"

ENV SERVER_HOST 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD shadowsocks
ENV ENCRYPT_METHOD chacha20-ietf-poly1305
ENV TIMEOUT 60
ENV DNS_ADDR 8.8.8.8
ENV PLUGIN obfs-server
ENV PLUGIN_OPTS obfs=http

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

COPY rinetd-bbr /usr/local/bin/

RUN echo "0.0.0.0 $SERVER_PORT 0.0.0.0 $SERVER_PORT" > /etc/rinetd-bbr.conf

ENTRYPOINT ss-server -s "$SERVER_HOST" \
                     -p "$SERVER_PORT" \
                     -k "$PASSWORD" \
                     -m "$ENCRYPT_METHOD" \
                     -t "$TIMEOUT" \
                     -d "$DNS_ADDR" \
                     --plugin "$PLUGIN" \
                     --plugin-opts "$PLUGIN_OPTS" \
                     -u \
                     --fast-open \
                     --reuse-port \
          && rinetd-bbr
