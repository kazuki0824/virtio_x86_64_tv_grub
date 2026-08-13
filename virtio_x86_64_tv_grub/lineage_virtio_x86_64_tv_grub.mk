# Generic virtio Android TV product that keeps using upstream virtio TV board assets.

$(call inherit-product, device/maleicacid/virtio_x86_64_tv_grub/lineage_x86_64_tv_common.mk)
$(call inherit-product, device/virt/virtio_x86_64_tv/device.mk)

PRODUCT_NAME := lineage_virtio_x86_64_tv_grub
PRODUCT_DEVICE := virtio_x86_64_tv_grub
PRODUCT_BRAND := maleicacid
PRODUCT_MANUFACTURER := kazuki0824
PRODUCT_MODEL := VirtIO x86_64 TV (GRUB disk)

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)

