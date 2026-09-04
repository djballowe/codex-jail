#!/bin/bash
set -e

if [ -n "$GH_TOKEN" ]; then
    gh auth setup-git --hostname github.com
    git config --global \
        url."https://github.com/".insteadOf "git@github.com:"
fi

exec "$@"
