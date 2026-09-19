# Generic virtio TV GRUB product.
# This sibling intentionally keeps using upstream virtio_x86_64_tv / virtio_x86_64
# board assets, including GRUB menus and kernel fragments.

include device/virt/virtio_x86_64_tv/BoardConfig.mk

AB_OTA_UPDATER := true
TARGET_BOOT_MANAGER := grub
TARGET_GRUB_ARCH := x86_64-efi
TARGET_GRUB_2ND_ARCH := i386-pc

# Native bridge (libndk_translation): arm64 + arm32.
TARGET_NATIVE_BRIDGE_ARCH := arm64
TARGET_NATIVE_BRIDGE_ARCH_VARIANT := armv8-a
TARGET_NATIVE_BRIDGE_CPU_VARIANT := generic
TARGET_NATIVE_BRIDGE_ABI := arm64-v8a

TARGET_NATIVE_BRIDGE_2ND_ARCH := arm
TARGET_NATIVE_BRIDGE_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_NATIVE_BRIDGE_2ND_CPU_VARIANT := generic
TARGET_NATIVE_BRIDGE_2ND_ABI := armeabi-v7a armeabi

TARGET_2ND_CPU_ABI := x86
TARGET_2ND_ARCH := x86
TARGET_2ND_ARCH_VARIANT := x86_64

include vendor/google/proprietary/ndk_translation-prebuilt/board/native_bridge_arm_on_x86.mk

BUILD_BROKEN_DUP_RULES := true

# Build px4_drv as a Lineage external kbuild module against the exact kernel
# source, configuration, output tree, and toolchain used by this product.
TARGET_KERNEL_EXT_MODULE_ROOT := kernel/maleicacid
TARGET_KERNEL_EXT_MODULES += \
    px4_drv:kbuild

# Keep the Earthsoft PT1/PT2 support product-specific. LineageOS 22.1 resolves
# TARGET_KERNEL_CONFIG fragments from arch/x86/configs, so this relative Kbuild
# target points back to the fragment owned by this device repository.
TARGET_KERNEL_CONFIG += \
    ../../../../../../device/maleicacid/virtio_x86_64_tv_grub/virtio_x86_64_tv_grub/configs/kernel/earth_pt1.config

BOARD_VENDOR_SEPOLICY_DIRS += \
    device/maleicacid/virtio_x86_64_tv_grub/virtio_x86_64_tv_grub/sepolicy/vendor \
    vendor/google/proprietary/widevine-prebuilt/sepolicy/gen/gen_common

include vendor/maleicacid/tv/config/BoardConfigVendorSePolicy.mk
