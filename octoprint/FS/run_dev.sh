#!/bin/sh
set -e
# #!/usr/bin/with-contenv bashio


# echo "run.sh"
echo "run_dev.sh"


rescue(){
    # Simple attempt to rescue system.
    # - Install Python
    # - Create backup of OctoPrint
    # - Reset Python directory
    # - Restore backup of OctoPrint
    #
    # if bashio::config.true 'request_rescue'; then
        apk add --quiet --no-cache $PYTHON_VERSION
        backup_create
        python_replace
        backup_restore
    # fi
}

migrate_to_python3(){
    # Migrate from Python2 to Python3.
    if [[ ! -e /data/migrated ]]; then
        echo "Upgrade to Python3"
        if ! command -v octoprint &> /dev/null
        then
            python_refresh
        else
            echo "Backup, update and restore"
            apk add --quiet --no-cache --virtual .update python2
            backup_create
            python_replace
            backup_restore
            apk del --quiet --no-cache .update
        fi
        # Create file to prevent this from running again
        touch /data/migrated
    fi
}

python_refresh(){
    # Refresh Python files from archive
    tar -zxf /root/python.tar.gz -C /data/
}

python_replace(){
    # Remove old Python install, replace with new
    rm -rf /data/python
    tar -zxf /root/python.tar.gz -C /data/
}

backup_create(){
    # Backup OctoPrint, save a copy of backup in /config/octoprint_backup for user access
    {
        octoprint --basedir /config/octoprint plugins backup:backup
        mkdir -p /config/octoprint_backup
        cp $(ls /data/octoprint/data/backup/octoprint-backup* -t -1 | head -n1) /config/octoprint_backup/
    } || {
        echo "Could not create backup"
        # bashio::log.info "Could not create backup"
    }
}

backup_restore(){
    # Restore latest backup
    {
        octoprint --basedir /config/octoprint plugins backup:restore $(ls /data/octoprint/data/backup/octoprint-backup* -t -1 | head -n1)
    } || {
        echo "Could not restore backup"
        # bashio::log.info "Could not restore backup"
    }
}

add_build_packages(){
    # if bashio::config.true 'add_build_packages'; then
    {
        # bashio::log.info "Adding packages to build/install new plugins"
        echo "Adding packages to build/install new plugins"
        apk add --no-cache -q --virtual .build \
        zlib-dev \
        jpeg-dev \
        ${PYTHON_VERSION}-dev \
        build-base \
        linux-headers
    }
    # fi
}

copy_data() {
    if [ ! -d /data/python ]; then
        # bashio::log.info "Copy data to persistent location"
        echo "Copy data to persistent location"
        tar -zxf /root/python.tar.gz -C /data/
        rm -rf /root/python.tar.gz
    fi
}

create_ingress_user() {
    # bashio::log.info "Create Ingress user"
    echo "Create Ingress user"
    new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    octoprint --basedir /config/octoprint user add homeassistant --password $new_password --admin # 2> /dev/null
}

create_config() {
    mkdir -p /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        # bashio::log.info "Create config"
        echo "Create config"
        mkdir -p /config/octoprint
        cp /octoprint/config.yaml /config/octoprint/config.yaml
    fi
}

set_ingress_entry() {
    # bashio::log.info "Set Ingress entry"
    echo "Set Ingress entry"
    # ingress_entry=$(bashio::addon.ingress_entry)
    # sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

set_mjpg_args(){
    # bashio::log.info "Set mjpg-streamer arguments"
    echo "Set mjpg-streamer arguments"
    INPUT="input_file.so -f /www_mjpg -e"
    OUTPUT="output_http.so -w /www_mjpg -p 8080"
    sed -i "s+%%mjpg_input%%+${INPUT}+g" /mjpgstreamer.sh
    sed -i "s+%%mjpg_output%%+${OUTPUT}+g" /mjpgstreamer.sh
}

migrate_to_python3
# rescue
# add_build_packages
copy_data
create_config
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
set_ingress_entry
set_mjpg_args
# bashio::log.info "Launch"
echo "Launch"
supervisord -c /etc/supervisord.conf
tail -f /tmp/*-stdout*.log