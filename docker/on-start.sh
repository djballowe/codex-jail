#!/bin/bash
set -e

if [ -n "$GH_TOKEN" ]; then
    gh auth setup-git --hostname github.com
fi

exec "$@"
