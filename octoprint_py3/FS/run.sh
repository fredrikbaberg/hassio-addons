#!/usr/bin/with-contenv bashio
# #!/bin/sh
# set -e


echo "run.sh"

copy_data() {
    if [ ! -d /data/python ]; then
        bashio::log.info "Copy data to persistent location"
        tar -zxf /root/python.tar.gz -C /data/
        rm -rf /root/python.tar.gz
    fi
}

create_ingress_user() {
    bashio::log.info "Create Ingress user"
    new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    octoprint --basedir /config/octoprint user add homeassistant --password $new_password --admin # 2> /dev/null
}

create_config() {
    mkdir -p /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        bashio::log.info "Create config"
        mkdir -p /config/octoprint
        cp /octoprint/config.yaml /config/octoprint/config.yaml
    fi
}

set_ingress_entry() {
    bashio::log.info "Set Ingress entry"
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    # sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

set_mjpg_args(){
    bashio::log.info "Set mjpg-streamer arguments"
    INPUT=$(bashio::config 'mjpg_input')
    OUTPUT=$(bashio::config 'mjpg_output')
    sed -i "s+%%mjpg_input%%+${INPUT}+g" /mjpgstreamer.sh
    sed -i "s+%%mjpg_output%%+${OUTPUT}+g" /mjpgstreamer.sh
}

copy_data
create_config
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
set_ingress_entry
set_mjpg_args
bashio::log.info "Launch"
supervisord -c /etc/supervisord.conf
tail -f /tmp/*-stdout*.log
