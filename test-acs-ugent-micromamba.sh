#!/bin/bash
set -e
cd ..
mkdir -p nobackup
cd nobackup
WORKDIR="acs-ugent-micromamba"
if [ -d "${WORKDIR}" ]; then
    cookiecutter ../templates -f --no-input slug=${WORKDIR} article=acs cover=ugent env=micromamba
    cd ${WORKDIR}
else
    cookiecutter ../templates --no-input slug=${WORKDIR} article=acs cover=ugent env=micromamba
    cd ${WORKDIR}
    ./setup-env.sh
fi
source env/bin/activate
cd latest-draft
rr
cd ..
git init
git add .
pre-commit install
pre-commit run --all
