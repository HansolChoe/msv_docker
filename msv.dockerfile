FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV LIBRARY_PATH=/usr/local/lib
ENV LC_CTYPE C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get -yq update && \
 apt-get install -y subversion bison flex python3 python3-pip git tar make automake cmake \
 libncurses5 libncurses5-dev software-properties-common libtool libexplain-dev && \
 rm -rf /var/lib/apt/lists/*

RUN pip3 install watchdog numpy matplotlib psutil python-Levenshtein pyyaml

ARG JOBS=1

# Installing Clang 11.1.0
WORKDIR /root
RUN git clone https://github.com/llvm/llvm-project.git -b release/11.x --depth 1 && \
 mkdir -p /root/llvm-project/build && \
 cd /root/llvm-project/build && \
 cmake -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra' -DLLVM_PARALLEL_COMPILE_JOBS=${JOBS} -DLLVM_PARALLEL_LINK_JOBS=${JOBS} -DBUILD_SHARED_LIBS=ON ../llvm/ && \
 make -j ${JOBS} && make -j ${JOBS} install

ARG GH_USER
ARG GH_TOKEN

# Installing MSV
WORKDIR /root
RUN git clone https://${GH_USER}:${GH_TOKEN}@github.com/Suresoft-GLaDOS/MSV.git -b without-exper && \
 cd /root/MSV && ./build.sh

# Installing MSV-Search
WORKDIR /root
RUN git clone https://${GH_USER}:${GH_TOKEN}@github.com/Suresoft-GLaDOS/MSV-search.git
