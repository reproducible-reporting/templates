#!/usr/bin/env bash
set -e
# This script is more general than the pip version, but also a bit more heavy-handed.
# Use this in case of (i) non-python dependencies (ii) a system without Python (yet).

# Some of the script below is inspired by the official micromamba installer.
# https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html

# Determine the platform and architecture.
ARCH=$(uname -m)
OS=$(uname)
if [[ "$OS" == "Linux" ]]; then
    PLATFORM="linux"
    if [[ "$ARCH" == "aarch64" ]]; then
        ARCH="aarch64";
    elif [[ $ARCH == "ppc64le" ]]; then
        ARCH="ppc64le";
    else
        ARCH="64";
    fi
fi
if [[ "$OS" == "Darwin" ]]; then
    PLATFORM="osx";
    if [[ "$ARCH" == "arm64" ]]; then
        ARCH="arm64";
    else
        ARCH="64"
    fi
fi

# Install locally
mkdir -p venv/bin
curl -Ls https://micro.mamba.pm/api/micromamba/$PLATFORM-$ARCH/latest | tar -xj -C venv/bin/ --strip-components=1 bin/micromamba

# Write scripts to activate and deactivate properly
cat > venv/bin/activate << 'EOF'
export MAMBA_ROOT_PREFIX=$(dirname $(dirname $BASH_SOURCE))
eval "$(${MAMBA_ROOT_PREFIX}/bin/micromamba shell hook -s posix)"
micromamba activate
hash -r
EOF

# Write a condarc file in the venv
cat > venv/.condarc << 'EOF'
channels:
- conda-forge
EOF

# Create an .envrc for direnv.
cat > .envrc << 'EOF'
export SOURCE_DATE_EPOCH=315532800
export TEXMFHOME="${PWD}/texmf"
source ${PWD}/venv/bin/activate
unset PS1
EOF

# Activate and install
source .envrc
micromamba install -y --file environment.yaml

if [[ -n "${TEMPLATE_DEBUG}" ]]; then
    # Install local development versions of StepUp Core and StepUp RePrep
    echo "Install the development version of the DMP template"
    python -m pip install -e ${TEMPLATE_DEBUG}/stepup-core -e ${TEMPLATE_DEBUG}/stepup-reprep
fi
