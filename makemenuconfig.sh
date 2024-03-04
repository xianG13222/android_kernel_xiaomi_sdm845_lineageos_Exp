#!/bin/bash
#设置环境

# 交叉编译器路径
export PATH=$PATH:$(pwd)/../Compiler/Proton-Clang/bin
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

export ARCH=arm64
# export DTC_EXT=dtc

make ARCH=arm64 O=out CC=clang polaris_defconfig
make ARCH=arm64 O=out CC=clang menuconfig
