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

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV PATH=/root/.dotnet/tools:$PATH
RUN dotnet tool install --global paket \
 && dotnet tool install --global fantomas
