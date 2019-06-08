#!/bin/bash 
my_func () {
    myarr=$@
    echo "The array from inside the function: ${myarr[*]}"
}

test_arr=(1 2 3)
echo "The original array is ${test_arr[*]}"
my_func ${test_arr[*]}
