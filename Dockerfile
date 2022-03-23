FROM ubuntu:22.04

# Install apt dependencies. DEBIAN_FRONTEND is necessary for making sure tzdata
# setup runs non-interactively.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
      build-essential \
      curl \
      libssl-dev \
      racket \
      software-properties-common \
      wget

# Install Yosys and other OSS hardware tools from prebuilt binaries.
#
# If we get an error here, we likely just need to add other branches for other
# architectures.
WORKDIR /root
RUN if [ "$(uname -m)" = "x86_64" ] ; then \
    wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2022-03-23/oss-cad-suite-linux-x64-20220323.tgz -q -O oss-cad-suite.tgz; \
  else \
    exit 1; \
  fi
ENV PATH="/root/oss-cad-suite/bin:${PATH}"

# Install raco (Racket) dependencies. First, fix
# https://github.com/racket/racket/issues/2691 by building the docs.
RUN raco setup --doc-index --force-user-docs \
  && raco pkg install --deps search-auto --batch rosette

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Add files. It's best to do this as late as possible in the Dockerfile, because
# if the files change, everything after this line will not be cached. Note that
# it may be better to add files only as needed, to optimize caching during
# build. E.g. right now, if we change run.sh, the rust build below will not be
# cached because we add all files at once. but if we add run.sh after the Rust
# build, the Rust build will be cached (I think).
WORKDIR /root
ADD . .

# Build Lakeroad Rust package.
RUN cargo build --manifest-path ./lakeroad/rust/Cargo.toml

WORKDIR /root
CMD ["/bin/bash", "/root/run.sh"]