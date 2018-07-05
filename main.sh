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
#	@version		1.0.0
#	@build			9th May, 2017
#	@package		Backup System
#	@author			Llewellyn van der Merwe <https://github.com/Llewellynvdm>
#	@copyright		Copyright (C) 2015. All Rights Reserved
#	@license		GNU/GPL Version 2 or later - http://www.gnu.org/licenses/gpl-2.0.html
#
#/-----------------------------------------------------------------------------------------------------------------------------/

### MAIN ###
function main () {
	# backup the databases now
	backupDB &
	# backup the websites now
	backupWEB
	# now remove the local file
	rmTmpFolder "$tmpFolder"
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
	done < $databaseBuilder

	# start fresh
	cd "$USERHOME"
	# GO To remote server and do house cleaning
	if [ "$BACKUPTYPE" -eq "1" ]; then
		ssh -tt -p '22' "$REMOTESSH" "$(typeset -f); remoteHouseCleaning $REMOTEDBPATH"
	fi
}

# function to backup all WEB folders
function backupWEB () {
	# GO To remote server and do house cleaning
	while IFS=$'\t' read -r -a foalder
	do
		[[ "$foalder" =~ ^#.*$ ]] && continue
		# move the local folder & files to remote
		moveWEB "${foalder[0]}" "${foalder[1]}"

	done < $folderBuilder

	# start fresh
	cd "$USERHOME"
	# GO To remote server and do house cleaning
	if [ "$BACKUPTYPE" -eq "1" ]; then
		ssh -tt -p '22' "$REMOTESSH" "$(typeset -f); remoteHouseCleaning $REMOTEWEBPATH"
	fi
}

# run the main only at the end!
main
