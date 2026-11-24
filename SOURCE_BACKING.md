# Source backing and non-guarantees

This repository layout intentionally keeps the generic sibling on upstream
`device/virt/virtio_x86_64_tv` / `device/virt/virtio_x86_64` board assets.

## Generic sibling (`lineage_virtio_x86_64_tv_grub`)
The generic sibling does not vendor-copy upstream:
- GRUB menus
- kernel fragment paths
- `sepolicy/vendor`
- `vm_templates/utm`

That is deliberate for this repository layout: the generic sibling is intended
to keep using the upstream board assets directly.

## R86S sibling (`lineage_r86s_virtio_tv`)
The R86S sibling does three concrete things in-tree:

1. Reuses upstream `device/virt/virtio_x86_64_tv/device.mk`.
2. Reuses upstream `device/virt/virtio_x86_64_tv/BoardConfig.mk`.
3. Uses upstream `virt-common` GRUB boot functions and recovery support,
   a product-local `virtio-common` diagnostic menu with the GSI-vdc option
   removed, and the R86S Intel menu.

## R86S GRUB files
`grub-virtio-common.cfg` retains the upstream headless/Swiftshader/Mesa,
GSI-from-sda, and serial diagnostic options. GSI-from-vdc is excluded
because this product uses guest vdc1 for persistent metadata.

`grub-boot.cfg` adds the R86S Intel/Swiftshader entries using the common
`boot_android` function to load boot + vendor_boot fragments and bootconfig
with common A/B slot handling. We intentionally omit the generic x86_64
Intel submenu to avoid duplicating the R86S alternatives.

The default R86S Intel menu is selected on a fresh configuration, while
recovery, bootloader and saved explicit menu settings remain authoritative.

## Intel graphics property
`r86s_virtio_tv/device.mk` sets:

`ro.vendor.graphics.gpu=i915`

The GRUB Intel menu also passes `androidboot.gpu=i915`. These match the
unmodified upstream LineageOS 22.1 `virtio_x86_64-graphics.rc` predicate.
This corrects a pre-existing mismatch and does not prove GPU runtime behavior.

## Audio policy file
`r86s_virtio_tv/audio/audio_policy_configuration.xml` is a product-side audio
policy file. Its structure follows the AOSP audio policy XML format, and its
HDMI device naming is intentionally aligned with published AOSP-style examples
that use HDMI / AUX_DIGITAL style outputs.

What is implemented here:
- a vendor audio policy file is installed by the product
- that file prefers an HDMI-class output as `defaultOutputDevice`

What is **not** claimed here:
- runtime success with a specific audio HAL implementation
- proof that HDMI audio passthrough works on every host / guest combination
- proof that this file alone satisfies requirement 8 at runtime

In other words, the file is an in-repository implementation of a product
policy choice, not a runtime success certificate.
