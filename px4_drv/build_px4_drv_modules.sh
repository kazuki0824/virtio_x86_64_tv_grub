#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <gen_dir> <out_zip>" >&2
  exit 1
fi

GEN_DIR="$1"
OUT_ZIP="$(realpath -m "$2")"

TOP="$(pwd)"
WS="${GEN_DIR}/ddk_ws"
STAGING="${GEN_DIR}/staging"
KLEAF_DIR="${TOP}/external/kleaf"
PREBUILT_KERNEL_DIR="${TOP}/kernel/prebuilts/6.6/x86_64"
BAZEL="${TOP}/build/bazel/bin/bazel"
TEMPLATE="${TOP}/device/maleicacid/virtio_x86_64_tv_grub/px4_drv/ddk/MODULE.bazel.template"

rm -rf "${WS}" "${STAGING}"
mkdir -p "${WS}/external" "${STAGING}"
mkdir -p "$(dirname "${OUT_ZIP}")"

ln -s "${TOP}/external/px4_drv" "${WS}/external/px4_drv"

sed \
  -e "s|__KLEAF_DIR__|${KLEAF_DIR}|g" \
  -e "s|__PREBUILT_KERNEL_DIR__|${PREBUILT_KERNEL_DIR}|g" \
  "${TEMPLATE}" > "${WS}/MODULE.bazel"

: > "${WS}/WORKSPACE.bazel"

(
  cd "${WS}"
  "${BAZEL}" build //external/px4_drv:px4_drv
)

cp -f "${WS}/bazel-bin/external/px4_drv/px4_drv.ko" "${STAGING}/px4_drv.ko"

(
  cd "${STAGING}"
  zip -qry "${OUT_ZIP}" .
)
