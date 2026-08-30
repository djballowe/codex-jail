FROM debian:bookworm-slim

ARG USERNAME=agent
ARG USER_UID=1000
ARG USER_GID=1000
ARG GO_VERSION=1.25.6
ARG GO_SHA256_AMD64=f022b6aad78e362bcba9b0b94d09ad58c5a70c6ba3b7582905fababf5fe0181a
ARG GO_SHA256_ARM64=738ef87d79c34272424ccdf83302b7b0300b8b096ed443896089306117943dd5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bubblewrap \
        ca-certificates \
        curl \
        dnsutils \
        file \
        git \
        gh \
        iproute2 \
        jq \
        less \
        nodejs \
        openssh-client \
        procps \
        python3 \
        ripgrep \
        shellcheck \
        shfmt \
        strace \
        unzip \
        wget \
        gnupg \
        vim \
        zsh \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg \
        -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && . /etc/os-release \
    && printf '%s\n' \
        'Types: deb' \
        'URIs: https://download.docker.com/linux/debian' \
        "Suites: ${VERSION_CODENAME}" \
        'Components: stable' \
        "Architectures: $(dpkg --print-architecture)" \
        'Signed-By: /etc/apt/keyrings/docker.asc' \
        > /etc/apt/sources.list.d/docker.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce-cli \
        docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

RUN arch="$(dpkg --print-architecture)" \
    && case "$arch" in \
        amd64) go_sha256="$GO_SHA256_AMD64" ;; \
        arm64) go_sha256="$GO_SHA256_ARM64" ;; \
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac \
    && go_archive="/tmp/go${GO_VERSION}.linux-${arch}.tar.gz" \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${arch}.tar.gz" \
        -o "$go_archive" \
    && echo "$go_sha256  $go_archive" | sha256sum -c - \
    && tar -C /usr/local -xzf "$go_archive" \
    && rm "$go_archive"

RUN git config --system --add safe.directory '*'
RUN groupadd --gid "$USER_GID" "$USERNAME" \
    && useradd \
        --uid "$USER_UID" \
        --gid "$USER_GID" \
        --create-home \
        --shell /bin/bash \
        "$USERNAME" \
    && install -d -m 0755 -o "$USERNAME" -g "$USERNAME" \
        "/home/$USERNAME/projects" \
        "/home/$USERNAME/.codex" \
        "/home/$USERNAME/.config/gh"

ENV HOME="/home/${USERNAME}"
ENV PATH="/usr/local/go/bin:${HOME}/.local/bin:${PATH}"

COPY on-start.sh /usr/local/bin/on-start.sh
RUN chmod +x /usr/local/bin/on-start.sh

USER ${USERNAME}:${USERNAME}
RUN curl -fsSL https://chatgpt.com/codex/install.sh | sh

WORKDIR /home/${USERNAME}/projects

ENTRYPOINT ["/usr/local/bin/on-start.sh"]
CMD ["bash"]
