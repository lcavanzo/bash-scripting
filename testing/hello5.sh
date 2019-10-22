#!/bin/bash
source snippets/colors
if [ $# -lt 1 ] ; then
    echo -e "${RED}Usage:${RESET} $0 <name>"
    exit 1
fi

echo -e "${GREEN}Hello ${RESET}$1"
exit 0

