#!/usr/bin/with-contenv bashio

bashio::log.info "run.sh"

setup(){
    create_config(){
        mkdir -p /config/octoprint/
        if [ ! -f /config/octoprint/config.yaml ]; then
            bashio::log.info "Create config"
            cp /octoprint/config.yaml /config/octoprint/config.yaml
        fi
    }
    copy_data(){
        if ! command -v octoprint &> /dev/null; then
            bashio::log.info "Copy data to persistent location"
            python_refresh
            touch /data/updated
        fi
    }
    add_build_packages(){
        if bashio::config.true 'add_build_packages'; then
            bashio::log.info "Adding packages to build/install new plugins"
            apk add --no-cache -q --virtual .build \
            zlib-dev \
            jpeg-dev \
            ${PYTHON_VERSION}-dev \
            build-base \
            linux-headers
        fi
    }
    rescue(){
        if bashio::config.true 'request_rescue'; then
            rm /data/updated
        fi
    }
    migrate_py3(){
        if [[ $PYTHON_VERSION == "python3" ]]; then
            if [[ ! -e /data/migrated ]]; then
                bashio::log.info "Will migrate from Python2 to Python3"
                rm /data/updated
                touch /data/migrated
            fi
        fi
    }
    update_python(){
        if [[ ! -e /data/updated ]]; then
            bashio::log.info "Backup, replace, restore"
            apk add --quiet --no-cache --virtual .update python2 python3
            backup_create
            python_replace
            backup_restore
            touch /data/updated
            bashio::log.info "Backup, replace, restore - done"
        fi
    }
    create_config
    copy_data
    add_build_packages
    rescue
    migrate_py3
    update_python
}

startup(){
    set_ingress_entry() {
        bashio::log.info "Set Ingress entry"
        ingress_entry=$(bashio::addon.ingress_entry)
        sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
        # sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
    }
    create_ingress_user() {
        bashio::log.info "Create Ingress user if it does not exist"
        new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
        octoprint --basedir /config/octoprint user add homeassistant --password $new_password --admin # 2> /dev/null
    }
    set_mjpg_args(){
        bashio::log.info "Set mjpg-streamer arguments"
        INPUT=$(bashio::config 'mjpg_input')
        OUTPUT=$(bashio::config 'mjpg_output')
        sed -i "s+%%mjpg_input%%+${INPUT}+g" /mjpgstreamer.sh
        sed -i "s+%%mjpg_output%%+${OUTPUT}+g" /mjpgstreamer.sh
    }
    set_ingress_entry
    create_ingress_user
    set_mjpg_args
}

# Helpers start

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
        bashio::log.info "Could not create backup"
    }
}

backup_restore(){
    # Restore latest backup
    {
        octoprint --basedir /config/octoprint plugins backup:restore $(ls /data/octoprint/data/backup/octoprint-backup* -t -1 | head -n1)
    } || {
        bashio::log.info "Could not restore backup"
    }
}

# Helpers end

# Run
setup
startup
bashio::log.info "Launch"
supervisord -c /etc/supervisord.conf
tail -f /tmp/*-stdout*.log