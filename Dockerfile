FROM ubuntu:22.04

# Necessary for making sure tzdata runs noninteractively.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
      build-essential \
      curl \
      libssl-dev \
      racket \
      software-properties-common \
      yosys

# raco (Racket) dependencies
# First, fix https://github.com/racket/racket/issues/2691
RUN raco setup --doc-index --force-user-docs \
  && raco pkg install --deps search-auto --batch rosette

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /root
ADD . .

# Build Lakeroad Rust package.
RUN cargo build --manifest-path ./lakeroad/rust/Cargo.toml

WORKDIR /root
CMD ["/bin/bash", "./run.sh"]
