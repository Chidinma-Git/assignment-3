#!/usr/bin/env bash

set -u

IMAGE_NAME="devops-tool"

echo "======================================"
echo "     ASSIGNMENT 3 DOCKER BUILD"
echo "======================================"

echo
echo "Building Docker image: $IMAGE_NAME"

if ! docker build -t "$IMAGE_NAME" .; then
    echo "ERROR: Docker image build failed."
    exit 1
fi

echo
echo "PASS: Docker image built successfully."

echo
echo "Running help command..."

if docker run --rm "$IMAGE_NAME" help >/dev/null; then
    echo "PASS: Help command works."
else
    echo "FAIL: Help command failed."
    exit 1
fi

echo
echo "Running system-info command..."

if docker run --rm "$IMAGE_NAME" system-info >/dev/null; then
    echo "PASS: system-info command works."
else
    echo "FAIL: system-info command failed."
    exit 1
fi

echo
echo "Testing invalid command..."

if docker run --rm "$IMAGE_NAME" invalid-command >/dev/null 2>&1; then
    echo "FAIL: Invalid command should return non-zero."
    exit 1
else
    echo "PASS: Invalid command returns non-zero."
fi

echo
echo "======================================"
echo " Docker build and smoke tests passed"
echo "======================================"#!/usr/bin/env bash

set -u

IMAGE="assignment-3-diagnostic-cli"

echo "======================================"
echo "   Assignment 3 Docker Build"
echo "======================================"

echo
echo "Building Docker image: $IMAGE"

if ! docker build -t "$IMAGE" .; then
    echo "ERROR: Docker image build failed."
    exit 1
fi

echo
echo "Docker image built successfully."

echo
echo "Running Docker smoke tests..."

if ! docker run --rm "$IMAGE" help; then
    echo "ERROR: Docker help smoke test failed."
    exit 1
fi

if ! docker run --rm "$IMAGE" system-info; then
    echo "ERROR: Docker system-info smoke test failed."
    exit 1
fi

echo
echo "======================================"
echo "Docker build and smoke tests passed."
echo "======================================"
