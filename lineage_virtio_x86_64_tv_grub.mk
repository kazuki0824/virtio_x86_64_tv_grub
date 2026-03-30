# SPDX-FileCopyrightText: The OpenAI Assistant
# SPDX-License-Identifier: Apache-2.0

# Inherit from those products. Most specific first.
# NOTE: use core_64_bit.mk instead of the parent product's core_64_bit_only.mk
# because Katniss is armeabi-v7a-only and must be installable.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/google/atv/products/atv_base.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_tv.mk)

# Inherit from device
$(call inherit-product, device/virt/virtio_x86_64_tv/device.mk)

# Widevine L3
$(call inherit-product-if-exists, vendor/google/proprietary/widevine-prebuilt/widevine.mk)

# libhoudini / native bridge
WITH_NATIVE_BRIDGE := true

PRODUCT_PACKAGES += \
    houdini

PRODUCT_SYSTEM_PROPERTIES += \
    ro.dalvik.vm.isa.arm=x86 \
    ro.enable.native.bridge.exec=1 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.enable.native.bridge.exec64=1 \
    ro.dalvik.vm.native.bridge=libhoudini.so

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.enable.native.bridge.exec=1 \
    ro.vendor.enable.native.bridge.exec64=1

# WayDroid-ATV GApps for Android TV x86_64
GMS_VARIANT := full
$(call inherit-product-if-exists, vendor/gapps_tv/x86_64/x86_64-vendor.mk)

PRODUCT_NAME := lineage_virtio_x86_64_tv_grub
PRODUCT_DEVICE := virtio_x86_64_tv_grub
PRODUCT_BRAND := maleicacid
PRODUCT_MANUFACTURER := kazuki0824
PRODUCT_MODEL := VirtIO x86_64 TV (GRUB disk)

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

# Workaround build fingerprint too long
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="virtio_x86_64_tv-eng 14 AP2A.240705.005 0 test-keys"

BUILD_FINGERPRINT := virtio/virtio_x86_64_tv/virtio_x86_64_tv:14/AP2A.240705.005/0:eng/test-keys
