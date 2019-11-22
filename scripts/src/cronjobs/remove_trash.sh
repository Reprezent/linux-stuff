#! /usr/bin/sh
# Richard "Alex" Riedel
# Script to remove 

trash_folder="$HOME/trash"
find $trash_folder -mtime +2 -type f -delete


