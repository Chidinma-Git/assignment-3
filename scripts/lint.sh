#!/usr/bin/env bash

set -u

echo "======================================"
echo "        ASSIGNMENT 3 LINT CHECK"
echo "======================================"

FAILED=0

check_script() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "FAIL: $file does not exist"
        FAILED=1
        return
    fi

    if bash -n "$file" >/dev/null 2>&1; then
        echo "PASS: Bash syntax valid - $file"
    else
        echo "FAIL: Bash syntax error - $file"
        FAILED=1
    fi

    if [[ -x "$file" ]]; then
        echo "PASS: Executable - $file"
    else
        echo "FAIL: Not executable - $file"
        FAILED=1
    fi
}

check_script "app/app.sh"
check_script "app/health-check.sh"

echo
echo "======================================"

if [[ "$FAILED" -eq 0 ]]; then
    echo "Lint check passed."
    exit 0
else
    echo "Lint check failed."
    exit 1
fi