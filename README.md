# sc7280-build
Build and boot chromium and upstream kernel on SC7280

## Getting Started

### Pre-requisites

* lz4: Install lz4 using `sudo apt-get install liblz4-tool` or copy lz4 binary from this repo to `/usr/bin`.
* dtc: Install dtc with `sudo apt-get install device-tree-compiler`.
* mkimage: Copy mkimage from this repo to `/usr/bin`.
* vbutil_kernel: Copy vbutil binary from this repo to `/usr/bin` or copy vbutil from chromeos source.
* initrd: Sample initrd is given in this repo, but you can replace default one with your own initrd.
          But it should not be compressed. Decompress the initrd as `gunzip initrd.gz`.

#### Opensource References for above binary files:

* mkbootimg: https://android.googlesource.com/platform/system/tools/mkbootimg/
* mkimage: `sudo apt-get install u-boot-tools` or https://github.com/u-boot/u-boot/blob/master/tools/mkimage.c
* vbutil_kernel: `sudo apt-get install vboot-kernel-utils` or Built from https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/main/futility/cmd_vbutil_kernel.c
* kernel_data_key.vbprivk: https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/main/tests/devkeys/kernel_data_key.vbprivk
* kernel.keyblock: https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/refs/heads/main/tests/devkeys/kernel.keyblock
* bootloader.bin: `dd if=/dev/zero bs=512 count=1 of="bootloader.bin" `

### Build and flash chrome kernel with initrd:

1. Change the kernel source path in `sc7280-build-chrome.sh`
2. Run the sc7180 build script as `sh sc7280-build-chrome.sh`
3. A kernel image `new-sc7280_kern.bin` will be created in configs/ folder

### Build and flash upstream kernel with initrd:

1. Change the kernel source path in `sc7280-build-upstream.sh`
2. Run the sc7180 build script as `sh sc7280-build-upstream.sh`
3. A kernel image `new-sc7280_kern.bin` will be created in configs/ folder

### Unpack ramdisk:

* mkdir tmp
* cd tmp
* cat ../initrd-arm64-sc7280 | cpio -idmV

Now, tmp will show all the initrd files, u can add or remove files.

### Repack ramdisk:

* cd tmp
* find . | cpio -o -H newc > ../initrd-arm64-sc7280
