#!/bin/zsh

# This script is intended to be able to download apt packages from the presetup apt package managers
# Set the expected directory if it is not set via env variable
if [[ -z "${BASE_DIR}" ]]; then
    BASE_DIR="$HOME/Documents/debs"
fi
# Make the directory in case it doesn't exist
mkdir -p $BASE_DIR

sudo apt-cache
