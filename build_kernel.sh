#!/bin/bash
#设置环境

# 交叉编译器路径
export PATH=$PATH:/home/coconutat/github/proton-clang-master/bin
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export CONFIG_BUILD_ARM64_DT_OVERLAY=y

export ARCH=arm64
export SUBARCH=arm64
# export DTC_EXT=dtc

if [ ! -d "out" ]; then
	mkdir out
fi

start_time=$(date +%Y.%m.%d-%I:%M)

make ARCH=arm64 O=out CC=clang ursa_lineageos_ksu_defconfig
# 定义编译线程数
make ARCH=arm64 O=out CC=clang -j8 2>&1 | tee kernel_log-${start_time}.txt

end_time=$(date +%Y.%m.%d-%I:%M)

# 将时间戳转换为秒数（Unix 纪元时间戳）
start_timestamp=$(date -d "${start_time}" +%s)
end_timestamp=$(date -d "${end_time}" +%s)

# 计算运行时间（秒）
duration=$((end_timestamp - start_timestamp))

echo "编译运行时间为：${duration} 秒"

if [ -f out/arch/arm64/boot/Image.gz-dtb ]; then
	echo "***Packing kernel...***"
	cp out/arch/arm64/boot/Image.gz tools/AnyKernel3/Image.gz
	cp out/arch/arm64/boot/Image.gz-dtb tools/AnyKernel3/Image.gz-dtb
	cd tools/AnyKernel3
	zip -r9 Mi8_ursa_LOS20_Kernel-${end_time}.zip * > /dev/null
	cd ../..
	mv tools/AnyKernel3/Mi8_ursa_LOS20_Kernel-${end_time}.zip Mi8_ursa_LOS20_Kernel-${end_time}.zip
	rm -rf tools/AnyKernel3/Image.gz
	rm -rf tools/AnyKernel3/Image.gz-dtb
	echo " "
	echo "***Sucessfully built kernel...***"
	echo " "
	exit 0
else
	echo " "
	echo "***Failed!***"
	exit 0
fi