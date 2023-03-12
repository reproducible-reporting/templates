#!/bin/bash
set -e
cd ..
mkdir -p nobackup
cd nobackup
WORKDIR="plain-pip"
if [ -d "${WORKDIR}" ]; then
    cookiecutter ../templates -f --no-input slug=${WORKDIR} article=plain cover=plain env=pip
    cd ${WORKDIR}
else
    cookiecutter ../templates --no-input slug=${WORKDIR} article=plain cover=plain env=pip
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
