#!/bin/bash

# prompt something 
echo -n "Hello $(basename $0)!! May I ask your name: "
read

echo "Hello $REPLY"

# the -n option followed by an integer, we can specify the number of 
 #characters to accept before continuing and -s hides the output text
 # it is useful when we need to introduce passwords
echo
read -sn1 -p "Press any key to continue"
echo 

# prompt and store the variable in one line
## read -p <prompt> <variable name>
read -p "Put your last Name: " name
echo "Hi ${name}"


exit 0

