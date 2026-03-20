#!/usr/bin/env bash
set -euo pipefail

# Create a Python 3 virtual environment under dependency/venv
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEP_DIR="${ROOT_DIR}/dependency"
VENV_DIR="${DEP_DIR}/py3venv"

mkdir -p "${DEP_DIR}"
python3 -m venv "${VENV_DIR}"

printf "Created Python venv at %s\n" "${VENV_DIR}"

"${VENV_DIR}/bin/pip3" install --upgrade pip
"${VENV_DIR}/bin/pip3" install pytest pytest-html
