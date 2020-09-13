#!/bin/bash

DIR="/usr/local/aws-simple"
s3LIBRARY=$DIR"/s3/libraries"

# Loading variables and functions
source $s3LIBRARY"/configuration.sh"


# This will be run uppon executing `s3`

function s3-setup() {

    # If the bucket name hasn't been set, ask for it
    returned=$(s3-is-filled-bucket)
    if [ $returned -eq 0 ]; then
        s3-set-bucket
    fi

    # if the storage type hasn't been set, ask for it
    returned=$(s3-is-filled-storage)
    if [ $returned -eq 0 ]; then
        s3-set-storage
    fi
}


# Print s3 configuration

function s3-info() {
    echo """
 Bucket     - $(s3-get-bucket)
 S3 Storage - $(s3-get-storage)
"""
}


# Variables given when sourcing this script
storage=$(s3-get-storage)
bucket=$(s3-get-bucket)
url=$(s3-get-url)
