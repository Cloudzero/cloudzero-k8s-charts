#!/usr/bin/env bash
set -euo pipefail

GIT_REPO_ROOT=$(git rev-parse --show-toplevel)
BUILD_DIR="${GIT_REPO_ROOT}/build"
TOOLS_DIR="${BUILD_DIR}/tools"
STABLE="${GIT_REPO_ROOT}/stable"
export PATH="${TOOLS_DIR}:${PATH}"

FAILED_V3=()

cd ${STABLE}
for d in */; do
    EXTRA_ARGS=""
    if [ -f ${STABLE}/${d}/ci/extra_args ]; then
        EXTRA_ARGS=$(cat ${STABLE}/${d}/ci/extra_args)
    fi
    echo "Validating chart ${d} w/ helm v3"
    helmv3 template ${STABLE}/${d} ${EXTRA_ARGS}| kubeval --strict --ignore-missing-schemas || FAILED_V3+=("${d}")
done

if [[ "${#FAILED_V3[@]}" -eq 0 ]]; then
    echo "All charts passed validations!"
    exit 0
else
    echo "Helm v3:"
    for chart in "${FAILED_V3[@]}"; do
        printf "%40s ❌\n" "$chart"
    done
fi
