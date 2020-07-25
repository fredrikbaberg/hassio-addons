#!/bin/sh
set -e

echo "migrate.sh"

migrate(){
    echo "Backup OctoPrint, migrate/reset Python install"
    if ! command -v octoprint &> /dev/null
    then
        echo "OctoPrint not properly installed, overwrite setup files"
        tar -zxf /root/python.tar.gz -C /data/
    else
        echo "Backup replace and restore"
        # Make sure previous Python version is installed
        apk add --quiet --no-cache python2 python3
        # Create backup and place a copy in /config/octoprint_migrate/ in case something breaks
        mkdir -p /config/octoprint_migrate
        octoprint --basedir /config/octoprint plugins backup:backup
        cp $(ls /data/octoprint/data/backup/octoprint-backup* -t -1 | head -n1) /config/octoprint_migrate/
        # Remove old Python files, replace with new
        rm -rf /data/python
        tar -zxf /root/python.tar.gz -C /data/
        # Restore backup
        echo "Restore $(ls /data/octoprint/data/backup/octoprint-backup* -t -1 | head -n1)"
        octoprint --basedir /config/octoprint plugins backup:restore $(ls /data/octoprint/data/backup/octoprint-backup* -t -1 | head -n1)
    fi
}

migrate