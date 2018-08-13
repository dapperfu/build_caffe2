# Step 1: Install Nvidia Drivers.

## Download

### Option A: Website

Go to the CUDA Toolkit 9.2 Download Website: [Link](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1710&target_type=runfilelocal).

If not taken directly to download link:

- Operating System: Linux
- Architecture: x86_64
- Distribution: Ubuntu
- Version: 17.04
- Installer Type: runfile (local)

### Option B: Command Line

Download links directly with ```wget```:

    wget --continue https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
l
If the download gets interrupted, just re-run the command. ```--continue``` will resume where it left off.

## Stop X.

After this you will need to be comfortable continuing over SSH or via the command line without X.

Base Ubuntu uses GDM:

    systemctl stop gdm

Most flavors use LightDM:

    systemctl stop lightdm

## Extract Installer

**¡¡HACK!!** Due to lack of official NVIDIA support for 18.04.

The above files are built with [```Makeself```](https://makeself.io/), a self-extracting archiving tool for Unix systems, in 100% shell script.

Extracting the full compiler gives you access to each individual installer (NVIDIA Driver, CUDA Toolkit, CUDA Samples) and goes around some checks NVIDIA put for 'incompatible versions'.

    sh cuda_*_linux --noexec --target cuda/

## Run Installer.

    sh cuda/run_files/NVIDIA-Linux-*.run --expert --no-questions --ui=none --no-nouveau-check --disable-nouveau --run-nvidia-xconfig --dkms

Command flag, documentation (in italics), explanation of use after.

- ```--expert```: *Enable 'expert' installation mode; more detailed questions will be asked, and more verbose output will be printed.* Makes debugging easier.
- ```--no-questions```: *Do not ask any questions; the default is assumed.* Makes it easier use.
- ```--ui=none```: *A simple printf/scanf interface will be used.s* Makes debugging easier.
- ```--no-nouveau-check```: *Normally, nvidia-installer aborts installation if the nouveau kernel driver is in use.  Use this option to disable this check*. By default Ubuntu uses [```nouveau```](https://nouveau.freedesktop.org/wiki/). Skipping this check avoids extra reboots.
- ```--disable-nouveau```: *Attempt to disable nouveau.* Blacklist nouveau from loading.
- ```--run-nvidia-xconfig```: This will update the system X configuration file so that the NVIDIA X driver is used. 
- ```--dkms```: This will allow the DKMS infrastructure to automatically build a new kernel module when changing kernels.

If everything is successfull you should see this:

> -> Your X configuration file has been successfully updated.  Installation of the NVIDIA Accelerated Graphics Driver for Linux-x86_64 (version: 396.37) is now complete.

Reboot. You should now be using the ```nvidia``` driver. To check this open a terminal *after reboot* and run:

    lsmod | grep nvidia

Proceed to [02_CUDA](02_CUDA.md).

# Issues

If it *doesn't* work, open an issue: https://github.com/jed-frey/build_caffe2/issues/new

Attach ```/var/log/nvidia-installer.log```.
