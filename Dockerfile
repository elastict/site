# Build stage
FROM ubuntu:18.04 as builder

RUN apt-get update
RUN apt-get install -y curl ca-certificates build-essential autoconf automake autotools-dev libtool xutils-dev

ENV SSL_VERSION=1.0.2o

RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*

ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1

# Install Rust toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
ENV PATH=/root/.cargo/bin:$PATH

WORKDIR /code

# Run dummy build just to download the registry in a separate layer
RUN mkdir src && echo "// dummy file" > src/lib.rs
ADD Cargo.toml.dummy Cargo.toml
RUN cargo build

# Install dependencies
ADD Cargo.lock Cargo.toml /code/
RUN cargo build
RUN cargo build --release

# Actually build the src
ADD src /code/src
RUN cargo build --release

# Install Sass compiler
RUN curl https://github.com/sass/dart-sass/releases/download/1.22.3/dart-sass-1.22.3-linux-x64.tar.gz -L | tar -xzf -
RUN mv dart-sass/* /usr/bin

# Compile CSS
ADD scss /code/scss
RUN sass scss/base.scss base.css


# Run stage
FROM ubuntu:18.04

RUN mkdir /srv/elast
WORKDIR /srv/elast

# Copy server binary from builder stage
COPY --from=builder /code/target/release/elast-site /srv/elast/elast-site

# Copy templates
ADD templates /srv/elast/templates
# Copy static resources
ADD static /srv/elast/static
# Include compiled CSS
COPY --from=builder /code/base.css /srv/elast/static/css

CMD /srv/elast/elast-site
