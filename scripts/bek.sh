#!/bin/bash
#export PATH=/home/fengchunsong/gcc-linaro-6.1.1-2016.08-x86_64_aarch64-linux-gnu/bin:$PATH
echo $PATH
platform=D05
output_dir=out
mkdir -p ${output_dir}/kernel
mkdir -p ${output_dir}/modules
kernel_dir=$(cd ${output_dir}/kernel; pwd)
kernel_bin=$kernel_dir/arch/arm64/boot/Image
modules_dir=$(cd ${output_dir}/modules; pwd)
echo ">>>>>" $kernel_dir
echo ">>>>>" $kernel_bin
echo ">>>>>" `pwd`
rm $kernel_dir/.config 
./kernel/scripts/kconfig/merge_config.sh -O $kernel_dir -m kernel/arch/arm64/configs/defconfig \
	 kernel/arch/arm64/configs/estuary_defconfig

cp -f $kernel_dir/.config $kernel_dir/.merged.config
#cp dacai.config471  $kernel_dir/.merged.config
make -C kernel O=$kernel_dir ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- KCONFIG_ALLCONFIG=$kernel_dir/.merged.config alldefconfig
make -C kernel O=$kernel_dir ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j40
make -C kernel O=$kernel_dir ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules -j40
make -C kernel O=$kernel_dir ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=$modules_dir 
mkdir -p $modules_fir/lib/firmware
make -C kernel O=$kernel_dir ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_FW_PATH=$modules_dir/lib/firmware

mkdir -p $output_dir/binary 2>/dev/null
cp $kernel_bin $output_dir/binary

cp $kernel_dir/arch/arm64/boot/dts/hisilicon/*.dtb $output_dir/binary/
