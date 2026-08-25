FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bubblewrap \
        ca-certificates \
        curl \
        git \
        gh \
        gnupg \
        openssh-client \
        ripgrep \
        vim \
        wget \
        zsh \
    && rm -rf /var/lib/apt/lists/*

RUN git config --system --add safe.directory '*' \
    && git config --system url."https://github.com/".insteadOf "git@github.com:"

RUN curl -fsSL https://chatgpt.com/codex/install.sh | sh

ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /workspace

COPY on-start.sh /usr/local/bin/on-start.sh
RUN chmod +x /usr/local/bin/on-start.sh

ENTRYPOINT ["/usr/local/bin/on-start.sh"]

CMD ["bash"]
