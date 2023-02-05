#!/bin/zsh

# Dl clean moves respective files to its proper location

for file in ~/Downloads/*(.); do
    if [[ $file =~ "*.deb" ]]; then
        mv $file "~/Documents/debs"
    done
done
