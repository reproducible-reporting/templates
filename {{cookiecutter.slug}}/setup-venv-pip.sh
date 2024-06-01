#!/bin/bash
set -e

# This script assumes you have a running and somewhat modern Python environment.
: "${PYTHON3:=$(which python3)}"
${PYTHON3} -c 'import sys; assert sys.version_info.major == 3; assert sys.version_info.minor >= 11'

echo "Create the venv"
${PYTHON3} -m venv venv

# Create an .envrc for direnv.
cat > .envrc << 'EOL'
export SOURCE_DATE_EPOCH=315532800
export TEXMFHOME="${PWD}/texmf"
source ${PWD}/venv/bin/activate
unset PS1
EOL

# Activate and update installer tools
source .envrc
pip install -U pip pip-tools

# Install requirements
pip-compile requirements.in
pip-sync
