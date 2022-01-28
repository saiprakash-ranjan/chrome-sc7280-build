#!/bin/sh

KERNEL=kernel_source_path # Add ur src path
if [ ! -d "$KERNEL" ]; then
  echo "Specify the kernel src path"
  exit 1
fi

ITS_SCRIPT="${KERNEL}/its_script-sc7280"
CONFIGS="${PWD}/configs"
KERNEL_BIN="${CONFIGS}/vmlinuz"
IMAGE="${KERNEL}/arch/arm64/boot/Image"

cp "${PWD}/its_script-sc7280" ${KERNEL}
cp "${PWD}/initrd-arm64-sc7280" ${KERNEL}

compress_kernel() {
    local image_name=$1

    lz4 -20 -z -f "${image_name}" \
        "${image_name}.lz4" || exit 1
    echo "${image_name}.lz4"
}

cd $KERNEL
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
./chromeos/scripts/prepareconfig chromiumos-qualcomm
make olddefconfig
./chromeos/scripts/kernelconfig olddefconfig
make Image.gz -j16
make dtbs -j16

compress_kernel "${IMAGE}"

mkimage -D "-I dts -O dtb -p 2048" -f "${ITS_SCRIPT}" "${KERNEL_BIN}" || exit 1

vbutil_kernel --pack ${CONFIGS}/new-sc7280_kern.bin \
    --keyblock ${CONFIGS}/kernel.keyblock \
    --signprivate ${CONFIGS}/kernel_data_key.vbprivk \
    --version 1 \
    --config ${CONFIGS}/config.txt \
    --bootloader ${CONFIGS}/bootloader.bin \
    --vmlinuz "${CONFIGS}/vmlinuz" \
    --arch "arm"

rm -rf "${KERNEL}/initrd-arm64-sc7280"
rm -rf "${KERNEL}/its_script-sc7280"

exit 0
