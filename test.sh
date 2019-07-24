#!/bin/bash

set -e
set -u
set -o pipefail

cd "$(dirname "$0")"

if [ -z "${CI:-}" ]; then
    DOCKER_IMAGE_SPEC="git-crypt"
else
    # When we are running on CircleCI, retrieve the image and tag which we just built.
    # This is a bit hacky, but we don't have access to the parameters passed to docker-publish/build.
    DOCKER_IMAGE_SPEC="$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "${DOCKER_IMAGE}:")"
fi

echo "==> Checking if git-crypt is present in the image..." >&2
if docker run --rm "$DOCKER_IMAGE_SPEC" help > /dev/null; then
    echo "==> git-crypt found." >&2
else
    echo "==> git-crypt seems to be broken!" >&2
    exit 1
fi

echo "==> Checking if git is present in the image..." >&2
if docker run --entrypoint=/usr/bin/git --rm "$DOCKER_IMAGE_SPEC" version | grep -q 'git version'; then
    echo "==> Git found." >&2
else
    echo "==> Git seems to be broken!" >&2
    exit 1
fi
