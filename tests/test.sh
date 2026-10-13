#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
}

echo "======================================"
echo "   Assignment 3 - Diagnostic CLI Tests"
echo "======================================"
echo

# 1. Help command
if ./app/app.sh help >/dev/null 2>&1; then
    pass "Help command works"
else
    fail "Help command failed"
fi

# 2. System information
if ./app/app.sh system-info >/dev/null 2>&1; then
    pass "System-info command works"
else
    fail "System-info command failed"
fi

# 3. Valid host
if ./app/app.sh check-host localhost >/dev/null 2>&1; then
    pass "Valid host check works"
else
    fail "Valid host check failed"
fi

# 4. Missing host
./app/app.sh check-host >/dev/null 2>&1
if [[ $? -eq 2 ]]; then
    pass "Missing host returns exit code 2"
else
    fail "Missing host should return exit code 2"
fi

# 5. Invalid command
./app/app.sh invalid-command >/dev/null 2>&1
if [[ $? -eq 2 ]]; then
    pass "Invalid command returns exit code 2"
else
    fail "Invalid command should return exit code 2"
fi

# 6. Missing port
./app/app.sh check-port localhost >/dev/null 2>&1
if [[ $? -eq 2 ]]; then
    pass "Missing port returns exit code 2"
else
    fail "Missing port should return exit code 2"
fi

# 7. Non-numeric port
./app/app.sh check-port localhost abc >/dev/null 2>&1
if [[ $? -eq 2 ]]; then
    pass "Non-numeric port returns exit code 2"
else
    fail "Non-numeric port should return exit code 2"
fi

# 8. Out-of-range port
./app/app.sh check-port localhost 65536 >/dev/null 2>&1
if [[ $? -eq 2 ]]; then
    pass "Port 65536 is rejected"
else
    fail "Port 65536 should return exit code 2"
fi

echo
echo "======================================"
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "======================================"

[[ $FAIL -eq 0 ]]
