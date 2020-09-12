#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 mv $language
    exit 1

elif [ "$1" = "-r" ]; then

    case $# in

        3)
            origin=$bucket/$2
            destination=$bucket/$3

            if [ $2 == "." ]; then
                origin=$bucket/
            fi

            if [ $3 == "." ]; then
                destination=$bucket/
            fi

            aws s3 mv \
            s3://$origin \
            s3://$destination \
            --recursive \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        *)
            bad-syntax s3 mv $language
        ;;

    esac

else

    case $# in

        2)
            destination=$bucket/$2
            if [ $2 == "." ]; then
                destination=$bucket/
            fi

            aws s3 mv \
            s3://$bucket/$1 \
            s3://$destination \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        *)
            bad-syntax s3 mv $language
        ;;

    esac

fi
