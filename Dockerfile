FROM alpine:3 as downloader

ARG PB_VERSION=0.22.15

# _linux_amd64 as this is what CasaOS uses
# RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip
RUN curl -L \
    -o pocketbase_${PB_VERSION}_linux_amd64.zip \
    https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip
RUN unzip pocketbase_${VERSION}_linux_amd64.zip 
RUN chmod +x /pocketbase

FROM alpine:3
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN apk add --no-cache bash

RUN adduser -D pocketbase
USER pocketbase

RUN mkdir -p /pb_data /pb_public /pb_hooks
VOLUME /pb_data

EXPOSE 8090

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb_data", "--publicDir=/pb_public", "--hooksDir=/pb_hooks"]
