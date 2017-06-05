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

                                ##############################################################
                                ##############                                      ##########
                                ##############             FUNCTIONS                ##########
                                ##############                                      ##########
                                ##############################################################

# zip the Database
function zipDB {
	# we move to tmp folder
	cd "$tmpFolder"
	# db server ip address
	DBSERVER="$1"
	# set the file name
	FILE=`date +"%Y%m"`"_$2.sql"
	#database to backup
	DATABASE="$3"
	# user that has access to do this
	USER="$4"
	# the user password
	PASS="$5"
	# use this command for a database server on localhost. add other options if need be.
	mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} > ${FILE}
	# gzip the mysql database dump file
	gzip $FILE
	# return file name
	echo ${FILE}".gz"
}

function moveDB () {
	# we move to tmp folder
	cd "$tmpFolder"
	# file name
	FILE="$1"
	# move file
	scp "$FILE" "$REMOTESSH:${REMOTEDBPATH}${FILE}"
}

function moveWEB () {
	# local folder path
	localFolder="$1"
	# remote folder name
	remoteFolder="$2"
	# move all file & folders
	rsync -ax "${localFolder}" "$REMOTESSH:${REMOTEWEBPATH}${remoteFolder}"
}

function remoteHouseCleaning () {
	setGit "$1"
}

# remove a folder and all its content
function rmTmpFolder () {
    local FOLDER="$1"
    # ensure repos is removed
    if [ -d "$FOLDER" ] 
    then
        rm -fR "$FOLDER"
    fi
}

# simple basic random
function getRandom () {
    echo $(tr -dc 'A-HJ-NP-Za-km-z2-9' < /dev/urandom | dd bs=5 count=1 status=none)
}

#set git in folder
function setGit () {
	cd "$1"
	# use UTC+00:00 time also called zulu
	actionTime=$(TZ=":ZULU" date +"%m/%d/%Y @ %R (UTC)" )
	if [ -d .git ]; then
		commitChanges "Updated $actionTime"
	else
		git init
		commitChanges "First commit $actionTime"
	fi;
}

# git function at end
function commitChanges () {
    git add .
    git commit -am "$1"
}
