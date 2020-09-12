#!/bin/bash

DIR="/usr/local/aws-simple"
kissRepoPATH=$DIR"/repository"
kissSETTINGS=$DIR"/kiss/data/settings"
kissRepoSETTINGS=$kissRepoPATH"/aws-simple/kiss/data/settings"

kissNAME="aws-simple"
kissVERSION="11"
kissURL="14"
kissREPOSITORY="17"
kissLANGUAGE="20"


#####################################
#           G E T T E R S           #
#####################################


function kiss-get-repository() {
    cat $kissSETTINGS | sed -n $kissREPOSITORY'p'
}

function kiss-get-language() {
    cat $kissSETTINGS | sed -n $kissLANGUAGE'p'
}

function kiss-get-version() {
    cat $kissSETTINGS | sed -n $kissVERSION'p'
}

function kiss-get-url() {
    cat $kissSETTINGS | sed -n $kissURL'p'
}

function kiss-get-new-version() {
    repository=$(kiss-get-repository)

    if [ -n $repository ] && [ -d $repository ]; then
        cat $kissRepoSETTINGS | sed -n $kissVERSION'p'
    else
        echo 0
    fi
}


#####################################
#           S E T T E R S           #
#####################################

function kiss-set-repository() {
    sed -i $kissREPOSITORY's,.*,'$kissRepoPATH',' $kissSETTINGS
}


function kiss-set-language() {
    clear
    printf """\
Available languages

[1] - English
[2] - Spanish

Enter a number: """
    read input
    clear

    if [ $input -ge 1 ] && [ $input -le 2 ]; then

        case $input in

            1)
                language="english"
            ;;

            2)
                language="spanish"
            ;;

        esac

        sed -i $kissLANGUAGE's,.*,'$language',' $kissSETTINGS
    else
        echo "Invalid option"
        exit 1
    fi
}


#####################################
#       C H E C K   V A L U E       #
#####################################


function kiss-is-filled-repository() {
    value=$(kiss-get-repository)
    if [ -n "$value" ]; then
        echo 1
    else
        echo 0
    fi
}


function kiss-is-filled-language() {
    value=$(kiss-get-language)
    if [ -n "$value" ]; then
        echo 1
    else
        echo 0
    fi
}
