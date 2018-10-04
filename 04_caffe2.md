# Step 4: caffe2

    apt-get install --yes checkinstall git cmake python3 python3-dev python3-numpy libeigen3-dev liblmdb++-dev libopencv-dev gcc-6 g++-6

    git clone --branch v0.4.1 --depth 1 --recursive --recurse-submodules -j8 https://github.com/pytorch/pytorch.git
    cd pytorch
	mkdir build
	cd build

	cmake -DCMAKE_BUILD_TYPE=RELEASE \
	        -DUSE_NATIVE_ARCH=ON \
		-DCMAKE_C_COMPILER=`which gcc-6` \
		-DCMAKE_CXX_COMPILER=`which g++-6` \
		-DPYTHON_EXECUTABLE=`which python3` \
		-DCMAKE_C_FLAGS="-I/usr/local/cuda-9.2/include -I/usr/local/cuda-9.2/include/crt" \
		-DCMAKE_CXX_FLAGS="-I/usr/local/cuda-9.2/include -I/usr/local/cuda-9.2/include/crt" \
		..

Build ```.deb```:

    checkinstall --install=no --default --pkgname=caffe2 --pkgversion=0.4.1 --pkgrelease=1 --pkglicense=BSD make -j8 install

Install ```.deb```:

    dpkg -i caffe2_0.4.1-1_amd64.deb

View all installed files:

    dpkg -L caffe2

Remove package:

    dpkg -r caffe2

## Distributed build with icecream

[icecream](https://github.com/icecc/icecream) 

Create ```gcc-6``` and ```g++-6``` symbolic links to ```icecc``` binary:

    ln -s /usr/bin/icecc /usr/lib/icecc/bin/gcc-6
    ln -s /usr/bin/icecc /usr/lib/icecc/bin/g++-6

```cmake``` command:

    cmake -DCMAKE_BUILD_TYPE=RELEASE \
		-DCMAKE_C_COMPILER=/usr/lib/icecc/bin/gcc-6 \
		-DCMAKE_CXX_COMPILER=/usr/lib/icecc/bin/g++-6 \
		-DPYTHON_EXECUTABLE=`which python3` \
		-DCMAKE_C_FLAGS="-I/usr/local/cuda-9.2/include -I/usr/local/cuda-9.2/include/crt" \
		-DCMAKE_CXX_FLAGS="-I/usr/local/cuda-9.2/include -I/usr/local/cuda-9.2/include/crt" \
		..

Change ```-j##``` in include the total number of ```icecc``` cores you have available.

    checkinstall --install=no --default --pkgname=caffe2 --pkgversion=0.4.1 --pkgrelease=1 --pkglicense=BSD make -j22 install


Install ```.deb``` as above.


## DEAR PEOPLE FROM THE FUTURE: Here's what we've figured out so far ...

![Wisdom of the Ancients](https://imgs.xkcd.com/comics/wisdom_of_the_ancients.png)

### Error:

>     /usr/include/eigen3/Eigen/Core:42:34: fatal error: math_functions.hpp: No such file or directory
>     #include <math_functions.hpp>
>                                  ^

**Fix**:

    -DCMAKE_C_FLAGS="-I/usr/local/cuda-9.2/include -I/usr/local/cuda-9.2/include/crt" \
    -DCMAKE_CXX_FLAGS="-I/usr/local/cuda-9.2/include -I/usr/local/cuda-9.2/include/crt" \

### Error:

>    [ 74%] Building NVCC (Device) object caffe2/CMakeFiles/caffe2_gpu.dir/sgd/caffe2_gpu_generated_yellowfin_op_gpu.cu.o
>    /pytorch/caffe2/sgd/yellowfin_op.h: In constructor 'caffe2::YellowFinOp<T, Context>::YellowFinOp(const caffe2::OperatorDef&, caffe2::Workspace*)':
>    /pytorch/caffe2/sgd/yellowfin_op.h:20:171: error: 'GetSingleArgument<int>' is not a member of 'caffe2::YellowFinOp<T, Context>'
>    YellowFinOp(const OperatorDef& operator_def, Workspace* ws)
>    /pytorch/caffe2/sgd/yellowfin_op.h:20:259: error: 'GetSingleArgument<int>' is not a member of 'caffe2::YellowFinOp<T, Context>'
>    YellowFinOp(const OperatorDef& operator_def, Workspace* ws)
>    /pytorch/caffe2/sgd/yellowfin_op.h:20:347: error: 'GetSingleArgument<bool>' is not a member of 'caffe2::YellowFinOp<T, Context>'
>     YellowFinOp(const OperatorDef& operator_def, Workspace* ws)
>    CMake Error at caffe2_gpu_generated_yellowfin_op_gpu.cu.o.RELEASE.cmake:281 (message):
>    Error generating file
>    /pytorch/build2/caffe2/CMakeFiles/caffe2_gpu.dir/sgd/./caffe2_gpu_generated_yellowfin_op_gpu.cu.o

**Fix**:

Use GCC 6.

    -DCMAKE_C_COMPILER=`which gcc-6` \
    -DCMAKE_CXX_COMPILER=`which g++-6` \

### Error:

>    /usr/local/cuda-9.2/include/crt/common_functions.h:64:24: error: token ""__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."" is not valid in preprocessor expressions
>    #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."

**Fix**:

    sed --in-place=.bak "s/#define __CUDACC_VER__/\/\/ #define __CUDACC_VER__/" /usr/local/cuda-9.2/include/crt/common_functions.h

###Error:

> ```CUDA_cublas_device_LIBRARY-NOTFOUND```

**Fix**:

  ln -s /usr/local/cuda-10.0/targets/x86_64-linux/lib/libcublas_static.a /usr/local/cuda-10.0/targets/x86_64-linux/lib/libcublas_device.a

# Issues

If it *doesn't* work, open an issue: https://github.com/jed-frey/build_caffe2/issues/new

Attach ```/var/log/nvidia-installer.log```.
