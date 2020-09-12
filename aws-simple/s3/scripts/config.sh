#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 config $language
    exit 1;
fi

command=$1

case $command in

    "info")
        s3-info
    ;;

    "bucket")
        s3-set-bucket
    ;;

    "storage")
        s3-set-storage
    ;;

    *)
        bad-syntax s3 config $language
    ;;

esac
