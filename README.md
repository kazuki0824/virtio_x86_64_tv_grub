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

## 永続データの接続

両製品とも、`android_device_maleicacid_androidtv_tools/image/make_disk_image.sh`
で生成した3台のディスクを接続する。

| ゲストデバイス | 用途 | 更新時の扱い |
| --- | --- | --- |
| `vda` | 起動・システム | 新しいイメージに交換 |
| `vdb` | userdata | 既存ディスクを継続使用 |
| `vdc` | metadata用GPTディスク | userdataと対で継続使用 |

`vdc1`のGPT名を`metadata`とし、起動ディスク内の旧metadata領域は
`metadata-unused`に改名する。上流のfstabが参照する
`/dev/block/by-name/metadata`は`vdc1`へ解決される。
この製品で追加するSELinuxラベルは`vdc1`だけに適用する。
`vdc`をGSI用ディスクとして接続する起動構成とは併用できない。

既存環境を移行する際は、VMを停止してuserdataと対応するmetadataを
同時に退避し、旧metadataの内容を新しい`vdc1`へ移す。
空のmetadataを既存userdataと組み合わせて起動してはならない。
ロールバック先にもこのディスク構成への対応が必要になる。
