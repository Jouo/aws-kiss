# Global variables
SCRIPT_DIR="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"
DIR="/usr/local"
NAME="aws-simple"
AWS=$DIR/$NAME
BIN=$DIR"/bin"
REPO=$AWS"/repository"

# Grabs current scripts available
SERVICES=$(ls $SCRIPT_DIR"/bin")


# Runs the installation process, you can check what each
# function does by scrolling down below, no secrets!

function main() {

# 1) Checks if kiss is already installed,
#    remove files when reinstalling
installation-checker

# 2) Install kiss!
run-installer

# 3) Set permissions for all users
setup-permissions

}


##################################################
#   1)  S E A R C H   I N S T A L L A T I O N    #
##################################################


# Will look for the kiss directory, if found then
# promt the user if they wish to reinstall

function installation-checker() {
    if [ -d $AWS ]; then
        echo "Looks like kiss is already installed, do you wish to reinstall?"
        printf "Current user settings will be lost, type \"YES\" to continue: "
        read input

        if [ $input != "YES" ]; then
            echo "Reinstallation canceled"
            exit 0
        fi

        installation-cleaner
    fi
}


# Deletes current installation, it will skip the repository
# if you're running the installer found in that directory

function installation-cleaner() {
    files=$(ls $AWS)
    if [ $SCRIPT_DIR = $REPO ]; then
        files=$(ls $AWS -I "repository")
    fi

    # Removes files from /usr/local/aws-simple/
    for file in ${files[@]}; do
        sudo rm -r $AWS/$file
    done

    # Removes kiss script files from /usr/local/bin/
    for service in ${SERVICES[@]}; do
        sudo rm $BIN/$service
    done
}


####################################
#   2)  I N S T A L L   K I S S    #
####################################


# Copy kiss files to their respective location

function run-installer() {
    if [ ! -d $AWS ]; then
        sudo mkdir $AWS
    fi

    sudo cp -r $SCRIPT_DIR/$NAME/* $AWS/
    sudo cp $SCRIPT_DIR"/bin"/* $BIN/

    # Create repository if it hasn't been setup
    if [ ! -d $REPO ]; then
        sudo cp -r $SCRIPT_DIR $REPO
    fi
}


##############################################
#   3)  S E T U P   P E R M I S S I O N S    #
##############################################


function setup-permissions() {

    # Give all permissions, because why not
    sudo chmod -R 777 $AWS

    for service in ${SERVICES[@]}; do
        sudo chmod 777 $BIN/$service
    done
}


###################################
#       R U N   S C R I P T       #
###################################


# Install everything
main

# Print kiss information
kiss info

# Show kiss help
kiss
