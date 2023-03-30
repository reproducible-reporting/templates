#!/bin/bash
set -e
# This script assumes you have a running and somewhat modern Python environment.

PYTHON3=python3

echo "Create the venv"
${PYTHON3} -m venv env

# Update activation scripts with extra variables.
# The deactivation is not patched because that would be too tedious and fragile.
# Just close your terminal when you're done or use micromamba instead of pip.
# See https://github.com/pypa/virtualenv/issues/1124
cat >> env/bin/activate << 'EOL'
export SOURCE_DATE_EPOCH=315532800
export TEXMFHOME="${VIRTUAL_ENV}/../texmf"
EOL

cat >> env/bin/activate.csv << 'EOL'
setenv SOURCE_DATE_EPOCH 315532800
setenv TEXMFHOME "${VIRTUAL_ENV}/../texmf"
EOL

cat >> env/bin/activate.fish << 'EOL'
set -gx SOURCE_DATE_EPOCH 0
set -gx TEXMFHOME "${VIRTUAL_ENV}/../texmf"
EOL

# TODO: env/bin/Activate.ps1

# Activate
source env/bin/activate
${PYTHON3} -m pip install -U pip

# Install requirements, possibly updated after repository initialization
${PYTHON3} -m pip install -r requirements.txt
