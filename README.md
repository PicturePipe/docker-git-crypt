# Docker Image with git-crypt

[![CircleCI Build](https://circleci.com/gh/PicturePipe/docker-git-crypt.svg?style=shield)](https://circleci.com/gh/PicturePipe/workflows/docker-git-crypt "CircleCI Build")
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovateapp.com/ "Renovate enabled")

[Docker](https://www.docker.com) image with [git-crypt](https://github.com/AGWA/git-crypt).

## Repository

The docker images are available in our [repository](https://quay.io/repository/picturepipe/git-crypt):

```console
docker pull quay.io/picturepipe/git-crypt
```

## Usage

This image can be used directly if you need to decrypt repositories in CI.

There is also wrapper script which allows you to use this docker image to run `git-crypt` as if
it was installed on your machine.

To use that script, install it somewhere into your `PATH`:

```console
sudo cp wrapper.sh /usr/local/bin/git-crypt
```

## Tags

The latest released version is tagged as `latest`.

The releases will follow the upstream version, with an optional dash and number appended, if there
are multiple releases per upstream version.

So for example, the first release for upstream version `0.6.0` will be tagged `0.6.0`. If there
is a second release for this upstream version, it will be tagged `0.6.0-1`.

## Preparing a release

This project uses gitflow. To create a release, first start the release branch for the version
which you want to release:

```console
git flow release start 0.6.0
```

Perform any release related changes. At the very least, this means updating the current tag given in
`README.md`.

Now, publish the release:

```console
git flow release publish
```

This will push the branch to GitHub and trigger a run of CI. Once CI is complete and all tests have
passed, finish the release and push the tag to GitHub:

```console
git flow release finish --push --tag
```

## License

Distributed under the MIT license.

Copyright 2019 reelport GmbH
