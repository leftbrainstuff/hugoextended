ARG BASE_IMAGE=amazonlinux
FROM $BASE_IMAGE

ARG DOCKER_HUGO_VERSION="0.82.0"
ENV DOCKER_HUGO_NAME="hugo_extended_${DOCKER_HUGO_VERSION}_Linux-64bit"
ENV DOCKER_HUGO_BASE_URL="https://github.com/gohugoio/hugo/releases/download"
ENV DOCKER_HUGO_URL="${DOCKER_HUGO_BASE_URL}/v${DOCKER_HUGO_VERSION}/${DOCKER_HUGO_NAME}.tar.gz"
ENV DOCKER_HUGO_CHECKSUM_URL="${DOCKER_HUGO_BASE_URL}/v${DOCKER_HUGO_VERSION}/hugo_${DOCKER_HUGO_VERSION}_checksums.txt"
ARG INSTALL_NODE="false"

WORKDIR /build
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
RUN yum install -y .build-deps wget && \
    yum install -y \
    git \
    bash \
    make \
    curl \
    openssh \
    tar \
    ca-certificates \
    libc6-compat \
    libstdc++ && \
    wget --quiet "${DOCKER_HUGO_URL}" && \
    wget --quiet "${DOCKER_HUGO_CHECKSUM_URL}" && \
    grep "${DOCKER_HUGO_NAME}.tar.gz" "./hugo_${DOCKER_HUGO_VERSION}_checksums.txt" | sha256sum -c - && \
    tar -zxvf "${DOCKER_HUGO_NAME}.tar.gz" && \
    mv ./hugo /usr/bin/hugo && \
    hugo version && \

    rm -rf /build

WORKDIR /src
ENTRYPOINT [ "/usr/bin/hugo" ]
