# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

FROM opensuse/tumbleweed

RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
 && zypper addrepo \
    --check --refresh --gpgcheck-strict \
        'https://packages.microsoft.com/sles/15/prod/' packages-microsoft-com-prod \
 && zypper --non-interactive --quiet update \
    --auto-agree-with-licenses --no-recommends \
 && zypper --non-interactive --quiet install \
    --auto-agree-with-licenses --no-recommends \
        b3sum \
        curl \
        dotnet-sdk-8.0 \
        dust \
        fd \
        git \
        ripgrep \
        tree \
        vim \
 && zypper clean \
 && rm -rf /var/cache/zypp/*

# Install .NET tools
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN dotnet tool install --global paket \
 && dotnet tool install --global fantomas

# Install Pulumi
# Similar to `curl -fsSL https://get.pulumi.com | sh` but with checksum verification
ARG PULUMI_VERSION="3.127.0"
ARG PULUMI_B3="a2d21c394bb03ea44909d2c36a923ce0573baf780d2e8aa790d2f2cbdcdc56c5"
ARG PULUMI_TARBALL="pulumi-v${PULUMI_VERSION}-linux-x64.tar.gz"
ARG PULUMI_URL="https://github.com/pulumi/pulumi/releases/download/v${PULUMI_VERSION}/${PULUMI_TARBALL}"
RUN curl -L -O ${PULUMI_URL} \
 && echo "${PULUMI_B3}  ${PULUMI_TARBALL}" | b3sum -c - \
 && mkdir -p /root/.pulumi/bin \
 && tar -xpzf ${PULUMI_TARBALL} --directory=/root/.pulumi/bin --strip-components=1 \
 && rm -f ${PULUMI_TARBALL}

ENV PATH=/root/.pulumi/bin:/root/.dotnet/tools:$PATH
