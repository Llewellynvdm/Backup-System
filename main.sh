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

#confirm we are done
BACKUPDBDONE=0
BACKUPWEBDONE=0

# some error handle
MOVEDBRESULT=0
MOVEWEBRESULT=0

# for global messages
MOVEDBWHAT='None'
MOVEWEBWHAT='None'

### MAIN ###
function main () {
	# backup the databases now
	backupDB
	# backup the websites now
	backupWEB
}

function rmTmp () {
	# trip the switch for the done area
	if [ "$1" -eq "1" ]; then
		#confirm we are done
		BACKUPDBDONE=1
	elif [ "$1" -eq "2" ]; then
		#confirm we are done
		BACKUPWEBDONE=1
	fi
	# only if both are done
	if [ "$BACKUPWEBDONE" -eq "1" ] && [ "$BACKUPDBDONE" -eq "1" ]; then
		# now remove the local file
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

# run the main only at the end!
main

# try again
rmTmp 3

# We are done
exit 0