#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

# Edit this value to increase max time limit
# 86400 by default (1 day)
timeLimit=86400

if [ "$1" = "-h" ]; then
    show-help s3 url $language
    exit 1
fi

case $# in

    1)
        aws s3 presign s3://$bucket/$1 \
        2> /dev/null
    ;;

    2)
        if [ $2 -gt $timeLimit ]; then
            echo "Value can't be higher than "$timeLimit
            exit 1
        fi

        aws s3 presign s3://$bucket/$1 \
        --expires-in $2 \
        2> /dev/null
    ;;

    *)
        bad-syntax s3 url $language
    ;;
esac
