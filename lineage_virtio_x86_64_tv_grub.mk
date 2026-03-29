# SPDX-FileCopyrightText: The OpenAI Assistant
# SPDX-License-Identifier: Apache-2.0

$(call inherit-product, device/virt/virtio_x86_64_tv/lineage_virtio_x86_64_tv.mk)

ANDROID_USE_WIDEVINE := true
ifeq ($(ANDROID_USE_WIDEVINE),true)
$(call inherit-product-if-exists, vendor/google/proprietary/widevine-prebuilt/widevine.mk)
endif

# libhoudini / native bridge
WITH_NATIVE_BRIDGE := true

PRODUCT_PACKAGES += \
    houdini

PRODUCT_SYSTEM_PROPERTIES += \
    ro.dalvik.vm.isa.arm=x86 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.dalvik.vm.native.bridge=libhoudini.so \
    ro.enable.native.bridge.exec=1 \
    ro.enable.native.bridge.exec64=1

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.enable.native.bridge.exec=1 \
    ro.vendor.enable.native.bridge.exec64=1

PRODUCT_SYSTEM_PROPERTIES += \
    service.adb.tcp.port=5555 \
    persist.adb.tcp.port=5555

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb
    
# WayDroid-ATV GApps for Android TV x86_64
GMS_VARIANT := full
$(call inherit-product-if-exists, vendor/gapps_tv/x86_64/x86_64-vendor.mk)

PRODUCT_NAME := lineage_virtio_x86_64_tv_grub
PRODUCT_DEVICE := virtio_x86_64_tv_grub
PRODUCT_MODEL := VirtIO x86_64 TV (GRUB disk)

PRODUCT_BRAND := maleicacid
PRODUCT_MANUFACTURER := kazuki0824
