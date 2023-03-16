#!/bin/bash
set -e
# This script assumes you have a running and somewhat modern Python environment.

# Create the venv
python3 -m venv env

# Update activation scripts with extra variables.
# The deactivation is not patched because that would be too tedious and fragile.
# Just close your terminal when you're done or use micromamba instead of pip.
# See https://github.com/pypa/virtualenv/issues/1124
cat >> env/bin/activate << 'EOL'
export SOURCE_DATE_EPOCH=0
export TEXMFHOME="${VIRTUAL_ENV}/../texmf"
EOL

cat >> env/bin/activate.csv << 'EOL'
setenv SOURCE_DATE_EPOCH 0
setenv TEXMFHOME "${VIRTUAL_ENV}/../texmf"
EOL

cat >> env/bin/activate.fish << 'EOL'
set -gx SOURCE_DATE_EPOCH 0
set -gx TEXMFHOME "${VIRTUAL_ENV}/../texmf"
EOL

# TODO: env/bin/Activate.ps1

# Activate
source env/bin/activate
pip install -U pip

# Mandatory requirements for the template the work.
if [ ! -f requirements.txt ]; then
    cat > requirements.txt  << EOL
numpy
matplotlib
reprepbuild
EOL
fi

# Install requirements, possibly updated after repository initialization
python3 -m pip install -r requirements.txt
