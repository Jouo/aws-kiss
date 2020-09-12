#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 mkdir $language
    exit 1
fi

case $# in

    1)
        aws s3api put-object \
        --bucket $bucket \
        --key $1/ \
        &> /dev/null

        echo "Directory /$1 has been created"
    ;;

    *)
        bad-syntax s3 mkdir $language
    ;;

esac
