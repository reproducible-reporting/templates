#!/bin/bash
set -e
# This script assumes you have a running and somewhat modern Python environment.

echo "Create the venv"
python3 -m venv env

echo "Download and install latexmk"
python3 -c "import zipfile, urllib.request, io; blob_zip = urllib.request.urlopen('https://mirrors.ctan.org/support/latexmk.zip').read(); blob_pl = zipfile.ZipFile(io.BytesIO(blob_zip)).open('latexmk/latexmk.pl').read(); open('env/bin/latexmk', 'wb').write(blob_pl)"
chmod +x env/bin/latexmk

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
pip install -U pip

# Mandatory requirements for the template the work.
if [ ! -f requirements.txt ]; then
    cat > requirements.txt  << EOL
pre-commit
numpy
matplotlib
reprepbuild
# -e ../../reprepbuild
EOL
fi

# Install requirements, possibly updated after repository initialization
python3 -m pip install -r requirements.txt
