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
3. Replaces only `TARGET_GRUB_BOOT_CONFIGS` with one local GRUB file:
   `device/maleicacid/virtio_x86_64_tv_grub/r86s_virtio_tv/bootmgr/grub/grub-boot.cfg`.

## R86S GRUB file
The local R86S GRUB file is based on the upstream
`device/virt/virtio_x86_64/bootmgr/grub/grub-boot.cfg` content and adds one
new top-level menuentry that uses the same kernel / ramdisk variables and the
same Intel Skylake-and-later Mesa kernel arguments as the upstream advanced
menu entry.

This file is a static GRUB menu file. No local render / staging shell scripts
are required for the design captured in this repository.

## Intel graphics property
`r86s_virtio_tv/device.mk` sets:

`ro.vendor.graphics.gpu=intel`

This is a product-side property choice meant to satisfy the predicate used by
the upstream `virtio_x86_64-graphics.rc` Intel graphics init path.

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
