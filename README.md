# kazuki0824/virtio_x86_64_tv_grub

この repository は `device/maleicacid/virtio_x86_64_tv_grub` に配置する最小構成です。

含まれるファイル:
- `AndroidProducts.mk`
- `lineage_virtio_x86_64_tv_grub.mk`
- `BoardConfig.mk`

想定手順:
1. local manifest でこの repo を `device/maleicacid/virtio_x86_64_tv_grub` に配置する
2. `source build/envsetup.sh`
3. `vendor/lineage/build/tools/roomservice.py lineage_virtio_x86_64_tv`
4. `breakfast virtio_x86_64_tv_grub`
5. `m diskimage-vda`
