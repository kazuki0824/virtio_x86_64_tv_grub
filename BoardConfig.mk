# SPDX-FileCopyrightText: The OpenAI Assistant
# SPDX-License-Identifier: Apache-2.0

include device/virt/virtio_x86_64_tv/BoardConfig.mk

AB_OTA_UPDATER := true
TARGET_BOOT_MANAGER := grub
TARGET_GRUB_ARCH := x86_64-efi
TARGET_GRUB_2ND_ARCH := i386-pc
