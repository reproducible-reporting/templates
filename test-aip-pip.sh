#!/bin/bash
set -e
cd ..
mkdir -p nobackup
cd nobackup
WORKDIR="aip-pip"
if [ -d "${WORKDIR}" ]; then
    cookiecutter ../templates -f --no-input slug=${WORKDIR} article=aip supp=plain cover=plain
    cd ${WORKDIR}
else
    cookiecutter ../templates --no-input slug=${WORKDIR} article=aip supp=plain cover=plain
    cd ${WORKDIR}
    ./setup-venv-pip.sh
fi
source .envrc
cd latest-draft
STEPUP_DEBUG=1 STEPUP_SYNC_RPC_TIMEOUT=10 stepup
cd ..
git init
git add .
pre-commit install
pre-commit run --all
git commit -a -m "Initial commit"
(cd archives/; ./create_archives.sh)
