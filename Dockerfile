FROM ubuntu:22.04

# Install apt dependencies. DEBIAN_FRONTEND is necessary for making sure tzdata
# setup runs non-interactively.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y \
  bison \
  build-essential \
  clang \
  cmake \
  curl \
  dvipng \
  flex \
  gawk \
  gcc \
  git \
  graphviz \
  jq \
  libboost-all-dev \
  libedit-dev \
  libffi-dev \
  libtinfo-dev \
  libtinfo5 \
  libreadline8 \
  libreadline-dev \
  libssl-dev \
  libtcl8.6 \
  libx11-6 \
  libxml2-dev \
  llvm-14 \
  locales \
  ninja-build \
  ocl-icd-opencl-dev \
  opencl-headers \
  openjdk-11-jre \
  parallel \
  pkg-config \
  python3 \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-venv \
  racket \
  software-properties-common \
  tcl-dev \
  tcl8.6-dev \
  texlive \
  texlive-latex-extra \
  verilator \
  wget \
  zlib1g-dev 

# Set the locale. Necessary for Vivado.
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

# Point to llvm-config binary. Alternatively, make sure you have a binary called
# `llvm-config` on your PATH.
ENV LLVM_CONFIG=llvm-config-14

# Build our version of Yosys.
WORKDIR /root/
ADD yosys/ yosys/
RUN cd yosys && \
  CPLUS_INCLUDE_PATH="/usr/include/tcl8.6/:$CPLUS_INCLUDE_PATH" make -j `nproc`

# Make a binary for `lit`. If you're on Mac, you can install lit via Brew.
# Ubuntu doesn't have a binary for it, but it is available on pip and is
# installed later in this Dockerfile.
WORKDIR /root
RUN mkdir -p /root/.local/bin \
  && echo "#!/usr/bin/env python3" >> /root/.local/bin/lit \
  && echo "from lit.main import main" >> /root/.local/bin/lit \
  && echo "if __name__ == '__main__': main()" >> /root/.local/bin/lit \
  && chmod +x /root/.local/bin/lit
ENV PATH="/root/.local/bin:${PATH}"

# Build CIRCT/MLIR.
# Disabled for now, as we're not using MLIR yet. The build is slow.
# WORKDIR /root
# ARG MAKE_JOBS=2
# ADD circt/ circt/
# RUN cd circt \
#   && mkdir llvm/build \
#   && cd llvm/build \
#   && cmake -G Ninja ../llvm \
#   -DLLVM_ENABLE_PROJECTS="mlir" \
#   -DLLVM_TARGETS_TO_BUILD="host" \
#   -DLLVM_ENABLE_ASSERTIONS=ON \
#   -DCMAKE_BUILD_TYPE=DEBUG \
#   -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
#   && ninja -j${MAKE_JOBS} \
#   && cd ../.. \
#   && mkdir build && cd build && cmake -G Ninja .. \
#   -DMLIR_DIR=$PWD/../llvm/build/lib/cmake/mlir \
#   -DLLVM_DIR=$PWD/../llvm/build/lib/cmake/llvm \
#   -DLLVM_ENABLE_ASSERTIONS=ON \
#   -DCMAKE_BUILD_TYPE=DEBUG \
#   -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
#   && ninja -j${MAKE_JOBS}

# Build and install latest boolector.
WORKDIR /root
RUN git clone https://github.com/boolector/boolector \
  && cd boolector \
  && git checkout 3.2.2 \
  && ./contrib/setup-lingeling.sh \
  && ./contrib/setup-btor2tools.sh \
  && ./configure.sh && cd build && make install

# Set up Python.
WORKDIR /root
ADD requirements.txt requirements.txt
RUN pip3 install --requirement requirements.txt 

# Make Python utilities visible.
ADD python/ /root/python/
ENV PYTHONPATH=/root/python/:${PYTHONPATH}

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
  && raco pkg install --deps search-auto --batch \
  rosette \
  yaml

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Cargo dependencies.
RUN cargo install \
  runt \
  vcdump

# Build Lakeroad Rust package.
ADD lakeroad /root/lakeroad
RUN cargo build --manifest-path ./lakeroad/rust/Cargo.toml
ENV LAKEROAD_DIR=/root/lakeroad

# Build Racket bytecode; makes Lakeroad WAY faster.
RUN raco make /root/lakeroad/bin/main.rkt

# Set up Lattice Diamond. 
#
# The following can be ignored if you're not using Diamond.
#
# Path to Diamond bin dir, when mounted in the container. E.g. if we mount
# Diamond to /usr/local/diamond in the container, then
# DIAMOND_BINDIR=/usr/local/diamond/3.12/bin/lin64.
#
# Note: due to how Lattice scripts are written, DIAMOND_BINDIR must NOT end in a
# slash.
ARG DIAMOND_BINDIR
ENV DIAMOND_BINDIR=${DIAMOND_BINDIR}

WORKDIR /root
# Add the rest of the stuff. This might be a bad idea, I'm still not sure on
# Docker best practices.
ADD . .

ARG VIVADO_BIN_DIR
ENV PATH="${VIVADO_BIN_DIR}:${PATH}"

# Build sv2v, a SystemVerilog to Verilog compiler.
# Install Haskell Stack and build
WORKDIR /root
RUN wget -qO- https://get.haskellstack.org/ | sh \
  && git clone https://github.com/zachjs/sv2v.git \
  && cd sv2v \
  && git checkout v0.0.10 \
  && make
ENV PATH=/root/sv2v/bin:${PATH}

WORKDIR /root
ADD verilog/ verilog/

# Install Verilator, set environment variable.
WORKDIR /root
ADD verilator/ verilator/
RUN unset VERILATOR_ROOT \
  && cd verilator/ \
  && autoconf \
  && ./configure \
  && make -j `nproc` \
  && sudo make install
ENV VERILATOR_INCLUDE_DIR=/usr/local/share/verilator/include

WORKDIR /root
CMD ["bash", "-c", "doit -f experiments/dodo.py -n `nproc`"]