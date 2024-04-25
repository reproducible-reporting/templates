#!/bin/bash
set -e
cd ..
mkdir -p nobackup
cd nobackup
WORKDIR="acs-ugent-micromamba"
if [ -d "${WORKDIR}" ]; then
    cookiecutter ../templates -f --no-input slug=${WORKDIR} article=acs supp=acs cover=ugent env=micromamba
    cd ${WORKDIR}
else
    cookiecutter ../templates --no-input slug=${WORKDIR} article=acs supp=acs cover=ugent env=micromamba
    cd ${WORKDIR}
    ./setup-venv-micromamba.sh
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
