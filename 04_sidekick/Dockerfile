FROM debian:bookworm as prepare-stage

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

RUN /usr/local/bin/keygen.sh /ssh-dir

# Install Git and gh
RUN apt-get update && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && apt install gh -y && \
    rm -rf /var/lib/apt/lists/*

RUN gh auth login && \
    gh auth status | grep -oP 'Logged in to github\.com as \K\S+' | cut -d '/' -f 1 > /ssh-dir/gh-auth-status.txt

CMD ["sh", "-c", "echo 'Export stage is ready'; ls -l /ssh-dir/"]
