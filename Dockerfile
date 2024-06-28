FROM alpine:3.13@sha256:16fd981ddc557fd3b38209d15e7ee8e3e6d9d4d579655e8e47243e2c8525b503 AS builder

ENV GIT_CRYPT_VERSION 0.7.0
ENV GIT_CRYPT_CHECKSUM 2210a89588169ae9a54988c7fdd9717333f0c6053ff704d335631a387bd3bcff

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

FROM alpine:3.13@sha256:16fd981ddc557fd3b38209d15e7ee8e3e6d9d4d579655e8e47243e2c8525b503

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
