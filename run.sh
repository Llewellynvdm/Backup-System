#!/bin/bash
#/--------------------------------------------------------------------------------------------------------|  www.vdm.io  |------/
#    __      __       _     _____                 _                                  _     __  __      _   _               _
#    \ \    / /      | |   |  __ \               | |                                | |   |  \/  |    | | | |             | |
#     \ \  / /_ _ ___| |_  | |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_  | \  / | ___| |_| |__   ___   __| |
#      \ \/ / _` / __| __| | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __| | |\/| |/ _ \ __| '_ \ / _ \ / _` |
#       \  / (_| \__ \ |_  | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_  | |  | |  __/ |_| | | | (_) | (_| |
#        \/ \__,_|___/\__| |_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__| |_|  |_|\___|\__|_| |_|\___/ \__,_|
#                                                        | |
#                                                        |_|
#/-------------------------------------------------------------------------------------------------------------------------------/
#
#	@version		2.0.0
#	@build			9th May, 2017
#	@package		Backup System
#	@author			Llewellyn van der Merwe <https://github.com/Llewellynvdm>
#	@copyright		Copyright (C) 2015. All Rights Reserved
#	@license		GNU/GPL Version 2 or later - http://www.gnu.org/licenses/gpl-2.0.html
#
#/-----------------------------------------------------------------------------------------------------------------------------/

# user home dir
USERHOME=~/
# switch to revert
REVERT=0
# get script path
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" || "$DIR" == '.' ]]; then DIR="$PWD"; fi

# load setup incase
. "$DIR/setup.sh"

# config file
DIRconfig="$DIR/config.sh"
# check if file exist
if [ ! -f "$DIRconfig" ] 
then
    runSetup 1 "$DIRconfig"
fi

# load configuration file
. "$DIR/config.sh"

# load functions
. "$DIR/incl.sh"

# check if the BACKUPWEBSITES area switches is set
if [ -z ${BACKUPWEBSITES+x} ]; then
    echo "BACKUPWEBSITES=1" >> "$DIR/config.sh"
    BACKUPWEBSITES=1
fi

# check if the BACKUPDATABASE area switches is set
if [ -z ${BACKUPDATABASE+x} ]; then
    echo "BACKUPDATABASE=1" >> "$DIR/config.sh"
    BACKUPDATABASE=1
fi

 # need only continue if either one option is set
if [ "$BACKUPWEBSITES" -eq "0" ] && [ "$BACKUPDATABASE" -eq "0" ]; then
    # We have no work here
    exit 0
fi

# got to script folder
cd "$DIR"
# set Base Dir
BASEDIR="$PWD"

# get random folder name to avoid conflict
newFolder=$(getRandom)
# set this repo location
tmpFolder="${USERHOME}T3MPR3P0_${newFolder}"
# create tmp folder
if [ ! -d "$tmpFolder" ] 
then
    mkdir -p "$tmpFolder"
fi

# only add if db's are required
if [ "$BACKUPDATABASE" -eq "1" ]; then
    # DB file
    databasesFileName="databases"
    databaseBuilder="$BASEDIR/$databasesFileName"
    # check if file exist
    if [ ! -f "$databaseBuilder" ] 
    then
        runSetup 2 "$databaseBuilder"
    fi
fi

# only add if db's are required
if [ "$BACKUPWEBSITES" -eq "1" ]; then
    # folder names
    foldersFileName="folders"
    folderBuilder="$BASEDIR/$foldersFileName"
    # check if file exist
    if [ ! -f "$folderBuilder" ]
    then
        runSetup 3 "$folderBuilder"
    fi
fi

# we move to user folder
cd "$USERHOME"

#Look for optional config parameter
while getopts ":r" opt; do
    case $opt in

    r)
        REVERT=1
    ;;

    esac
done

# run main
. "$BASEDIR/main.sh"
