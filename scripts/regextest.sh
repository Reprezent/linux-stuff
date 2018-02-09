#!/bin/bash
temp=''
if [ -z ${1+temp} ]; then
    echo "usage: regextest test_string"
    exit 1
fi

while true
do
    read INPUT_STRING
    if [ $INPUT_STRING == 'quit' ]; then
        exit 0
    fi
    INPUT_STRING='s/'$INPUT_STRING'/'
    echo $1 | sed -e $INPUT_STRING
done
