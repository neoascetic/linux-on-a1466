Linux on A1466
==============

Here I  am trying to build  the most optimized Linux  kernel for MacBook
Air 13''  (A1466), which  I do own,  to squeze all  the juice  from this
wonderful hardware,  by disabling unnecessary drivers  and settings etc.
This repo is only about the kernel config itself, because other stuff is
covered elsewhere. However, I will leave useful links in this README for
curious reader.

## Hardware

Almost all hardware  works fine except for the WiFi  card and webcamera.
The  first  one  is   easily  fixed  by  installing  `broadcom-sta-dkms`
from  non-free  repos.  The  webcamera needs  proprietary  firmware  and
[facetimehd][]  module, nothing  hard either.  However, with  the custom
kernel, special  headers has to  be available for  the the module  to be
built, that's why there is  `CONFIG_VIDEO_SAA7134=m` directive - even we
do not have this piece of hardware, it makes `CONFIG_VIDEOBUF2_DMA_SG=m`
also set, which is a requirement for `facetimehd`.

[facetimehd]: https://github.com/patjak/facetimehd/wiki

## Initramfs and the lack thereof

Since  we know  what  hardware is  inside the  laptop  and what  modules
therefore are required,  we do not really need initramfs  - we can start
the kernel directly, speeding up the  boot process. We just need to give
it a hint through the boot parameters  - where the root FS lies and what
it's type:

```
root=/dev/nvme0n1p3 rootfstype=ext4
```

Instead  of dev  path we  can use  UUIDs, but  I find  this easier  as I
probably won't replace my internal SSD too often.
