#!/bin/bash

DIR="/usr/local/aws-simple"

# loading variables and functions
source $DIR"/kiss/libraries/utilities.sh"
source $DIR"/s3/libraries/general.sh"

if [ "$1" = "-h" ]; then
    show-help s3 rm $language
    exit 1

elif [ "$1" = "-r" ]; then

    case $# in

        2)
            directory=$2
            path=$bucket/$2
            if [ $2 == "." ]; then
                path=$bucket
                directory=""
            fi

            # Ask user to confirm the action
            printf "Deleting recursively \"/${directory}\"\ntype \"DELETE\" to continue: "
            read answer
            if [ $answer != "DELETE" ]; then
                echo "Canceled"
                exit 1
            fi

            # Delete content
            aws s3 rm s3://$path \
            --recursive \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        *)
            bad-syntax s3 rm $language
        ;;
    esac

else

    case $# in
        1)
            aws s3 rm s3://$bucket/$1 \
            2> /dev/null | \
            sed 's,'$url',,g'
        ;;

        *)
            bad-syntax s3 rm $language
        ;;

    esac

fi
