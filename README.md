# Backup System for server:
---------------------
The Bash scripts used to backup database and folders on a server

## Features

* Cross platform
* Fast and effective backups
* Ability to track changes
* Historical records
* Preserve the folder structure
* Recourse friendly

## Getting started

Clone Repository

```bash
   $ git clone ssh://git@projects.vdm.io/system-backup.git system-backup
```

Rename __config.txt__ to __config.sh__ and update the values in the file.

```bash
   $ mv config.txt config.sh
```

Rename __folders.txt__ to __folders__ and update the values in the file.

```bash
   $ mv folders.txt folders
```

Rename __databases.txt__ to __databases__ and update the values in the file.

```bash
   $ mv databases.txt databases
```

Make sure all the needed files are executable

```bash
   $ chmod +x run.sh
   $ chmod +x main.sh
   $ chmod +x incl.sh
   $ chmod +x config.sh
```

Run the script

```bash
   $ ./run.sh
```

## Tested Environments

* GNU Linux

If you have successfully tested this script on others systems or platforms please let me know!

## Running as cron job
Get the full path to the __run.sh__ file. Open https://crontab.guru to get your cron time settings. Open the crontab:
```bash
   $ crontab -e
```
With your cron time, add the following line to the crontab, using your path details:
> 5 03 * * * /path/to/run.sh >/dev/null 2>&1

> your time |  your path    | to ignore messages
   
## GIT, BASH

**Debian & Ubuntu Linux:**
```bash
    sudo apt-get install bash (Probably BASH is already installed on your system)
    sudo apt-get install git
```

# Copyright:
---------------------
* Copyright (C) [Vast Development Method](https://www.vdm.io). All rights reserved. 
* Distributed under the GNU General Public License version 2 or later
* See [License details](https://www.vdm.io/gnu-gpl)

