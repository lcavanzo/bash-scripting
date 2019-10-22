#!/bin/bash

#########################################################################
# ANSIcolor -- Use these variables to make output in different colors
#   and formats. Color names that end with 'f' are foregorunds colors,
#   and those ending with 'b' are background colors.

ANSIcolors()
{
    esc="\e" #If doesn't work, enter an ESC directly

    # Foreground colors
    blackf="${esc}[30m";    yellowf="${esc}[33m"    cyanf="${esc}[36m";
    redf="${esc}[31m";      bluef="${esc}[34m";     whitef="${esc}[37m"
    greenf="${esc}[32m"     purplef="${esc}[35m"

    # Background colors
    blackb="${esc}[40m";    yellowb="${esc}[43m"    cyanb="${esc}[46m";
    redb="${esc}[41m";      blueb="${esc}[44m";     whiteb="${esc}[47m"
    greenb="${esc}[42m"     purpleb="${esc}[45m"    

    # Bold, italic, underline, and inverse style toggles
    boldon="${esc}[1m";     boldoff="${esc}[22m"    italicson="${esc}[3m"; 
    italicsoff="${esc}[23m" ulon="${esc}[4m";       uloff="${esc}[24m"
    invon="${esc}[7m";      invoff="${esc}[27m"

    reset="${esc}[0m"
}


#########################################################################

# echon -- doing a friendly echo command
echon()
{
    echo -e "$*" | tr -d '\n'
}

#########################################################################

# validInt -- Validates integer input, allowing negative integers too

validInt()
{
    # Validate first field and test that value against min value $2 and/or 
    #   max value $3 if they are suplied. If the value isn't within range
    #   or it's not composed of just digits, fail.
    number="$1"
    min="$2"
    max="$3"

    if [ -z $number ] ; then
        echo "You didn't enter anything. Please enter a number." >&2
        return 1
    fi

    # Is the first character a '-' sign?
    if [ "${number%${number#?}}" = "-" ] ; then
        testValue="${number#?}" # Grab all but the first character to test
    else
        testValue="$number"
    fi

    # Create a version of the number that has no digits for testing.
    nodigits="$(echo $testValue | sed 's/[[:digit:]]//g')"

    # Check for nondigits characters.
    if [ ! -z $nodigits ] ; then
        echo "Invalid number format! Only digits, no commas, spaces, etc" >&2
        return 1
    fi

    if [ ! -z $min ] ; then
        # Is the input less than the minimum value?
        if [ "$number" -lt "$min" ] ; then
            echo "Your value is too small: smallest acceptable 
                value is $min" >&2
            return 1
        fi
    fi

    if [ ! -z $max ] ; then
        # Is the input greater than the maximum value?
        if [ "$number" -gt "$max" ] ; then
            echo "Your value is too big: largest acceptabe value
                is $max" >&2
            return 1
        fi
    fi  
    return 0
}

#########################################################################

# checkForCmdInPath - Verifies that a specified program is  either valid as is 
#   or can be found in the PATH directory list

in_path()
{
    # Given a commant and the PATH, tries to find the command. Returns 0
    #   if found and executable; 1 if not, Note that temporarily modifies 
    #   the IFS (internal field separator) but restores it upon completion.

    cmd=$1
    ourpath=$2
    result=1
    oldIFS=$IFS
    IFS=":"
    for directory in $ourpath
    do
        if [ -x $directory/$cmd ] ; then
            result=0    # If we're here, we found the command
        fi
    done

    IFS=$oldIFS
    return $result
}

checkForCmdInPath()
{
    var=$1
    if [ "$var" != "" ] ; then
        if [ "${var:0:1}" = "/" ] ; then
            if [ ! -x $var ] ; then
                return 1
            fi
        elif ! in_path $var "$PATH" ; then
            return 2
        fi
    fi
}


#########################################################################

# valid-date -- Validates a date, taking into account leap year rules

exceedsDayInMonth()
{
    # Given a month name and day number in that month, this function will
    #   return 0 if the specified day value is less than or equal to the
    #   max days in the month; otherwise 1.

    case $(echo $1 | tr '[:upper:]' '[:lower:]') in
        jan* ) days=31  ;;      feb* )  days=28     ;;
        mar* ) days=31  ;;      apr* )  days=30     ;;
        may* ) days=31  ;;      jun* )  days=30     ;;
        jul* ) days=31  ;;      aug* )  days=31     ;;
        sep* ) days=30  ;;      oct* )  days=31     ;;
        nov* ) days=30  ;;      dec* )  days=31     ;;
           * ) echo "$(basename $0): Unknown month $1" >&2
               exit 1
    esac
    if [ $2 -lt 1 -o $2 -gt $days ] ;then
        return 1
    else
        return 0 # the day number is valid
    fi
}

isLeapYear()
{
    # This function returns 0 if the specified year is a leap year;
    #   1 otherwise.
    # The formula for checking whether a year is a leap year is:
    #   1. Years not divisible by 4 are not leap years.
    #   2. Years divisible by 4 and by 400 are leap years.
    #   3. Years divisible by 4, not divisible by 400, but divisible
    #       by 100 are not leap years.
    #   4. All other years divisible by 4 are leap years.

    year=$1
    if [ "$((year % 4))" -ne 0 ] ; then
        return 1 # Nope, not a leap year.
    elif [ "$((year % 4))" -eq 0 ] ; then
        return 0 # Yes, it's a leap year.
    elif [ "$((year % 100))" -eq 0 ] ; then
        return 1
    else
        return 0
    fi
}

#########################################################################

# nicenumber -- Given a number, shows it in comma-separated form. Expects DD
#   (decimal point delimieter) and TD (thousand delimieter) to be instantiated.
#   Instantiates nicenum or, if a second arg is specifies, the output is 
#   echoed to stdout

nicenumber()
{
    integer=$(echo $1 | cut -d. -f1)    # Left of the decimal
    decimal=$(echo $1 | cut -d. -f2)    # Right of the decimal

    # Check if the number has more than the integer part
    if [ "$decimal" != "$1" ] ; then
        # There's a fractional part, so let's include it.

        # brace substitution :: he assignment (:=) operator is 
        #   used to assign a value to the variable if it doesn't
        #   already have one. 
        result="${DD:= '.'}$decimal"
        # result = .$decimal
    fi
    thousands=$integer

    while [ $thousands -gt 999 ] ; do
        remainder=$(($thousands % 1000))    # Three least significant digits

        # We need 'remainder' to be three digist. Do we need add zeros?
        while [ ${#remainder} -lt 3 ]; do   # force leading zeroes
            remainder="0$remainder"
        done

        result="${TD:=","}${remainder}${result}"    # Builds right to left
        thousands=$(($thousands / 1000))    # To left of remainder if any 
    done

    nicenum="${thousands}${result}"
    if [ ! -z $2 ] ; then
        echo $nicenum
    fi
}

