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

## 外部永続ディスクの起動契約

両製品は Android 15 / LineageOS 22.1 の GRUB 起動に以下の4ディスクを
使用する。QEMU/libvirt ではこの順序と VirtIO block の接続先を固定する。

| ゲスト | 内容 | 初期化・更新 |
| --- | --- | --- |
| `vda` | EFI / super / misc / boot / vendor_boot / BIOS | 新ビルドに交換 |
| `vdb` | パーティションなしの userdata | 初回作成、以降保持 |
| `vdc` | GPT、`vdc1` が 32 MiB metadata | 初回作成、以降保持 |
| `vdd` | ディスク全体が FAT32 の PERSIST (16 MiB) | 初回 `persist.img` から作成、以降保持 |

`vda` 内の旧 `persist`・`metadata` パーティションは、デプロイ用
イメージの生成時に `persist-unused`・`metadata-unused` に改名する。
旧 `persist` パーティションの FAT32 `PERSIST` ラベルを残してはならない。
この正規化と初期化用イメージの生成は
`android_device_maleicacid_androidtv_tools` が担当する。

`/dev/block/by-name/metadata` は `vdc1`、
`/dev/block/by-name/persist` は `vdd` に解決させる。
`vdb` 全体を userdata に使用する既存の bootconfig は維持する。

R86S の GRUB メニューは共通の `boot_android` を使い、Android 15 の
`vendor_boot` ramdisk fragments と bootconfig を読み込む。共通 GRUB
設定や A/B 制御の実装を置き換えてはならない。

既存 userdata と対応する metadata は同時に移行する。初期状態の
metadata を既存 userdata と組み合わせて起動してはならない。
デプロイ用システムディスクの交換時には、A/B 状態と
Virtual A/B snapshot の整合を別途確認する。
`vdc` はGSI用ディスクとして併用できない。

この製品リポジトリ単体では、ホスト側のイメージ準備や外部
永続ディスクの初回生成は行わない。依存する Android tools PR と
VyOS PR を組み合わせ、全体の接続契約を満たす。
