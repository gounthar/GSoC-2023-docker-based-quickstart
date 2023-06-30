FROM debian:bookworm

COPY *sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*.sh

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    nano \
    openssh-client \
    procps \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*