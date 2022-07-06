FROM ubuntu:22.04

# Install apt dependencies. DEBIAN_FRONTEND is necessary for making sure tzdata
# setup runs non-interactively.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y \
  build-essential \
  cmake \
  curl \
  gcc \
  git \
  jq \
  libedit-dev \
  libtinfo-dev \
  libssl-dev \
  libxml2-dev \
  ninja-build \
  ocl-icd-opencl-dev \
  opencl-headers \
  python3 \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-venv \
  racket \
  software-properties-common \
  verilator \
  wget \
  zlib1g-dev 

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

# Download old LLVM 11 for Calyx's TVM experiments.
#
# If we get an error here, we likely just need to add other branches for other
# architectures.
WORKDIR /root
RUN if [ "$(uname -m)" = "x86_64" ] ; then \
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz -q -O llvm-11.tar.xz; \
  else \
  exit 1; \
  fi \
  && mkdir llvm-11 && tar xf llvm-11.tar.xz -C llvm-11 --strip-components 1

# Install TVM.
ARG MAKE_JOBS=2
RUN wget https://apt.llvm.org/llvm.sh \
  && chmod +x llvm.sh \
  && add-apt-repository -y 'deb http://apt.llvm.org/jammy/     llvm-toolchain-jammy-13 main' \
  && ./llvm.sh 13 \
  && git clone --recursive https://github.com/apache/tvm tvm \
  && cd tvm \
  && git fetch \
  && git checkout ccacb1ec1 \
  && git submodule update --recursive \
  && mkdir build \
  && cd build \
  && cp ../cmake/config.cmake . \
  && echo "set(USE_LLVM /root/llvm-11/bin/llvm-config)" >> config.cmake \
  && cmake .. \
  && make -j${MAKE_JOBS}
ENV TVM_HOME=/root/tvm
ENV PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}

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
RUN cargo install \
  runt \
  vcdump

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
  && cd /root/tvm/python \
  && /root/calyx/bin/python setup.py install \
  && cd /root/tvm/topi/python \
  && /root/calyx/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx/fud/pyproject.toml install -s --deps all --python ./calyx/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx/calyx-py/pyproject.toml install -s --deps all --python ./calyx/bin/python \
  && ./calyx/bin/fud config global.futil_directory /root/calyx \
  && ./calyx/bin/fud config stages.futil.exec /root/calyx/target/debug/futil

# Build Xilinx UltraScale+ version of Calyx.
RUN cargo build --manifest-path ./calyx-xilinx-ultrascale-plus/Cargo.toml \
  && python3 -m venv ./calyx-xilinx-ultrascale-plus/ \
  && cd /root/tvm/python \
  && /root/calyx-xilinx-ultrascale-plus/bin/python setup.py install \
  && cd /root/tvm/topi/python \
  && /root/calyx-xilinx-ultrascale-plus/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-xilinx-ultrascale-plus/fud/pyproject.toml install -s --deps all --python ./calyx-xilinx-ultrascale-plus/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-xilinx-ultrascale-plus/calyx-py/pyproject.toml install -s --deps all --python ./calyx-xilinx-ultrascale-plus/bin/python \
  && ./calyx-xilinx-ultrascale-plus/bin/fud config global.futil_directory /root/calyx-xilinx-ultrascale-plus \
  && ./calyx-xilinx-ultrascale-plus/bin/fud config stages.futil.exec /root/calyx-xilinx-ultrascale-plus/target/debug/futil

# Build Lattice ECP5 version of Calyx.
RUN cargo build --manifest-path ./calyx-lattice-ecp5/Cargo.toml \
  && python3 -m venv ./calyx-lattice-ecp5/ \
  && cd /root/tvm/python \
  && /root/calyx-lattice-ecp5/bin/python setup.py install \
  && cd /root/tvm/topi/python \
  && /root/calyx-lattice-ecp5/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-lattice-ecp5/fud/pyproject.toml install -s --deps all --python ./calyx-lattice-ecp5/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-lattice-ecp5/calyx-py/pyproject.toml install -s --deps all --python ./calyx-lattice-ecp5/bin/python \
  && ./calyx-lattice-ecp5/bin/fud config global.futil_directory /root/calyx-lattice-ecp5 \
  && ./calyx-lattice-ecp5/bin/fud config stages.futil.exec /root/calyx-lattice-ecp5/target/debug/futil

ENV LAKEROAD_DIR=/root/lakeroad

WORKDIR /root
CMD ["/bin/bash", "/root/run.sh"]