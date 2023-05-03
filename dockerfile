FROM --platform=linux/arm64/v8 alpine:latest

RUN apk update && \
    apk add --no-cache git curl jq nodejs npm

# Create symbolic link to node binary in /usr/local/bin
RUN ln -s /usr/bin/nodejs /usr/local/bin/node

RUN apk add --no-cache docker

RUN mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-arm64-2.304.0.tar.gz && \
    tar xzf ./actions-runner-linux-arm64-2.304.0.tar.gz && \
    chown -R root:root /actions-runner && \
    adduser -D -h /actions-runner -s /bin/bash actions && \
    chown -R actions:actions /actions-runner

USER actions
WORKDIR /actions-runner

ENTRYPOINT ["/bin/sh", "/actions-runner/bin/runsvc.sh"]
