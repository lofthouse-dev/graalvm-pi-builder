FROM --platform=linux/arm64 debian:bookworm

ARG GRAALVM_VERSION=25.0.2
ARG JBANG_VERSION=0.125.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates unzip \
    gcc libc-dev zlib1g-dev \
    libi2c-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q \
  "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${GRAALVM_VERSION}/graalvm-community-jdk-${GRAALVM_VERSION}_linux-aarch64_bin.tar.gz" \
  -O /tmp/graalvm.tar.gz \
  && mkdir -p /opt/graalvm \
  && tar -xzf /tmp/graalvm.tar.gz -C /opt/graalvm --strip-components=1 \
  && rm /tmp/graalvm.tar.gz

ENV JAVA_HOME=/opt/graalvm
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN wget -q \
  "https://github.com/jbangdev/jbang/releases/download/v${JBANG_VERSION}/jbang-${JBANG_VERSION}.zip" \
  -O /tmp/jbang.zip \
  && unzip -q /tmp/jbang.zip -d /tmp/jbang-extract \
  && mv /tmp/jbang-extract/jbang-${JBANG_VERSION} /opt/jbang \
  && rm -rf /tmp/jbang.zip /tmp/jbang-extract

ENV PATH="/opt/jbang/bin:$PATH"

WORKDIR /build
