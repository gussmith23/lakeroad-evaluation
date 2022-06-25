FROM ubuntu:22.04

# Install apt dependencies. DEBIAN_FRONTEND is necessary for making sure tzdata
# setup runs non-interactively.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
      build-essential \
      curl \
      libssl-dev \
      python3-pip \
      python3-venv \
      racket \
      software-properties-common \
      verilator \
      wget

# Set up Python.
WORKDIR /root
ADD requirements.txt requirements.txt
RUN pip3 install --requirement requirements.txt 

# Install Yosys and other OSS hardware tools from prebuilt binaries.
#
# If we get an error here, we likely just need to add other branches for other
# architectures.
WORKDIR /root
RUN if [ "$(uname -m)" = "x86_64" ] ; then \
    wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2022-03-23/oss-cad-suite-linux-x64-20220323.tgz -q -O oss-cad-suite.tgz; \
  else \
    exit 1; \
  fi \
  && tar xf oss-cad-suite.tgz
ENV PATH="/root/oss-cad-suite/bin:${PATH}"

# Install raco (Racket) dependencies. First, fix
# https://github.com/racket/racket/issues/2691 by building the docs.
RUN raco setup --doc-index --force-user-docs \
  && raco pkg install --deps search-auto --batch rosette

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Cargo dependencies.
RUN cargo install runt

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

# Set up Calyx.
RUN mkdir /root/.config 

# Build vanilla, unmodified Calyx.
RUN cargo build --manifest-path ./calyx/Cargo.toml \
  && python3 -m venv ./calyx/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx/fud/pyproject.toml install -s --deps production --python ./calyx/bin/python \
  && ./calyx/bin/fud config global.futil_directory /root/calyx \
  && ./calyx/bin/fud config stages.futil.exec /root/calyx/target/debug/futil

# Build Xilinx UltraScale+ version of Calyx.
RUN cargo build --manifest-path ./calyx-xilinx-ultrascale-plus/Cargo.toml \
  && python3 -m venv ./calyx-xilinx-ultrascale-plus/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-xilinx-ultrascale-plus/fud/pyproject.toml install -s --deps production --python ./calyx-xilinx-ultrascale-plus/bin/python \
  && ./calyx-xilinx-ultrascale-plus/bin/fud config global.futil_directory /root/calyx-xilinx-ultrascale-plus \
  && ./calyx-xilinx-ultrascale-plus/bin/fud config stages.futil.exec /root/calyx-xilinx-ultrascale-plus/target/debug/futil

WORKDIR /root
CMD ["/bin/bash", "/root/run.sh"]