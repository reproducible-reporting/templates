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
pip install -U pip -e ../../bibsane -e ../../stepup/stepup-core -e ../../stepup/stepup-reprep
cd latest-draft
stepup -n
cd ..
git init
git add .
pre-commit install
pre-commit run --all
