#!/bin/bash
set -e

# If you want to install with a Python version that is not your OS's default:
# PYTHON3=/usr/bin/python3.11 ./setup-venv-pip.sh
: "${PYTHON3:=$(which python3)}"

# This script assumes you have a running and somewhat modern Python environment.
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

if [[ -n "${TEMPLATE_DEBUG}" ]]; then
    # Install local development versions of StepUp Core and StepUp RePrep
    echo "Install the development version of the DMP template"
    python -m pip install -e ${TEMPLATE_DEBUG}/stepup-core -e ${TEMPLATE_DEBUG}/stepup-reprep
fi
