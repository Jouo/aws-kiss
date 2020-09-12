#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 up $language
    exit 1

elif [ "$1" = "-r" ]; then

    case $# in

        2)
            aws s3 cp $2 s3://$bucket/ \
            --recursive \
            --storage-class $storage \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        3)
            aws s3 cp $2 s3://$bucket/$3 \
            --recursive \
            --storage-class $storage \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        *)
            bad-syntax s3 up $language
        ;;
    esac

else

    case $# in

        1)
            aws s3 cp $1 s3://$bucket/ \
            --storage-class $storage \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        2)
            aws s3 cp $1 s3://$bucket/$2 \
            --storage-class $storage \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        *)
            bad-syntax s3 up $language
        ;;
    esac

fi
