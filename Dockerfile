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
  libtinfo5 \
  libssl-dev \
  libx11-6 \
  libxml2-dev \
  llvm-14 \
  locales \
  ninja-build \
  ocl-icd-opencl-dev \
  opencl-headers \
  parallel \
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

# Set the locale. Necessary for Vivado.
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

# Point to llvm-config binary. Alternatively, make sure you have a binary called
# `llvm-config` on your PATH.
ENV LLVM_CONFIG=llvm-config-14

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

# # Download old LLVM 11 for Calyx's TVM experiments.
# #
# # If we get an error here, we likely just need to add other branches for other
# # architectures.
# WORKDIR /root
# RUN if [ "$(uname -m)" = "x86_64" ] ; then \
#   wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz -q -O llvm-11.tar.xz; \
#   else \
#   exit 1; \
#   fi \
#   && mkdir llvm-11 && tar xf llvm-11.tar.xz -C llvm-11 --strip-components 1

# # Install TVM.
# ARG MAKE_JOBS=2
# RUN wget https://apt.llvm.org/llvm.sh \
#   && chmod +x llvm.sh \
#   && add-apt-repository -y 'deb http://apt.llvm.org/jammy/     llvm-toolchain-jammy-13 main' \
#   && ./llvm.sh 13 \
#   && git clone --recursive https://github.com/apache/tvm tvm \
#   && cd tvm \
#   && git fetch \
#   && git checkout ccacb1ec1 \
#   && git submodule update --recursive \
#   && mkdir build \
#   && cd build \
#   && cp ../cmake/config.cmake . \
#   && echo "set(USE_LLVM /root/llvm-11/bin/llvm-config)" >> config.cmake \
#   && cmake .. \
#   && make -j${MAKE_JOBS}
# ENV TVM_HOME=/root/tvm
# ENV PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}

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

# Build Dahlia. First, install Scala via cs setup; then, build Dahlia.
WORKDIR /root
ADD dahlia/ dahlia/
RUN curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > cs \
  && chmod +x cs \
  && ./cs setup --yes \
  && cd /root/dahlia \
  && /root/.local/share/coursier/sbt assembly
ENV PATH="${PATH}:/root/.local/share/coursier/bin"

# Set up Calyx.
RUN mkdir /root/.config 

# Build vanilla, unmodified Calyx.
ADD calyx /root/calyx
RUN cargo build --manifest-path ./calyx/Cargo.toml \
  && python3 -m venv --clear ./calyx/venv/ \
  # && cd /root/tvm/python \
  # && /root/calyx/bin/python setup.py install \
  # && cd /root/tvm/topi/python \
  # && /root/calyx/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx/fud/pyproject.toml install -s --deps all --python ./calyx/venv/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx/calyx-py/pyproject.toml install -s --deps all --python ./calyx/venv/bin/python \
  && ./calyx/venv/bin/fud config global.futil_directory /root/calyx \
  && ./calyx/venv/bin/fud config stages.futil.exec /root/calyx/target/debug/futil \
  && ./calyx/venv/bin/fud config stages.dahlia.exec /root/dahlia/fuse

# Build Xilinx UltraScale+ version of Calyx.
ADD calyx-xilinx-ultrascale-plus /root/calyx-xilinx-ultrascale-plus
RUN cargo build --manifest-path ./calyx-xilinx-ultrascale-plus/Cargo.toml \
  && python3 -m venv --clear ./calyx-xilinx-ultrascale-plus/venv/ \
  # && cd /root/tvm/python \
  # && /root/calyx-xilinx-ultrascale-plus/bin/python setup.py install \
  # && cd /root/tvm/topi/python \
  # && /root/calyx-xilinx-ultrascale-plus/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-xilinx-ultrascale-plus/fud/pyproject.toml install -s --deps all --python ./calyx-xilinx-ultrascale-plus/venv/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-xilinx-ultrascale-plus/calyx-py/pyproject.toml install -s --deps all --python ./calyx-xilinx-ultrascale-plus/venv/bin/python \
  && ./calyx-xilinx-ultrascale-plus/venv/bin/fud config global.futil_directory /root/calyx-xilinx-ultrascale-plus \
  && ./calyx-xilinx-ultrascale-plus/venv/bin/fud config stages.futil.exec /root/calyx-xilinx-ultrascale-plus/target/debug/futil \
  && ./calyx-xilinx-ultrascale-plus/venv/bin/fud config stages.dahlia.exec /root/dahlia/fuse

