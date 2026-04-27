# Shared product-level configuration for x86_64 Android TV variants in this family.

# NOTE: use core_64_bit.mk instead of the parent product's core_64_bit_only.mk
# because Katniss is armeabi-v7a-only and must be installable.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/google/atv/products/atv_base.mk)
$(call inherit-product, vendor/lineage/config/common_tv.mk)

# Optional Widevine L3 prebuilts.
$(call inherit-product-if-exists, vendor/google/proprietary/widevine-prebuilt/widevine.mk)

# Optional ARM-on-x86 native bridge prebuilts.
$(call inherit-product-if-exists, \
    vendor/google/proprietary/ndk_translation-prebuilt/libndk_translation.mk)
$(call inherit-product-if-exists, \
    vendor/google/proprietary/ndk_translation-prebuilt/native_bridge_arm_on_x86.mk)

PRODUCT_PACKAGES += \
    boringssl_self_test_vendor \
    maleicacid.tv.tuner_hal-service \
    maleicacid_tuner_hal_vts_config_aidl_v2 \
    maleicacid_tuner_hal_ueventd_rc

PRODUCT_COPY_FILES += \
    external/px4_drv/etc/it930x-firmware.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/it930x-firmware.bin \
    device/maleicacid/virtio_x86_64_tv_grub/px4_drv/init/init.px4_drv.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.px4_drv.rc \
    device/maleicacid/virtio_x86_64_tv_grub/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

PRODUCT_SYSTEM_PROPERTIES += \
    ro.enable.native.bridge.exec=1

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.nativebridge=1

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.enable.native.bridge.exec=1 \
    ro.vendor.enable.native.bridge.exec64=1

# Optional Android TV GApps bundle for x86_64.
GMS_VARIANT := full
$(call inherit-product-if-exists, vendor/gapps_tv/x86_64/x86_64-vendor.mk)
