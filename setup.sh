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

### setup config file ###
function runSetupConfig () {
	# get backup type
	echo -ne "\n  Select Backup Type\n"
	echo -ne " 1 = Remote Server\n"
	echo -ne " 2 = Dropbox\n"
	echo -ne " # Make your selection [1/2]: "
	read -r INPUT_BACKUPTYPE
	# get the details for the backup type
	if [ "$INPUT_BACKUPTYPE" -eq "2" ]; then
		# get dropbox uploader path
		echo -ne "\n  Set the Path to the Dropbox Uploader File\n"
		echo -ne " Use https://github.com/andreafabrizi/Dropbox-Uploader\n"
		echo -ne " # Example (/home/path/to/Dropbox-Uploader/dropbox_uploader.sh): "
		read -r INPUT_DROPBOX
		# set default remote server details
		INPUT_REMOTESSH="user@yourserver.com"
	else
		# get remote server details
		echo -ne "\n  Set the Remote Server Details\n"
		echo -ne " # Example (user@yourserver.com): "
		read -r INPUT_REMOTESSH
		# set default dropbox details
		INPUT_DROPBOX="/media/host/root/Dropbox-Uploader/dropbox_uploader.sh"
	fi
	# get the remote database backup paths
	echo -ne "\n  Set Remote Backup Path for Database Backups\n"
	echo -ne " # Example (your_db_path/): "
	read -r INPUT_REMOTEDBPATH
	# get the remote website backup paths
	echo -ne "\n  Set Remote Backup Path for Website Backups\n"
	echo -ne " # Example (your_website_path/): "
	read -r INPUT_REMOTEWEBPATH
	# select the website backup type
	echo -ne "\n  Select the Website Backup Type\n"
	echo -ne " 1 = per/file\n"
	echo -ne " 2 = zipped package\n"
	echo -ne " # Make your selection [1/2]: "
	read -r INPUT_WEBBACKUPTYPE
	# select the backup file name convention
	echo -ne "\n  Select the Backup File Name Convention\n"
	echo -ne " 0 = add no date\n"
	echo -ne " 1 = add only year\n"
	echo -ne " 2 = add year & month\n"
	echo -ne " 3 = add year, month & day\n"
	echo -ne " 4 = add year, month, day & time\n"
	echo -ne " # Make your selection [1-4]: "
	read -r INPUT_USEDATE

	# now add it all to the config file
	echo "#!/bin/bash" > "$1"
	echo "" >> "$1"
	echo "##############################################################" >> "$1"
	echo "##############                                      ##########" >> "$1"
	echo "##############               CONFIG                 ##########" >> "$1"
	echo "##############                                      ##########" >> "$1"
	echo "##############################################################" >> "$1"
	echo "####       just update these to point to your server       ###" >> "$1"
	echo "##############################################################" >> "$1"
	echo "" >> "$1"
	echo "## BACKUP TYPE (1 = REMOTE SERVER || 2 = DROPBOX)" >> "$1"
	echo "BACKUPTYPE=${INPUT_BACKUPTYPE}" >> "$1"
	echo "" >> "$1"
	echo "## REMOTE SERVER DETAILS (1)" >> "$1"
	echo "REMOTESSH=\"${INPUT_REMOTESSH}\"" >> "$1"
	echo "" >> "$1"
	echo "## DROPBOX DETAILS (2) (get it from https://github.com/andreafabrizi/Dropbox-Uploader)" >> "$1"
	echo "DROPBOX=\"${INPUT_DROPBOX}\"" >> "$1"
	echo "" >> "$1"
	echo "# PATH DETAILS" >> "$1"
	echo "REMOTEDBPATH=\"${INPUT_REMOTEDBPATH}\"" >> "$1"
	echo "REMOTEWEBPATH=\"${INPUT_REMOTEWEBPATH}\"" >> "$1"
	echo "" >> "$1"
	echo "## WEBSITE BACKUP TYPE (1 = PER/FILE || 2 = ZIPPED)" >> "$1"
	echo "WEBBACKUPTYPE=\"${INPUT_WEBBACKUPTYPE}\"" >> "$1"
	echo "" >> "$1"
	echo "## 0 = no date | 1 = year | 2 = year-month | 3 = your-month-day | 4 = your-month-day:time # For DB file name" >> "$1"
	echo "USEDATE=\"${INPUT_USEDATE}\"" >> "$1"
}

