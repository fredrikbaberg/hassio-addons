#!/usr/bin/with-contenv bashio
# #!/bin/sh
# set -e


echo "run.sh"
# echo "run_dev.sh"


rescue(){
    # Simple attempt to rescue system.
    # - Try to export list of pip packages
    # - Reset Python directory
    # - Try to reinstall pip packages
    #
    if bashio::config.true 'request_rescue'; then
        {
            pip freeze --local > /tmp/pipfreeze.txt
        } || {
            bashio::log.info "Could not save data from pip"
            # echo "Could not export list from pip"
        }
        rm -rf /data/python
        tar -zxf /root/python.tar.gz -C /data/
        {
            pip install --no-cache-dir -r /tmp/pipfreeze.txt
        } || {
            bashio::log.info "Could not restore data from pip"
            # echo "Could not restore to pip"
        }
    fi
}

add_build_packages(){
    if bashio::config.true 'add_build_packages'; then
    {
        bashio::log.info "Adding packages to build/install new plugins"
        # echo "Adding packages to build/install new plugins"
        apk add --no-cache --virtual .build \
        zlib-dev \
        jpeg-dev \
        ${PYTHON_VERSION}-dev \
        build-base \
        linux-headers
    }
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
        cp /octoprint/config.yaml /config/octoprint/config.yaml
        # cd /octoprint && cp -R * /config/octoprint/
    fi
}

set_ingress_entry() {
    bashio::log.info "Set Ingress entry"
    # echo "Set Ingress entry"
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    # sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

set_mjpg_args(){
    bashio::log.info "Set mjpg-streamer arguments"
    # echo "Set mjpg-streamer arguments"
    INPUT=$(bashio::config 'mjpg_input')
    OUTPUT=$(bashio::config 'mjpg_output')
    sed -i "s+%%mjpg_input%%+${INPUT}+g" /mjpgstreamer.sh
    sed -i "s+%%mjpg_output%%+${OUTPUT}+g" /mjpgstreamer.sh
}

rescue
add_build_packages
copy_data
create_config
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
set_ingress_entry
set_mjpg_args
bashio::log.info "Launch"
# echo "Launch"
supervisord -c /etc/supervisord.conf
tail -f /tmp/*-stdout*.log
