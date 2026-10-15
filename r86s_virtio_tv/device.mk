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

# The optional local manifest includes the Celadon HDCP SDK source on R86S.
# Stage only its standalone library; the hdcpd binary still depends on
# Celadon's hwc.info endpoint, which the selected HWC3 does not provide.
# Installing hdcpd without that backend would be a nonfunctional second path.
ifneq ($(wildcard hardware/intel/external/media/hdcp/sdk/Android.bp),)
PRODUCT_PACKAGES += libhdcpsdk
endif
