#!/usr/bin/env bash

set -u

APP="./app/app.sh"

if [[ ! -x "$APP" ]]; then
    echo "FAIL"
    exit 1
fi

if "$APP" help >/dev/null 2>&1; then
    echo "OK"
    exit 0
else
    echo "FAIL"
    exit 1
fi