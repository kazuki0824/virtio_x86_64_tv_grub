# R86S-oriented virtio Android TV product.

$(call inherit-product, device/maleicacid/virtio_x86_64_tv_grub/lineage_x86_64_tv_common.mk)
$(call inherit-product, device/maleicacid/virtio_x86_64_tv_grub/r86s_virtio_tv/device.mk)

PRODUCT_NAME := lineage_r86s_virtio_tv
PRODUCT_DEVICE := r86s_virtio_tv
PRODUCT_BRAND := maleicacid
PRODUCT_MANUFACTURER := kazuki0824
PRODUCT_MODEL := R86S Android TV

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="r86s_virtio_tv-eng 14 AP2A.240705.005 0 test-keys"

BUILD_FINGERPRINT := \
    maleicacid/r86s_virtio_tv/r86s_virtio_tv:14/AP2A.240705.005/0:eng/test-keys
