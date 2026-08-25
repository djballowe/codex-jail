# Repository Guide

## Purpose

This repository defines a small Debian-based container for running the Codex CLI in an isolated development environment. Keep changes focused on the container image, its startup behavior, and the Compose configuration used to expose selected host projects.

## Repository Layout

- `README.md`: short project overview.
- `docker/Dockerfile`: installs the command-line tools and Codex CLI used in the container.
- `docker/docker-compose.yaml`: builds the image, mounts project directories, exposes port `1455`, and persists Codex and GitHub CLI state.
- `docker/on-start.sh`: configures GitHub CLI Git authentication when `GH_TOKEN` is available, then executes the requested command.
- `.env`: local values for `HOST_HOME` and `GITHUB_TOKEN`; it is ignored and must remain uncommitted.

## Development Workflow

Run Compose commands from the repository root and pass the local environment file explicitly:

```bash
docker compose --env-file .env -f docker/docker-compose.yaml build
docker compose --env-file .env -f docker/docker-compose.yaml run --rm codex
```

Use `zsh` or another command after `codex` to override the service's default `bash` command.

There is no automated test suite. Before finishing a change, run the relevant checks:

```bash
bash -n docker/on-start.sh
docker compose --env-file .env -f docker/docker-compose.yaml config --quiet
```

After changing the Dockerfile, installed packages, startup script, build context, or environment wiring, also rebuild the image. If Docker is unavailable, report that the build was not verified.

## Change Guidelines

- Keep the base image and installed packages minimal. Continue using `--no-install-recommends` and remove APT metadata in the same layer.
- Preserve the startup script's final `exec "$@"` so signals and exit codes reach the invoked process correctly.
- Treat `GH_TOKEN` as optional; startup must continue to work when it is unset.
- The Compose build context is `docker/`, because relative paths are resolved from the Compose file's directory. Keep files copied by the Dockerfile inside that context unless the Compose configuration is deliberately changed.
- Keep host mounts narrowly scoped to explicit project/configuration directories. Do not mount an entire home directory or add privileged container options without a documented need.
- Named volumes `codex-data` and `gh-data` contain persistent configuration and authentication state. Do not remove or rename them casually.
- Never print, commit, or copy `.env`, `GITHUB_TOKEN`, `GH_TOKEN`, Codex credentials, SSH keys, or GitHub CLI credentials into the image.
- Use two-space indentation in YAML and four-space indentation in shell conditionals, matching the existing files.

## Documentation

Update `README.md` when setup steps, required environment variables, mounted paths, exposed ports, or normal usage changes. Keep commands in documentation runnable from the repository root.
