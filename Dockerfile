FROM alpine:3.11

ARG AWS_CLI_VERSION=1.18.28

RUN apk --update add python py-setuptools py-pip jq less bash&& \
    pip install --no-cache-dir awscli==${AWS_CLI_VERSION} && \
    apk del py-pip && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
