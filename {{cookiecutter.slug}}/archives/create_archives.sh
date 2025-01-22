#!/usr/bin/env bash
# Stop immediately if something does not work.
set -e

# Go one directory up because all archive commands must be executed top-level.
cd ..

# Execute all plans non-interactively in alphabetical order.
# (Make sure this is also the chronological order.)
for d in */; do (cd $d && if [[ -f plan.py ]]; then stepup; fi); done

# Create the bundle with the source history and store it in archives.
git bundle create archives/main.bundle main

# Create an inventory and a reproducible zip file with outputs
reprep-make-inventory -i main-inventory.def -o main-inventory.txt
reprep-zip-inventory main-inventory.txt archives/main-latest-with-outputs.zip

# Make a final inventory file of the archived data
cd archives
reprep-make-inventory -o main-archive-inventory.txt README.md main.bundle main-latest-with-outputs.zip
