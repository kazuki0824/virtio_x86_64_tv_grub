# R86S sibling product:
# - keep using upstream virtio_x86_64_tv / virtio_x86_64 board assets
# - override only the GRUB menu file path
# - keep the same native bridge configuration as the generic GRUB sibling

include device/virt/virtio_x86_64_tv/BoardConfig.mk

AB_OTA_UPDATER := true
TARGET_BOOT_MANAGER := grub
TARGET_GRUB_ARCH := x86_64-efi
TARGET_GRUB_2ND_ARCH := i386-pc

# Replace only the GRUB menu file for the r86s sibling product.
TARGET_GRUB_BOOT_CONFIGS := \
    device/maleicacid/virtio_x86_64_tv_grub/r86s_virtio_tv/bootmgr/grub/grub-boot.cfg

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
