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
