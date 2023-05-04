FROM --platform=linux/arm64/v8 arm64v8/ubuntu:latest

RUN apt-get update && \
    apt-get install -y git curl jq nodejs npm

# Create symbolic link to node binary in /usr/local/bin
# RUN ln -s /usr/bin/node /actions-runner/externals/node16/bin/node

RUN apt-get install -y docker.io

RUN mkdir actions-runner && cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-arm64-2.304.0.tar.gz && \
    tar xzf ./actions-runner-linux-arm64-2.304.0.tar.gz && \
    chown -R root:root /actions-runner && \
    adduser --disabled-password --gecos '' actions && \
    chown -R actions:actions /actions-runner

USER actions
WORKDIR /actions-runner

# Set environment variables for runner configuration
# ENV RUNNER_NAME=my-runner \
#    RUNNER_ORGANIZATION_URL= \
#    RUNNER_TOKEN= \
#    RUNNER_LABELS=label1,label2
    
# Token and URL from link: https://github.com/organizations/your-org/settings/actions/runners/new. Go Below
RUN ./config.sh --url ORG --token TOKEN

# Run the config script with environment variables
# RUN env && \
#     ./config.sh --unattended --name $RUNNER_NAME --url $RUNNER_ORGANIZATION_URL --token $RUNNER_TOKEN --labels $RUNNER_LABELS

ENTRYPOINT ["/bin/sh", "/actions-runner/bin/runsvc.sh"]
