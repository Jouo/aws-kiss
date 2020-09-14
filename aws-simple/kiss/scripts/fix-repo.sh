############################################################
#   IMPORTANT:                                             #
#   This script is sourced by kiss/libraries/general.sh,   #
#   some variables and functions come from there.          #
############################################################


REPOSITORY="aws-kiss"

# Runs the fix-repo process

function main() {

# 1) Remove current internal repository
remove-repository

# 2) Fix kiss repositoy! (cloning git repo)
run-fix

# 3) Let the user know everything went smooth
echo "Internal repository has been fixed."

}


#############################################
#   1)  R E M O V E   R E P O S I T O R Y   #
#############################################


function remove-repository() {
    if [ -d $kissRepoPATH ]; then
        sudo rm -r $kissRepoPATH
    fi
}


############################################
#   2)  C L O N E   R E P O S I T O R Y    #
############################################


# Setup the internal repository

function run-fix() {
    if [ ! -d $kissRepoPATH ]; then

        status=$(clone-repository)

        if [ $status -eq 0 ]; then
            sudo mv $DIR/$REPOSITORY/ $kissRepoPATH
        else
            echo "There was a problem cloning the git repository."
            exit 2
        fi

    else
        echo "There was a problem removing the internal repository."
        exit 1
    fi
}


# Attempts to clone the git repository and echo exit status

function clone-repository() {
    cd $DIR
    sudo git clone $(kiss-get-url) &> /dev/null
    echo $?
}
