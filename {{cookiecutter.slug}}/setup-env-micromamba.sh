#!/bin/bash
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
mkdir -p env/bin
curl -Ls https://micro.mamba.pm/api/micromamba/$PLATFORM-$ARCH/latest | tar -xj -C env/bin/ --strip-components=1 bin/micromamba

# Write scripts to activate and deactivate properly
cat > env/bin/activate << 'EOL'
export MAMBA_ROOT_PREFIX=$(dirname $(dirname $BASH_SOURCE))
eval "$(${MAMBA_ROOT_PREFIX}/bin/micromamba shell hook -s posix)"
micromamba activate
hash -r
EOL

mkdir -p env/etc/conda/activate.d
cat > env/etc/conda/activate.d/reprep.sh << 'EOL'
export SOURCE_DATE_EPOCH_CONDA_BACKUP="${SOURCE_DATE_EPOCH:-}"
export SOURCE_DATE_EPOCH=315532800
export TEXMFHOME_CONDA_BACKUP=${TEXMFHOME:-}
export TEXMFHOME="${CONDA_PREFIX}/../texmf"
EOL

mkdir -p env/etc/conda/deactivate.d
cat > env/etc/conda/deactivate.d/reprep.sh << 'EOL'
export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH_CONDA_BACKUP:-}"
unset SOURCE_DATE_EPOCH_CONDA_BACKUP
if [ -z $SOURCE_DATE_EPOCH ]; then unset SOURCE_DATE_EPOCH; fi
export TEXMFHOME="${TEXMFHOME_CONDA_BACKUP:-}"
unset TEXMFHOME_CONDA_BACKUP
if [ -z $TEXMFHOME ]; then unset TEXMFHOME; fi
EOL

# Write a condarc file in the env
cat > env/.condarc << 'EOL'
channels:
- conda-forge
EOL

# Activate
source env/bin/activate

# Install some dependencies of RepRepBuild through mamba.
if [ ! -f environment.yaml ]; then
    cat > environment.yaml  << EOL
dependencies:
- python
- watchdog
- numpy
- matplotlib
- latexmk
- pre-commit
- pip:
  - reprepbuild
EOL
fi
micromamba install -y --file environment.yaml
