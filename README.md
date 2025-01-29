Linux on A1466
==============

Here I  am trying to build  the most optimized Linux  kernel for MacBook
Air 13''  (A1466), which  I do own,  to squeze all  the juice  from this
wonderful hardware,  by disabling unnecessary drivers  and settings etc.
This repo  is only  about the  kernel config  itself, because  the other
stuff is covered  elsewhere. However, I will leave useful  links in this
README for a curious reader.

## Hardware

Almost all hardware  works fine except for the WiFi  card and webcamera.
The first  one is  easily fixed  by installing  `broadcom-sta-dkms` from
non-free repos  (Debian). The  webcamera needs proprietary  firmware and
[facetimehd][]  module, nothing  hard either.  However, with  the custom
kernel, special headers has to be  available for the module to be built,
that's why there is `CONFIG_VIDEO_SAA7134=m`  directive - even we do not
have this  piece of hardware, it  makes `CONFIG_VIDEOBUF2_DMA_SG=m` also
set, which is a requirement for `facetimehd`.

[facetimehd]: https://github.com/patjak/facetimehd/wiki

## Initramfs and the lack thereof

Since  we know  what  hardware is  inside the  laptop  and what  modules
therefore are required,  we do not really need initramfs  - we can start
the kernel directly, speeding up the  boot process. We just need to give
it a hint through  the boot parameters - where the root  FS lies and its
type:

```
root=/dev/nvme0n1p3 rootfstype=ext4 resume=/dev/nvme0n1p4
```

Instead  of dev  path we  can use  UUIDs, but  I find  this easier  as I
probably won't replace my internal SSD too often.


## EFIStub

The  kernel  is  compiled  with  EFIStub  support,  meaning  it  can  be
loaded directly  by MacBook's UEFI,  without any  need in GRUB  or other
bootloader. It simply needs to be  placed on EFI partition, for example,
to `/EFI/Linux/vmlinuz`, next to `BOOTX64.CSV` file. This file specifies
loader (the kernel  itself) and also its arguments. In  case you want to
edit this file to add more arguments  etc, remember, that it needs to be
saved as UTF-16. You can use the following command to edit it:

```
vim -c ':e ++enc=utf-16le' BOOTX64.CSV
```
