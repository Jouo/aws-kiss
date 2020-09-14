#!/bin/bash

DIR="/usr/local/aws-simple"
s3SETTINGS=$DIR"/s3/data/settings"

s3BUCKET="11"
s3STORAGE="14"


#####################################
#           G E T T E R S           #
#####################################


function s3-get-bucket() {
    cat $s3SETTINGS | sed -n $s3BUCKET'p'
}

function s3-get-storage() {
    cat $s3SETTINGS | sed -n $s3STORAGE'p'
}

function s3-get-url() {
    echo "s3://$(s3-get-bucket)"
}


#####################################
#           S E T T E R S           #
#####################################


function s3-set-bucket() {
    clear
    printf "S3 bucket (just the name): "
    read input
    clear

    if [ -n "$input" ]; then
        sed -i $s3BUCKET's,.*,'$input',' $s3SETTINGS
    else
        echo "Bucket can't be left empty"
        exit 1
    fi
}


function s3-set-storage() {
    clear
    printf """\
Storage options available

[1] - S3 Standard
[2] - S3 Intelligent-Tiering
[3] - S3 Standard-IA
[4] - S3 One Zone-IA

Enter a number: """
    read input
    clear

    if [ -n "$input" ] && [ $input -ge 1 ] && [ $input -le 4 ]; then

        case $input in

            1)
                storage="STANDARD"
            ;;

            2)
                storage="INTELLIGENT_TIERING"
            ;;

            3)
                storage="STANDARD_IA"
            ;;

            4)
                storage="ONEZONE_IA"
            ;;

        esac

        sed -i $s3STORAGE's,.*,'$storage',' $s3SETTINGS
    else
        echo "Invalid option"
        exit 1
    fi
}


#####################################
#       C H E C K   V A L U E       #
#####################################


function s3-is-filled-bucket() {
    value=$(s3-get-bucket)
    if [ -n "$value" ]; then
        echo 1
    else
        echo 0
    fi
}

function s3-is-filled-storage() {
    value=$(s3-get-storage)
    if [ -n "$value" ]; then
        echo 1
    else
        echo 0
    fi
}
