#!/bin/sh
#
# This wrapper is intended to be installed in PATH e.g. as /usr/local/bin/git-crypt
#
# It allows to use git-crypt using the docker image.
#

set -e

#
# On some calls, git will pass along a temporary file to git-crypt.
# For this to work, we need to mount this file into the container.
#
if [ -n "$2" ] && [ "$(echo "$2" | cut -c1-1)" = "/" ]; then
    DOCKER_OPTS="--volume=$2:$2"
fi

#
# If the current user has GnuPG configured, pass the GnuPG directory
# into the container so that the keyring and/or agent can be accessed.
#
if [ -d "$HOME/.gnupg" ]; then
    DOCKER_OPTS="$DOCKER_OPTS --volume=$HOME/.gnupg:/.gnupg"
fi

#
# Unlocking the repository might require usage of pinentry which fails
# if is not run with a terminal.
#
if [ x"$1" = x"unlock" ]; then
    DOCKER_OPTS="$DOCKER_OPTS -t"
fi

# We want to split the options and know there are no other spaces in them.
# shellcheck disable=SC2086
exec docker run \
        --rm \
        --interactive \
        --user="$(id -u):$(id -g)" \
        --volume="$(pwd)":/repo \
        ${DOCKER_OPTS} \
        quay.io/picturepipe/git-crypt "$@"
