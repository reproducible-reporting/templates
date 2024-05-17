#!/usr/bin/env bash
# Stop immediately if something does not work.
set -e

# Go one directory up because all archive commands must be executed top-level.
cd ..

# Execute all plans non-interactively in alphabetical order.
# (Make sure this is also the chronological order.)
for d in */; [[ -f plan.py ]] && stepup -n; done

# Create the bundle with the source history and store it in archives.
git bundle create archives/main.bundle -1 main

# Create an inventory and a reproducible zip file with outputs
reprep-make-inventory -i main-inventory.def -o main-inventory.txt
reprep-zip-inventory main-inventory.txt archives/main-latest-with-outputs.zip