### setup databases file ###
function runSetupDBs () {
	# start building the database details
	echo "# DBSERVER	FILENAME	DATABASE	USER	PASS" > "$1"
	# start Database tutorial
	echo -ne "\n  RUNNING DATABASE SETUP\n"
	# set checker to get more
	GETTING=1
	while [ "$GETTING" -eq "1" ]
	do
		# get the Database IP/Domain
		echo -ne "\n  Set the Database IP/Domain\n"
		read -e -p " # Example (127.0.0.1 | localhost): " -i "127.0.0.1" INPUT_DBSERVER
		# check that we have a string
		if [ ! ${#INPUT_DBSERVER} -ge 2 ]; then
			echo -ne "\n YOU MUST ADD A DATABASE IP/DOMAIN!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# get the File Name
		echo -ne "\n  Set the File Name for the Database Package\n"
		echo -ne " # Example (filename): "
		read -r INPUT_FILENAME
		# check that we have a string
		if [ ! ${#INPUT_FILENAME} -ge 2 ]; then
			echo -ne "\n YOU MUST ADD A FILE NAME!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# get the Database Name
		echo -ne "\n  Set the Database Name\n"
		echo -ne " # Example (database_name): "
		read -r INPUT_DATABASE
		# check that we have a string
		if [ ! ${#INPUT_DATABASE} -ge 2 ]; then
			echo -ne "\n YOU MUST ADD A DATABASE NAME!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# get the Database User Name
		echo -ne "\n  Set the Database User Name\n"
		echo -ne " # Example (database_user): "
		read -r INPUT_USER
		# check that we have a string
		if [ ! ${#INPUT_USER} -ge 2 ]; then
			echo -ne "\n YOU MUST ADD A DATABASE USER NAME!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# get the Database User Password
		echo -ne "\n  Set the Database User Password\n"
		echo -ne " # Example (realy..): "
		read -s INPUT_PASSWORD
		# check that we have a string
		if [ ! ${#INPUT_PASSWORD} -ge 2 ]; then
			echo -ne "\n YOU MUST ADD A DATABASE USER PASSWORD!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# add to the file
		echo "${INPUT_DBSERVER}	${INPUT_FILENAME}	${INPUT_DATABASE}	${INPUT_USER}	${INPUT_PASSWORD}" >> "$1"
		# check if another should be added
		echo ""
		echo -ne "\n Would you like to add another database? [y/N]: "
		read -r answer
		if [[ $answer != "y" ]]; then
			# end the loop
			GETTING=0
		fi
	done
}

### setup folders file ###
function runSetupFolders () {
	# start building the website folder details
	echo "# local_site_path	remote_site_folder_name" > "$1"
	# start Folder tutorial
	echo -ne "\n  RUNNING FOLDER SETUP\n"
	# set checker to get more
	GETTING=1
	while [ "$GETTING" -eq "1" ]
	do
		# get local folder path path
		echo -ne "\n  Set the Local Folder Path\n"
		echo -ne " # Example (/home/username/): "
		read -r INPUT_LOCAL_PATH
		# check that we have a local path
		if [ ! -d "$INPUT_LOCAL_PATH" ]; then
			echo -ne "\n YOU MUST ADD A LOCAL PATH!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# get local folder path path
		echo -ne "\n  Set the Remote Folder Path\n"
		echo -ne " # Example (username): "
		read -r INPUT_REMOTE_PATH
		# check that we have a string
		if [ ! ${#INPUT_REMOTE_PATH} -ge 2 ]; then
			echo -ne "\n YOU MUST ADD A REMOTE PATH!\n\n" ;
			# remove the file
			rm "$1"
			# start again
			exit 1
		fi
		# add to the file
		echo "${INPUT_LOCAL_PATH}	${INPUT_REMOTE_PATH}" >> "$1"
		# check if another should be added
		echo ""
		echo -ne "\n Would you like to add another folder? [y/N]: "
		read -r answer
		if [[ $answer != "y" ]]; then
			# end the loop
			GETTING=0
		fi
	done
}

### MAIN SETUP ###
function runSetup () {
	# if setup config
	if [ "$1" -eq "1" ]; then
		runSetupConfig "$2"
	# if setup database
	elif [ "$1" -eq "2" ]; then
		runSetupDBs "$2"
	# if setup folders	
	elif [ "$1" -eq "3" ]; then
		runSetupFolders "$2"
	fi
}
