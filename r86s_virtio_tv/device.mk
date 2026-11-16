# R86S sibling product:
# - reuse upstream virtio_x86_64_tv device configuration
# - install one local vendor audio policy file
# - set the product property used by the upstream Intel graphics init path

$(call inherit-product, device/virt/virtio_x86_64_tv/device.mk)

DEVICE_PRODUCT_PATH := device/maleicacid/virtio_x86_64_tv_grub/r86s_virtio_tv

PRODUCT_COPY_FILES += \
    $(DEVICE_PRODUCT_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PRODUCT_PATH)

# Upstream virtio_x86_64-graphics.rc selects the native i915 path only when
# ro.vendor.graphics.gpu=i915. "intel" does not match that predicate.
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.graphics.gpu=i915

# Widevine L3 is integrated independently of physical HDMI HDCP.
# Celadon's SDK/daemon is not packaged in this source-only draft: its HWC2
# libhwcservice bridge has not yet been adapted to the HWC3-owned DRM/KMS path.
# This is NOT evidence that hdcpd/libhdcpsdk are inherently unnecessary.
# Do not enable an HWC2 HAL, HWC2-to-HWC3 adapter, or second DRM-master HWC.