# Build Lattice ECP5 version of Calyx.
ADD calyx-lattice-ecp5 /root/calyx-lattice-ecp5
RUN cargo build --manifest-path ./calyx-lattice-ecp5/Cargo.toml \
  && python3 -m venv --clear ./calyx-lattice-ecp5/venv/ \
  # && cd /root/tvm/python \
  # && /root/calyx-lattice-ecp5/bin/python setup.py install \
  # && cd /root/tvm/topi/python \
  # && /root/calyx-lattice-ecp5/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-lattice-ecp5/fud/pyproject.toml install -s --deps all --python ./calyx-lattice-ecp5/venv/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx-lattice-ecp5/calyx-py/pyproject.toml install -s --deps all --python ./calyx-lattice-ecp5/venv/bin/python \
  && ./calyx-lattice-ecp5/venv/bin/fud config global.futil_directory /root/calyx-lattice-ecp5 \
  && ./calyx-lattice-ecp5/venv/bin/fud config stages.futil.exec /root/calyx-lattice-ecp5/target/debug/futil \
  && ./calyx-lattice-ecp5/venv/bin/fud config stages.dahlia.exec /root/dahlia/fuse

# Build Lattice ECP5 Diamond version of Calyx.
ADD calyx_lattice_ecp5_diamond /root/calyx_lattice_ecp5_diamond
RUN cargo build --manifest-path ./calyx_lattice_ecp5_diamond/Cargo.toml \
  && python3 -m venv --clear ./calyx_lattice_ecp5_diamond/venv/ \
  # && cd /root/tvm/python \
  # && /root/calyx_lattice_ecp5_diamond/bin/python setup.py install \
  # && cd /root/tvm/topi/python \
  # && /root/calyx_lattice_ecp5_diamond/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx_lattice_ecp5_diamond/fud/pyproject.toml install -s --deps all --python ./calyx_lattice_ecp5_diamond/venv/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx_lattice_ecp5_diamond/calyx-py/pyproject.toml install -s --deps all --python ./calyx_lattice_ecp5_diamond/venv/bin/python \
  && ./calyx_lattice_ecp5_diamond/venv/bin/fud config global.futil_directory /root/calyx_lattice_ecp5_diamond \
  && ./calyx_lattice_ecp5_diamond/venv/bin/fud config stages.futil.exec /root/calyx_lattice_ecp5_diamond/target/debug/futil \
  && ./calyx_lattice_ecp5_diamond/venv/bin/fud config stages.dahlia.exec /root/dahlia/fuse

# Build Xilinx UltraScale+ Vivado version of Calyx.
ADD calyx_vivado /root/calyx_vivado
RUN cargo build --manifest-path ./calyx_vivado/Cargo.toml \
  && python3 -m venv --clear ./calyx_vivado/venv/ \
  # && cd /root/tvm/python \
  # && /root/calyx_vivado/bin/python setup.py install \
  # && cd /root/tvm/topi/python \
  # && /root/calyx_vivado/bin/python setup.py install \
  && cd /root/ \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx_vivado/fud/pyproject.toml install -s --deps all --python ./calyx_vivado/venv/bin/python \
  && FLIT_ROOT_INSTALL=1 flit -f ./calyx_vivado/calyx-py/pyproject.toml install -s --deps all --python ./calyx_vivado/venv/bin/python \
  && ./calyx_vivado/venv/bin/fud config global.futil_directory /root/calyx_vivado \
  && ./calyx_vivado/venv/bin/fud config stages.futil.exec /root/calyx_vivado/target/debug/futil \
  && ./calyx_vivado/venv/bin/fud config stages.dahlia.exec /root/dahlia/fuse

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

WORKDIR /root
ADD calyx-evaluation/ calyx-evaluation/

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
CMD ["bash", "-c", "doit -f experiments/dodo.py -n `nproc`"]