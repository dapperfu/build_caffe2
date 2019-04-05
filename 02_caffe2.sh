#!/bin/sh

cd pytorch
git submodule update --init

cd ..

mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE \
    -DUSE_NATIVE_ARCH=ON \
    -DCMAKE_C_COMPILER=`which gcc-6` \
    -DCMAKE_CXX_COMPILER=`which g++-6` \
    -DPYTHON_EXECUTABLE=`which python3` \
    -DCMAKE_C_FLAGS="-I/usr/lib/cuda-10.1/include -I/usr/lib/cuda-10.1/include/crt" \
    -DCMAKE_CXX_FLAGS="-I/usr/lib/cuda-10.1/include -I/usr/lib/cuda-10.1/include/crt" \
    ../pytorch

