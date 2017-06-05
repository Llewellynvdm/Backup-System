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
#	@version			1.0.0
#	@build			9th May, 2017
#	@package		Backup System
#	@author			Llewellyn van der Merwe <https://github.com/Llewellynvdm>
#	@copyright		Copyright (C) 2015. All Rights Reserved
#	@license		GNU/GPL Version 2 or later - http://www.gnu.org/licenses/gpl-2.0.html
#
#/-----------------------------------------------------------------------------------------------------------------------------/

# get script path
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" || "$DIR" == '.' ]]; then DIR="$PWD"; fi

# load configuration file
. "$DIR/config.sh"

# load functions
. "$DIR/incl.sh"

# we move out of the script folder
cd "$DIR"
cd ../

# get random folder name to avoid conflict
newFolder=$(getRandom)
# set this repo location
tmpFolder="$PWD/T3MPR3P0_$newFolder"
# create tmp folder
if [ ! -d "$tmpFolder" ] 
then
	mkdir -p "$tmpFolder"
fi

# DB file
databasesFileName="databases"
databaseBuilder="$DIR/$databasesFileName"
# check if file exist
if [ ! -f "$databaseBuilder" ] 
then
    echo 'No databases.txt found'
    exit 1
fi

# folder names
foldersFileName="folders"
folderBuilder="$DIR/$foldersFileName"
# check if file exist
if [ ! -f "$folderBuilder" ] 
then
    echo 'No folders.txt found'
    exit 1
fi

# run main
. "$DIR/main.sh"
