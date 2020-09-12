#!/bin/bash

DIR="/usr/local/aws-simple"
utilityKissSETTINGS=$DIR"/kiss/data/settings"


#############################
#       G E N E R A L       #
#############################

# Most of the functions placed in this section may already exist,
# but I'd like to avoid sourcing a bunch of files.

utilityKissLANGUAGE="20"

function utilities-kiss-get-language() {
    cat $utilityKissSETTINGS | sed -n $utilityKissLANGUAGE'p'
}
language=$(utilities-kiss-get-language)


#################################
#       U T I L I T I E S       #
#################################


# Returns the list of arguments passed while ignoring the
# first argument which is the service name, like: s3

function get-arguments() {
    array=("$@")
    arguments=""

    # Concatenate everything but the first item
    for ((i = 1; i < $#; i++)); do
        arguments+="${array[$i]} "
    done

    echo "$arguments"
}


# Executes a specific script

function execute-command() {
    service=$1
    command=$2
    arguments=$3

    command=$DIR/$service"/scripts"/$command".sh"

    eval "$command $arguments"
}


########################################
#       C L I   M E S S A G E S        #
########################################


# Loads varibales, to avoid repetition in the functions

function load-variables() {
    arguments=("$@")
    service=${arguments[0]}
    command=${arguments[1]}
    language=${arguments[2]}
}


# Display detailed help for commands

function show-help() {
    load-variables "$@"
    less $DIR/$service"/help"/$language/$command
}


# Prints a warning for unkown commands

function unknown-command() {
    load-variables "$@"
    file=$DIR"/kiss/help"/$language"/aid/unknown-command"

    cat $file | \
         sed 's,SERVICE,'$service',g' | \
         sed 's,COMMAND,'$command',g'
}


# Prints brief information about the command

function bad-syntax() {
    load-variables "$@"
    aid=$(get-syntax-aid "$@")

    file=$DIR"/kiss/help"/$language"/aid/bad-syntax"

    echo $aid
    cat $file | \
         sed 's,SERVICE,'$service',g' | \
         sed 's,COMMAND,'$command',g'
}


# Gets the command syntax information (sample usage)

function get-syntax-aid() {
    load-variables "$@"
    syntaxFile=$DIR/$service"/help"/$language"/usage-sample"/$command
    cat $syntaxFile
}
