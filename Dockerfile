FROM alpine:3.11@sha256:1861023544345fc0a4b2223f2bcbb0e903ff2c1f29c09141250baf7f81333b49 AS builder

ENV GIT_CRYPT_VERSION 0.6.0
ENV GIT_CRYPT_CHECKSUM 777c0c7aadbbc758b69aff1339ca61697011ef7b92f1d1ee9518a8ee7702bb78

RUN apk --update --no-cache add \
   curl \
   g++ \
   make \
   openssl-dev

RUN curl -fSsL https://github.com/AGWA/git-crypt/archive/$GIT_CRYPT_VERSION.tar.gz \
            -o git-crypt.tar.gz \
    && echo "$GIT_CRYPT_CHECKSUM  git-crypt.tar.gz" | sha256sum -c - \
    && tar xzf git-crypt.tar.gz \
    && cd git-crypt-$GIT_CRYPT_VERSION \
    && make \
    && make install PREFIX=/usr

FROM alpine:3.11@sha256:1861023544345fc0a4b2223f2bcbb0e903ff2c1f29c09141250baf7f81333b49

RUN apk --update --no-cache add \
    git \
    gnupg \
    libgcc \
    libstdc++ \
    openssh-client

COPY --from=builder /usr/bin/git-crypt /usr/bin/git-crypt

COPY entrypoint.sh /entrypoint.sh

WORKDIR /repo
ENTRYPOINT ["/entrypoint.sh"]
