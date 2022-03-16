FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y \
      curl \
      libssl-dev \
      racket \
      software-properties-common \
      yosys

WORKDIR /root
ADD . .

## Lakeroad setup
# raco (Racket) dependencies
# First, fix https://github.com/racket/racket/issues/2691
RUN raco setup --doc-index --force-user-docs \
  && raco pkg install --deps search-auto --batch rosette
# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"
# Build Rust package.
RUN cargo build --manifest-path ./lakeroad/rust/Cargo.toml

WORKDIR /root
CMD ["sh", "./run.sh"]
