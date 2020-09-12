#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 ls $language
    exit 1

elif [ "$1" = "-r" ]; then

    case $# in

        1)
            aws s3 ls s3://$bucket/ \
            --recursive \
            --human-readable \
            2> /dev/null | \
            sed 's,'${url}',,g'
        ;;

        2)
            aws s3 ls s3://$bucket/$2/ \
            --recursive \
            --human-readable \
            2> /dev/null | \
            sed 's,'${url}',,g'
        ;;

        *)
            bad-syntax s3 ls $language
        ;;

    esac

else

    case $# in

        0)
            aws s3 ls s3://$bucket/ \
            --human-readable \
            2> /dev/null
        ;;

        1)
            aws s3 ls s3://$bucket/$1/ \
            --human-readable \
            2> /dev/null
        ;;

        *)
            bad-syntax s3 ls $language
        ;;

    esac

fi
