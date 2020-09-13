#!/bin/bash

DIR="/usr/local/aws-simple"
kissLIBRARY=$DIR"/kiss/libraries"
kissSCRIPTS=$DIR"/kiss/scripts"

# Loading variables and functions
source $kissLIBRARY"/configuration.sh"


# This will be run uppon executing `kiss`

function kiss-setup() {

    # If the language hasn't been set, ask for it
    returned=$(kiss-is-filled-language)
    if [ $returned -eq 0 ]; then
        kiss-set-language
    fi
}


# Print information about kiss

function kiss-info() {
    style-points
    echo """
 Version  - $(kiss-get-version)
 Language - $(kiss-get-language)
"""
}


# Robert Cecil Martin conferences are pretty good,
# you should watch them if you haven't.

function style-points() {
echo '   __ ___      _____           _  __  _   ___   ___'
echo '  / _` \ \ /\ / / __|   ___   | |/ / | | / __| / __|'
echo ' | (_| |\ V  V /\__ \  |___|  |   <  | | \__ \ \__ \'
echo '  \__,_| \_/\_/ |___/         |_|\_\ |_| |___/ |___/'
echo
echo '  Amazon Web Services  -----  Keep it simple, stupid'
}


# Runs kiss updater

function kiss-update() {
    source $kissSCRIPTS"/update.sh"
    main
}


# Variables given when sourcing this script
language=$(kiss-get-language)
