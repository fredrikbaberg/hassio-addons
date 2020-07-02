#!/usr/bin/with-contenv bashio
# #!/bin/sh
# set -e


echo "run.sh"
# echo "run_dev.sh"

reset_data_if_requested(){
    if bashio::config.true 'request_reset_data'; then
        rm -rf /data/*
        bashio::log.info "Data has been reset"
    fi
}

copy_data() {
    if [ ! -d /data/python ]; then
        bashio::log.info "Copy data to persistent location"
        # echo "Copy data to persistent location"
        # cp -R /root/python /data/
        tar -zxf /root/python.tar.gz -C /data/
        rm -rf /root/python.tar.gz
    fi
}

create_ingress_user() {
    bashio::log.info "Create ingress user"
    # echo "Create ingress user"
    new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    octoprint --basedir /config/octoprint user add homeassistant --password $new_password --admin # 2> /dev/null
}

create_config() {
    mkdir -p /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        bashio::log.info "Create config"
        # echo "Create config"
        mkdir -p /config/octoprint
        cp /config_octoprint.yaml /config/octoprint/config.yaml
    fi
}

set_ingress_entry() {
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    # sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

reset_data_if_requested
copy_data
create_config
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
set_ingress_entry
bashio::log.info "Launch"
# echo "Launch"
supervisord -c /etc/supervisord.conf
tail -f /tmp/*
