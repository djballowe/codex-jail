FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bubblewrap \
        ca-certificates \
        curl \
        git \
        gh \
        openssh-client \
        ripgrep \
        wget \
        gnupg \
        vim \
        zsh \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://chatgpt.com/codex/install.sh | sh
RUN git config --system --add safe.directory '*'
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /workspace
COPY on-start.sh /usr/local/bin/on-start.sh
RUN chmod +x /usr/local/bin/on-start.sh

ENTRYPOINT ["/usr/local/bin/on-start.sh"]
CMD ["bash"]
