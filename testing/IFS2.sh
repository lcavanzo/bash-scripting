#!/bin/bash
IFS=$'\n' #Here we change the default IFS to be a newline
file="file1.txt"
for var in $(cat $file)
do
    echo ${var}
done
