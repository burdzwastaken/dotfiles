#!/bin/bash

set -euo pipefail

die() {
    echo "$@" >&2
    exit 1
}

ROOT=$(cd "$(dirname "$(dirname "$0")")" && pwd)

cd "$ROOT"

CURRENTVERSION=${1:-}
NEWVERSION=${2:-}

if [[ -z "${CURRENTVERSION}" ]] || [[ -z "${NEWVERSION}" ]]; then
    die "$0 <currentversion> <newversion>"
fi

find "$ROOT" -type f -exec sed -i -e "s/v${CURRENTVERSION}/v${NEWVERSION}/g" {} \;
