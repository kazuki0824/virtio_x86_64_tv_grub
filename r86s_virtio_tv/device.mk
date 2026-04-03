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

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.graphics.gpu=intel
