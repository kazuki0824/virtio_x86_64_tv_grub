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
ACK_DIR="${PX4_KLEAF_ACK_DIR:-${TOP}/out/px4_drv_ack}"
ACK_MANIFEST_BRANCH="${PX4_KLEAF_MANIFEST_BRANCH:-common-android15-6.6}"
KLEAF_BUILD_TARGET="${PX4_KLEAF_BUILD_TARGET:-kernel_x86_64}"
PREBUILT_KERNEL_DIR="${TOP}/kernel/prebuilts/6.6/x86_64"
BOOTSTRAP_INIT="${TOP}/external/kleaf-bootstrap/init.py"
BOOTSTRAP_URL="https://android.googlesource.com/kernel/build/bootstrap/+/refs/heads/main-kernel/init.py?format=TEXT"

if [ ! -d "${TOP}/external/px4_drv" ]; then
  echo "error: missing ${TOP}/external/px4_drv" >&2
  echo "sync px4_drv before building px4_drv.ko" >&2
  exit 1
fi

if [ ! -d "${PREBUILT_KERNEL_DIR}" ]; then
  echo "error: missing ${PREBUILT_KERNEL_DIR}" >&2
  echo "sync the matching x86_64 kernel prebuilts before building px4_drv" >&2
  exit 1
fi

mkdir -p "${ACK_DIR}"
if [ ! -d "${ACK_DIR}/.repo" ]; then
  (
    cd "${ACK_DIR}"
    repo init \
      -u https://android.googlesource.com/kernel/manifest \
      -b "${ACK_MANIFEST_BRANCH}"
  )
fi

(
  cd "${ACK_DIR}"
  repo sync -j"$(nproc)" -c --force-sync
)

if [ ! -x "${ACK_DIR}/tools/bazel" ]; then
  echo "error: ${ACK_DIR} is not a complete ACK/Kleaf workspace: missing tools/bazel" >&2
  echo "current external/kleaf is usually kernel/build only; --kleaf_repo must point at an ACK root" >&2
  exit 1
fi

if [ ! -d "${ACK_DIR}/build/kernel/kleaf" ]; then
  echo "error: ${ACK_DIR} is not a complete ACK/Kleaf workspace: missing build/kernel/kleaf" >&2
  exit 1
fi

rm -rf "${WS}" "${STAGING}"
mkdir -p "${WS}/external" "${STAGING}"
mkdir -p "$(dirname "${OUT_ZIP}")"

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
  --kleaf_repo "${ACK_DIR}" \
  --build_target "${KLEAF_BUILD_TARGET}" \
  --prebuilts_dir "${PREBUILT_KERNEL_DIR}" \
  --nosync

mkdir -p "${WS}/external"
ln -sfn "${TOP}/external/px4_drv" "${WS}/external/px4_drv"

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
