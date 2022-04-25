FROM alpine:3.13@sha256:ccf92aa53bc6c3b25be2ad0cce80baec1778f007f7e076b0ffbd1b225d0b3a9b AS builder

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

FROM alpine:3.13@sha256:ccf92aa53bc6c3b25be2ad0cce80baec1778f007f7e076b0ffbd1b225d0b3a9b

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
