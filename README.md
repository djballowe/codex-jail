# codex-jail

`codex-jail` is a small Debian container for running the Codex CLI in an
isolated development environment.

It includes Codex, Git, GitHub CLI, Go, Node.js, Python, Docker CLI, Docker
Compose, and a handful of common command-line tools. Only the project and
configuration directories listed in `docker/docker-compose.yaml` are mounted
from the host. Changes made inside those mounted directories also change the
host files.

Codex and GitHub CLI configuration are kept in named Docker volumes, so their
settings and sign-in state survive after the container is removed.

## Setup

Create a `.env` file in the repository root:

```dotenv
HOST_HOME=/home/your-name
HOST_UID=1000
HOST_GID=1000
GITHUB_TOKEN=
```

`HOST_HOME` is the path to your home directory on the host. Set `HOST_UID`
and `HOST_GID` to the values reported by `id -u` and `id -g` on the host.
`GITHUB_TOKEN` is optional; when provided, the startup script configures Git
to use GitHub CLI authentication. Keep `.env` private and never commit it.

Review the host directory mounts in `docker/docker-compose.yaml` and adjust
them for the projects you want the container to access.

## Build and run

Run these commands from the repository root:

```bash
docker compose --env-file .env -f docker/docker-compose.yaml build
docker compose --env-file .env -f docker/docker-compose.yaml run --rm codex
```

The container opens Bash by default. To open another shell, pass it after the
service name:

```bash
docker compose --env-file .env -f docker/docker-compose.yaml run --rm codex zsh
```

## Docker commands inside the container

The image includes the Docker CLI and the `docker compose` plugin, but it does
not run a Docker daemon or mount the host Docker socket. Docker commands that
need a daemon will not work unless one is configured separately.

## Existing volumes

The `codex-data` and `gh-data` named volumes are mounted at
`/home/agent/.codex` and `/home/agent/.config/gh`. After changing an existing
installation from root to the `agent` user, update their ownership once:

```bash
docker compose --env-file .env -f docker/docker-compose.yaml run --rm \
  --user root --entrypoint chown codex \
  -R agent:agent /home/agent/.codex /home/agent/.config/gh
```

Verify the normal runtime identity afterward:

```bash
docker compose --env-file .env -f docker/docker-compose.yaml run --rm codex id
```
