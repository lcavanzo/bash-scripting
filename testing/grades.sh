#!/bin/bash
#Script to evaluate  grades
#Usage: grade.sh student grade

if [ ! $# -eq 2 ] ; then
    echo "You must provide <student> <grade>"
    exit 2
fi

case ${2^^} in  #Parameter expansion is used to  capitalize input
    [A-C]) echo "$1 is a star pupil"
    ;;
    [D])   echo "$1 needs to try a little harder"
    ;;
    [E-F]) echo "$1 could do a lot better next year"
    ;;
    *)     echo "Grade could no be evaluate to $1 $2"
    ;;
esac




