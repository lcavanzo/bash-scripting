#!/bin/bash

if [ -z $1 ] ; then
    echo -e "${RED}usage :${RESET} $0 <name's>"
    exit 2
fi

for user in $* ; do
    echo "Hello $user"
done
exit 0
