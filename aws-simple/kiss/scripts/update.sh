############################################################
#   IMPORTANT:                                             #
#   This script is sourced by kiss/libraries/general.sh,   #
#   some variables and functions come from there.          #
############################################################


BIN="/usr/local/bin"

# Lines that match values in user settings
# that should be overwritten in the new files
kissValues=("20")
s3Values=("11" "14")

# Grabs current scripts available
SERVICES=$(ls $kissRepoPATH"/bin")


# Runs the update process, you can check what
# each function does by scrolling down below

function main() {

# 1) Pull any changes from the repository
update-repository

# 2) Check current version and repository version
compare-versions

# 3) Temporarily copy user setting files
copy-setting-files

# 4) Update kiss!
run-update

# 5) Set permissions for all users
setup-permissions

# 6) Copy user settings into the new files
replace-user-settings kiss ${kissValues[@]}
replace-user-settings s3 ${s3Values[@]}

# 7) Remove temporal setting copies
sudo rm $kissRepoPATH/*".settings"

# 8) Display useful information (BIG QUESTION MARKS???)
kiss info
kiss

}


##############################################
#   1)  U P D A T E   R E P O S I T O R Y    #
##############################################


# Updates the internal repository

function update-repository() {
    if [ -d $kissRepoPATH ]; then
        $(pull-repository) 2> /dev/null
    else
        echo "Internal repository not found, please run: \`kiss fix-repo\`"
    fi
}


# Attempt to pull git repository changes,
# it has to be done this way to avoid
# changing directories in the CLI

function pull-repository() {
        cd $kissRepoPATH
        sudo git pull &> /dev/null
}


############################################
#   2)  C O M P A R E   V E R S I O N S    #
############################################


# It will compare the versions and exit the
# script if there's nothing to update

function compare-versions() {
    repositoryIsNewer=$(is-repository-newer)

    if [ $repositoryIsNewer -eq 0 ]; then
        echo "Nothing to update."
        exit 3
    fi
}


# Returns 1 if the repo version is newer, otherwise 0

function is-repository-newer() {
    currentVersion=$(kiss-get-version)
    newVersion=$(kiss-get-new-version)

    awk -v n1="$newVersion" -v n2="$currentVersion" \
    'BEGIN {print (n1>n2?"1":"0") }'
}


#############################################
#   3)  T E M P   S E T T I N G   C O P Y   #
#############################################


# Makes a temporal copy of each setting file,
# reason being, the next step wipes directories

function copy-setting-files() {
    for service in ${SERVICES[@]}; do

        originFile=$DIR/$service"/data/settings"
        targetFile=$kissRepoPATH/$service".settings"

        if [ -f $originFile ]; then
            sudo cp $originFile $targetFile
        fi

    done
}


##################################
#   4)  U P D A T E   K I S S    #
##################################


# This function will remove current kiss files,
# then copy the new files from the internal reposiory,
# and finally grant permissions to all users

function run-update() {
    remove-current-files
    place-new-files
    setup-permissions
}


# Removes current kiss files

function remove-current-files() {

    # Removing from main directory
    directories=$(ls $DIR -I "repository")
    for directory in ${directories[@]}; do
        sudo rm -r $DIR/$directory
    done

    # Removing scripts in bin
    for service in ${SERVICES[@]}; do

        file=$BIN/$service
        if [ -f $file ]; then
            sudo rm $file
        fi

    done
}


# Copy repository files to their respective location

function place-new-files() {

    # From repository, to main directory
    sudo cp -r $kissRepoPATH/$kissNAME/* $DIR/

    # From repository, to bin directory
    sudo cp $kissRepoPATH"/bin"/* $BIN/
}


##############################################
#   5)  S E T U P   P E R M I S S I O N S    #
##############################################


# Give all permissions, because why not

function setup-permissions() {
    sudo chmod 777 $DIR
    directories=$(ls $DIR -I "repository")

    for directory in ${directories[@]}; do
        sudo chmod -R 777 $DIR/$directory
    done

    for service in ${SERVICES[@]}; do
        sudo chmod 777 $BIN/$service
    done
}


################################################
#   6)  C O P Y   U S E R   S E T T I N G S    #
################################################


# Will copy the values found in the temporal setting copy
# and place them in the new setting file

function replace-user-settings() {
    arguments=("$@")
    service=$1
    userFile=$DIR/$service"/data/settings"
    repoFile=$kissRepoPATH/$service".settings"

    # checks if the settings exists in both the main directory
    # and the repository (temporal setting copy)
    if [ -f "$userFile" ] && [ -f "$repoFile" ]; then

        # This loop grabs the line values by ignoring the first
        # argument on the function call (the service name)
        for ((index = 1; index < $#; index++)); do

            # Grab the value from the temporal setting file
            # and place it in the new setting files
            line="${arguments[$index]}"
            value=$(sudo cat $repoFile | sed -n $line'p')
            sudo sed -i $line's,.*,'$value',' $userFile

        done

    fi
}
