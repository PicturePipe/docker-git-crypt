#!/bin/sh

#
# Execute git-crypt with argv[0] set to "git-crypt". Otherwise it will
# show /usr/bin/git-crypt in usage and also install this full path into
# the host's git-config, which is not necessarily the location where the
# wrapper script is installed.
#

PATH="$PATH:/usr/bin"
export PATH

exec git-crypt "$@"
