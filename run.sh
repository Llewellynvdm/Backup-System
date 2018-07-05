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

# DB file
databasesFileName="databases"
databaseBuilder="$BASEDIR/$databasesFileName"
# check if file exist
if [ ! -f "$databaseBuilder" ] 
then
    runSetup 2 "$databaseBuilder"
fi

# folder names
foldersFileName="folders"
folderBuilder="$BASEDIR/$foldersFileName"
# check if file exist
if [ ! -f "$folderBuilder" ]
then
    runSetup 3 "$folderBuilder"
fi

# we move to user folder
cd "$USERHOME"

# run main
. "$BASEDIR/main.sh"
