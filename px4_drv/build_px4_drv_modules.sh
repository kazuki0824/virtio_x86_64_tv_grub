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
BOOTSTRAP_INIT="${TOP}/external/kleaf-bootstrap/init.py"
BOOTSTRAP_URL="https://android.googlesource.com/kernel/build/bootstrap/+/refs/heads/main-kernel/init.py?format=TEXT"

if [ ! -d "${KLEAF_DIR}" ]; then
  echo "error: missing ${KLEAF_DIR}" >&2
  echo "sync kernel/build to external/kleaf before building px4_drv" >&2
  exit 1
fi

if [ ! -d "${PREBUILT_KERNEL_DIR}" ]; then
  echo "error: missing ${PREBUILT_KERNEL_DIR}" >&2
  echo "sync the matching x86_64 kernel prebuilts before building px4_drv" >&2
  exit 1
fi

rm -rf "${WS}" "${STAGING}"
mkdir -p "${WS}/external" "${WS}/prebuilts" "${STAGING}"
mkdir -p "$(dirname "${OUT_ZIP}")"

# The Kleaf DDK bootstrap expects local sources at these canonical workspace
# paths. Keep them as symlinks inside the generated workspace; do not modify
# external/kleaf itself.
ln -s "${TOP}/external/px4_drv" "${WS}/external/px4_drv"
ln -s "${KLEAF_DIR}" "${WS}/external/kleaf"
ln -s "${PREBUILT_KERNEL_DIR}" "${WS}/prebuilts/kernel"

if [ -f "${BOOTSTRAP_INIT}" ]; then
  INIT_PY="${BOOTSTRAP_INIT}"
else
  INIT_PY="${GEN_DIR}/kleaf_bootstrap_init.py"
  mkdir -p "${GEN_DIR}"
  curl -fsSL "${BOOTSTRAP_URL}" | base64 --decode > "${INIT_PY}"
fi

python3 "${INIT_PY}" \
  --local \
  --ddk_workspace "${WS}" \
  --kleaf_repo "${WS}/external/kleaf" \
  --prebuilts_dir "${WS}/prebuilts/kernel" \
  --nosync

# Allow the generated DDK workspace to resolve Kleaf's transitive Bzlmod
# dependencies when they are not vendored locally.
printf '\ncommon --config=internet\n' >> "${WS}/device.bazelrc"

(
  cd "${WS}"
  "${WS}/tools/bazel" build //external/px4_drv:px4_drv
)

cp -f "${WS}/bazel-bin/external/px4_drv/px4_drv.ko" "${STAGING}/px4_drv.ko"

(
  cd "${STAGING}"
  zip -qry "${OUT_ZIP}" .
)
