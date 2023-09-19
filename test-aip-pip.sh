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
pip install -e ../../bibsane
pip install -e ../../reprepbuild
cd latest-draft
rr -v -d explain
cd ..
git init
git add .
pre-commit install
pre-commit run --all
