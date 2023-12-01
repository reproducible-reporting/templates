#!/bin/bash
set -e

# This script assumes you have a running and somewhat modern Python environment.
PYTHON3=python3
${PYTHON3} -c 'import sys; assert sys.version_info.major == 3; assert sys.version_info.minor >= 11'

echo "Create the venv"
${PYTHON3} -m venv venv

# Activate
source .envrc
${PYTHON3} -m pip install -U pip

# Install requirements, possibly updated after repository initialization
${PYTHON3} -m pip install -r requirements.txt
