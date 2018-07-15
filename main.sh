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

#confirm we are done with database backup
if [ "$BACKUPDATABASE" -eq "1" ]; then
    BACKUPDBDONE=0
else
    BACKUPDBDONE=1
fi
#confirm we are done with website backup
 if [ "$BACKUPWEBSITES" -eq "1" ]; then
    BACKUPWEBDONE=0
else
    BACKUPWEBDONE=1
fi

# some error handle
MOVEDBRESULT=0
MOVEWEBRESULT=0

# for global messages
MOVEDBWHAT='None'
MOVEWEBWHAT='None'

### MAIN ###
function main () {
	# do backup
	if [ "$REVERT" -ne 1 ]; then
		# backup the databases now
        if [ "$BACKUPDATABASE" -eq "1" ]; then
            backupDB
        fi
		# backup the websites now
        if [ "$BACKUPWEBSITES" -eq "1" ]; then
            backupWEB
        fi
	else
		# revert the databases now
        if [ "$BACKUPDATABASE" -eq "1" ]; then
            revertDB
        fi
		# revert the websites now
        if [ "$BACKUPWEBSITES" -eq "1" ]; then
            revertWEB
        fi
		# force remove tmp
		rmTmp 4
	fi
}

function rmTmp () {
	# trip the switch for the done area
	if [ "$1" -eq "1" ]; then
		#confirm we are done
		BACKUPDBDONE=1
	elif [ "$1" -eq "2" ]; then
		#confirm we are done
		BACKUPWEBDONE=1
	elif [ "$1" -eq "4" ]; then
		# now force remove tmp
		rmFolder "$tmpFolder"
	fi
	# only if both are done
	if [ "$BACKUPWEBDONE" -eq "1" ] && [ "$BACKUPDBDONE" -eq "1" ]; then
		# now remove tmp
		rmFolder "$tmpFolder"
	fi
}

# function to backup all DB's
function backupDB () {
	while IFS=$'\t' read -r -a database
	do
		[[ "$database" =~ ^#.*$ ]] && continue
		# zip the database
		DBFILE=$(zipDB "${database[0]}" "${database[1]}" "${database[2]}" "${database[3]}" "${database[4]}")
		# move to backup server
		moveDB "$DBFILE"
		# check if move was success
		checkMove 1
	done < $databaseBuilder

	# start fresh
	cd "$USERHOME"
	# GO To remote server and do house cleaning
	if [ "$BACKUPTYPE" -eq "1" ]; then
		ssh -tt -p '22' "$REMOTESSH" "$(typeset -f); remoteHouseCleaning $REMOTEDBPATH"
	fi
	# try to remove tmp
	rmTmp 1
}

# function to backup all WEB folders
function backupWEB () {
	# GO To remote server and do house cleaning
	while IFS=$'\t' read -r -a foalder
	do
		[[ "$foalder" =~ ^#.*$ ]] && continue
		# move the local folder & files to remote
		moveWEB "${foalder[0]}" "${foalder[1]}"
		# check if move was success
		checkMove 2
	done < $folderBuilder

	# start fresh
	cd "$USERHOME"
	# GO To remote server and do house cleaning
	if [ "$BACKUPTYPE" -eq "1" ]; then
		ssh -tt -p '22' "$REMOTESSH" "$(typeset -f); remoteHouseCleaning $REMOTEWEBPATH"
	fi
	# try to remove tmp
	rmTmp 2
}

# function to revert DB's
function revertDB () {
	while IFS=$'\t' read -r -a database
	do
		[[ "$database" =~ ^#.*$ ]] && continue
		# the local database details
		# echo "${database[0]}" "${database[1]}" "${database[2]}" "${database[3]}" "${database[4]}"
	done < $databaseBuilder

	echo "Soon we will add this feature in its full.";
}

# function to revert WEB folders
function revertWEB () {
	while IFS=$'\t' read -r -a foalder
	do
		[[ "$foalder" =~ ^#.*$ ]] && continue
		# the local folder & remote file name
		# echo "${foalder[0]}" "${foalder[1]}"
	done < $folderBuilder

	echo "Soon we will add this feature in its full.";
}

# run the main only at the end!
main

# try again
rmTmp 3

# We are done
exit 0