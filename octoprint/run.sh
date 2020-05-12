#!/usr/bin/with-contenv bashio
# #!/bin/sh
# set -e

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
        cp -R /root/python /data/
    fi
}

create_ingress_user() {
    bashio::log.info "Create ingress user"
    # echo "Create ingress user"
    new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    octoprint --basedir /data --config /config/octoprint/config.yaml user add homeassistant --password $new_password --admin # 2> /dev/null
}

create_config() {
    if [ ! -f /config/octoprint/config.yaml ]; then
        bashio::log.info "Create config"
        # echo "Create config"
        mkdir -p /config/octoprint/
        cd /config/octoprint/
        touch config.yaml
        echo "accessControl:" >> config.yaml
        echo "  autologinAs: homeassistant" >> config.yaml
        echo "  autologinLocal: true" >> config.yaml
        echo "  localNetworks:" >> config.yaml
        echo "    - 172.30.32.2" >> config.yaml
        echo "devel:" >> config.yaml
        echo "  virtualPrinter:" >> config.yaml
        echo "    enabled: true" >> config.yaml
        echo "plugins:" >> config.yaml
        echo "  cura:" >> config.yaml
        echo "    cura_engine: /sbin/CuraEngine" >> config.yaml
        echo "    debug_logging: false" >> config.yaml
        echo "  pluginmanager:" >> config.yaml
        echo "    pip_force_user: false" >> config.yaml
        echo "serial:" >> config.yaml
        echo "  additionalPorts:" >> config.yaml
        echo "  - /dev/tty*" >> config.yaml
        echo "server:" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl reload" >> config.yaml
        # echo "    systemRestartCommand: bashio::addon.restart" >> config.yaml
        # echo "    systemShutdownCommand: bashio::addon.stop" >> config.yaml
        echo "system:" >> config.yaml
        echo "  actions:" >> config.yaml
        echo "  - action: streamon" >> config.yaml
        echo "    command: supervisorctl start mjpeg-streamer" >> config.yaml
        echo "    confirm: false" >> config.yaml
        echo "    name: Start webcam" >> config.yaml
        echo "  - action: streamoff" >> config.yaml
        echo "    command: supervisorctl stop mjpeg-streamer" >> config.yaml
        echo "    confirm: false" >> config.yaml
        echo "    name: Stop webcam" >> config.yaml
        echo "webcam:" >> config.yaml
        echo "  stream: /webcam/?action=stream" >> config.yaml
        echo "  snapshot: http://127.0.0.1:8080/?action=snapshot" >> config.yaml
        echo "  ffmpeg: /usr/bin/ffmpeg" >> config.yaml
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
/usr/bin/supervisord -c /etc/supervisord.conf
tail -f /tmp/octoprint-stdout*
