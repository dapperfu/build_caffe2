# Step 2: Install CUDA Drivers.

## Download

All files were downloaded & extracted in [Step 1](01_NVIDIA).

Extra package needed if extracting cuda in a ```chroot```.

    apt-get install -y perl-modules-5.26

## Install CUDA Toolkit

    sh cuda/run_files/cuda-linux.9.2.148-24330188.run -noprompt

### Update ```ldconfig```

Let Linux find the new CUDA libraries:

    echo # CUDA support. > /etc/ld.so.conf.d/cuda.conf
    echo /usr/local/cuda-9.2/lib64 >> /etc/ld.so.conf.d/cuda.conf
    rm /etc/ld.so.cache
    ldconfig

Verify, multiple ```.so``` (shared object (dynamic) library) should show up.

    ldconfig --print-cache | grep "usr/local/cuda"

### Update ```PATH```:


Temporary in the current terminal:

    export PATH="/usr/local/cuda-9.2/bin:$PATH"
    export CUDA_PATH="/usr/local/cuda-9.2"

Permanently in all bash shells:

    echo '# Set PATH so it includes CUDA' >> ~/.bashrc
    echo 'PATH="/usr/local/cuda-9.2/bin:$PATH"' >> ~/.bashrc
    echo 'CUDA_PATH=/usr/local/cuda-9.2' >> ~/.bashrc

## Install CUDA Samples

    sh cuda/run_files/cuda-samples.9.2.148-24330188-linux.run -noprompt -cudaprefix=/usr/local/cuda-9.2

### Build deviceQuery

```deviceQuery``` is a minimal CUDA utility to show your CUDA devices (and if your CUDA is working)

    cd /usr/local/cuda-9.2/samples/1_Utilities/deviceQuery
    make

Run ```deviceQuery```

    # ./deviceQuery 

Output should reflect the GPU(s) you have installed:

    ./deviceQuery Starting...
    
     CUDA Device Query (Runtime API) version (CUDART static linking)
    
    Detected 1 CUDA Capable device(s)
    
    Device 0: "GeForce GTX 960"
      CUDA Driver Version / Runtime Version          9.2 / 9.2
      CUDA Capability Major/Minor version number:    5.2
      Total amount of global memory:                 4041 MBytes (4236902400 bytes)
      ( 8) Multiprocessors, (128) CUDA Cores/MP:     1024 CUDA Cores
      GPU Max Clock rate:                            1240 MHz (1.24 GHz)
      Memory Clock rate:                             3505 Mhz
      Memory Bus Width:                              128-bit
      L2 Cache Size:                                 1048576 bytes
      Maximum Texture Dimension Size (x,y,z)         1D=(65536), 2D=(65536, 65536), 3D=(4096, 4096, 4096)
      Maximum Layered 1D Texture Size, (num) layers  1D=(16384), 2048 layers
      Maximum Layered 2D Texture Size, (num) layers  2D=(16384, 16384), 2048 layers
      Total amount of constant memory:               65536 bytes
      Total amount of shared memory per block:       49152 bytes
      Total number of registers available per block: 65536
      Warp size:                                     32
      Maximum number of threads per multiprocessor:  2048
      Maximum number of threads per block:           1024
      Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
      Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
      Maximum memory pitch:                          2147483647 bytes
      Texture alignment:                             512 bytes
      Concurrent copy and kernel execution:          Yes with 2 copy engine(s)
      Run time limit on kernels:                     Yes
      Integrated GPU sharing Host Memory:            No
      Support host page-locked memory mapping:       Yes
      Alignment requirement for Surfaces:            Yes
      Device has ECC support:                        Disabled
      Device supports Unified Addressing (UVA):      Yes
      Device supports Compute Preemption:            No
      Supports Cooperative Kernel Launch:            No
      Supports MultiDevice Co-op Kernel Launch:      No
      Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
      Compute Mode:
         < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >
    
    deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 9.2, CUDA Runtime Version = 9.2, NumDevs = 1
    Result = PASS


## Install ```cudnn```

> *The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks.*

Download ```cudnn``` from: https://developer.nvidia.com/rdp/cudnn-download

It requires membership of the NVIDIA Developer Program to download.

Extract it to the /usr/local directory. ```/usr/local/cuda``` should be symbolically linked to ```/usr/local/cuda-9.2```:

    tar -xzvf cudnn-9.2-linux-x64-v7.2.1.38.tar.gz -C /usr/local/

Verify that the file was correctly extracted:

    ls /usr/local/cuda-9.2/lib64/libcudnn.so

## Patch ```common_functions.h```

**HACK**: This is a workaround until someone fixes their code base.

    sed --in-place=.bak "s/#define __CUDACC_VER__/\/\/ #define __CUDACC_VER__/" /usr/local/cuda-9.2/include/crt/common_functions.h

Verify that the changes were made:

    diff /usr/local/cuda-9.2/include/crt/common_functions.h /usr/local/cuda-9.2/include/crt/common_functions.h.bak 

>        < // #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."
	---
>        > #define __CUDACC_VER__ "__CUDACC_VER__ is no longer supported.  Use __CUDACC_VER_MAJOR__, __CUDACC_VER_MINOR__, and __CUDACC_VER_BUILD__ instead."

# Issues

If it *doesn't* work, open an issue: https://github.com/jed-frey/build_caffe2/issues/new

Attach ```/var/log/nvidia-installer.log```.
