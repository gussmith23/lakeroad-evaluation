FROM ubuntu:22.04

# Install apt dependencies. DEBIAN_FRONTEND is necessary for making sure tzdata
# setup runs non-interactively.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y \
  autoconf \
  bison \
  build-essential \
  ccache \
  clang \
  cloc \
  cmake \
  curl \
  dvipng \
  flex \
  g++ \
  gawk \
  gcc \
  git \
  graphviz \
  help2man \
  jq \
  libboost-all-dev \
  libedit-dev \
  libffi-dev \
  libfl-dev \
  libfl2 \
  libgmp-dev \
  libgoogle-perftools-dev \
  libreadline-dev \
  libreadline8 \
  libssl-dev \
  libtcl8.6 \
  libtinfo-dev \
  libtinfo5 \
  libx11-6 \
  libxml2-dev \
  llvm-14 \
  locales \
  make \
  ninja-build \
  numactl \
  ocl-icd-opencl-dev \
  opencl-headers \
  openjdk-11-jre \
  parallel \
  perl \
  perl-doc \
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
  wget \
  zlib1g \
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
# Also make sure we can import simulate_with_verilator.py from Lakeroad's bin/ dir.
# TODO(@gussmith23): This is a hack. I still don't understand Python imports.
ADD python/ /root/python/
ENV PYTHONPATH="/root/python/:/root/lakeroad/bin:${PYTHONPATH}"

# Install Yosys and other OSS hardware tools from prebuilt binaries.
#
# If we get an error here, we likely just need to add other branches for other
# architectures.
WORKDIR /root
RUN if [ "$(uname -m)" = "x86_64" ] ; then \
  wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2023-08-06/oss-cad-suite-linux-x64-20230806.tgz -q -O oss-cad-suite.tgz; \
  else \
  exit 1; \
  fi \
  && tar xf oss-cad-suite.tgz
ENV PATH="/root/oss-cad-suite/bin:${PATH}"
# Remove Verilator installed in the oss-cad-suite, as we will build and install our own.
# TODO(@gussmith23): Either don't add oss-cad-suite to path, or clean this up some other way.
RUN rm /root/oss-cad-suite/bin/verilator

# Build latest bitwuzla.
WORKDIR /root
ARG MAKE_JOBS=2
ADD lakeroad/bitwuzla bitwuzla
RUN cd bitwuzla \
  && ./configure.py \
  && cd build \
  && ninja -j${MAKE_JOBS}
# Put it on the path. Note that there's a bitwuzla in oss-cad-suite, so we need
# to make sure this one takes precedence.
ENV PATH="/root/bitwuzla/build/src/main/:${PATH}"

# Install raco (Racket) dependencies. First, fix
# https://github.com/racket/racket/issues/2691 by building the docs.
WORKDIR /root
RUN raco setup --doc-index --force-user-docs \
  && raco pkg install --deps search-auto --batch \
  rosette \
  yaml

# Install Rust.
WORKDIR /root
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

# Set up external tools. These tools should be mounted into the container at
# runtime with e.g.:
# `-v /tools/intelFPGA_lite/22.1std:/tools/intelFPGA_lite/22.1std`
ARG VIVADO_BIN_DIR
ENV PATH="${VIVADO_BIN_DIR}:${PATH}"
ARG QUARTUS_BIN_DIR
ENV PATH="${QUARTUS_BIN_DIR}:${PATH}"

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
  && make install
ENV VERILATOR_INCLUDE_DIR=/usr/local/share/verilator/include

# Build STP.
WORKDIR /root
ENV STP_URL="https://github.com/stp/stp/archive/0510509a85b6823278211891cbb274022340fa5c.tar.gz"
RUN apt-get install -y git cmake bison flex libboost-all-dev python2 perl && \
  wget ${STP_URL} -nv -O stp.tar.gz && \
  mkdir stp && \
  tar xzf stp.tar.gz -C stp --strip-components=1 && \
  cd stp && \
  ./scripts/deps/setup-gtest.sh && \
  ./scripts/deps/setup-outputcheck.sh && \
  ./scripts/deps/setup-cms.sh && \
  ./scripts/deps/setup-minisat.sh && \
  mkdir build && \
  cd build && \
  cmake .. && \
  cmake --build . -j${MAKE_JOBS}
ENV PATH="/root/stp/build:${PATH}"

# Build Yices2.
# TODO(@gussmith23): Can we just use the yices in oss-cad-suite? Here, and in Lakeroad itself.
WORKDIR /root
ENV YICES2_URL="https://github.com/SRI-CSL/yices2/archive/e27cf308cffb0ecc6cc7165c10e81ca65bc303b3.tar.gz"
RUN apt-get install -y gperf && \
  wget ${YICES2_URL} -nv -O yices2.tar.gz && \
  mkdir yices2 && \
  tar xvf yices2.tar.gz -C yices2 --strip-components=1 && \
  cd yices2 && \
  autoconf && \
  ./configure && \
  make -j${MAKE_JOBS} && \
  # If this line fails, it's presumably because we're on a different architecture.
  [ -d build/x86_64-pc-linux-gnu-release/bin ]
ENV PATH="/root/yices2/build/x86_64-pc-linux-gnu-release/bin/:${PATH}"



WORKDIR /root
CMD ["bash", "-c", "doit -f experiments/dodo.py -n `nproc`"]
