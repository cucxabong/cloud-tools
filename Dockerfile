FROM alpine:3.15.0

WORKDIR /
RUN apk add --update --no-cache curl \
        jq \
        gettext \
        bash \
        git \
        py3-crcmod \
        py3-openssl \
        libc6-compat \
        openssh-client \
        gnupg \
        ca-certificates

ARG BUILDKIT_VERSION=0.9.3
ARG HELM_VERSION=3.7.2
ARG KUBECTL_VERSION=1.21.6
ARG CLOUD_SDK_VERSION=367.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /google-cloud-sdk/bin:$PATH

# Install kubectl
RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install helm
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN curl -sL ${BASE_URL}/${TAR_FILE} | tar -xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

# Install buildctl
RUN curl -LO https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz \
    && tar -C /tmp/ -xf buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz \
    && cp /tmp/bin/buildctl /usr/local/bin/ \
    && rm -rf /tmp/bin buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz

# gcloud SDK
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

# nodejs & npm
RUN apk add --update --no-cache npm

