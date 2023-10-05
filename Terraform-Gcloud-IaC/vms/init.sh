#!/usr/bin/env bash
set -e

INIT_PROJECT="production-init"
OUTPUT_PREFIX="usep10"
PROJECT_ID="usep10-28361"

source ../../scripts/functions.sh
initv2 "${INIT_PROJECT}" "${OUTPUT_PREFIX}" "${PROJECT_ID}"
