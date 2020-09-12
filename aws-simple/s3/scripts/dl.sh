#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 dl $language
    exit 1

elif [ "$1" = "-r" ]; then

    case $# in

        2)
            aws s3 cp s3://$bucket/$2 . \
            --recursive \
            2> /dev/null | \
            sed 's,'${url}',,g'
        ;;

        3)
            aws s3 cp s3://$bucket/$2 $3 \
            --recursive \
            2> /dev/null | \
            sed 's,'${url}',,g'
        ;;

        *)
            bad-syntax s3 dl $language
        ;;

    esac

else

    case $# in

        1)
            aws s3 cp s3://$bucket/$1 . \
            2> /dev/null | \
            sed 's,'${url}',,g'
        ;;

        2)
            aws s3 cp s3://$bucket/$1 $2 \
            2> /dev/null | \
            sed 's,'${url}',,g'
        ;;

        *)
            bad-syntax s3 dl $language
        ;;

    esac

fi
