FROM alpine:3.8

COPY . /app
WORKDIR /app

RUN apk update \
    && apk add --update --no-cache --force-overwrite \
        crystal shards openssl openssl-dev \
        libc-dev llvm llvm-dev llvm-libs \
    && shards build --release --production \
    && rm -rf /var/cache/apk

ENV LISTEN_ADDRESS=0.0.0.0
ENV LISTEN_PORT=5673
ENV AMQP_URL=amqp://127.0.0.1:5672

CMD [ "sh", "-c", "bin/amqproxy -l $LISTEN_ADDRESS -p $LISTEN_PORT $AMQP_URL" ]
