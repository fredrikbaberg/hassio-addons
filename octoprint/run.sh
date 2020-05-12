#!/usr/bin/with-contenv bashio
# #!/bin/sh
# set -e

copy_data() {
    if [ ! -d /data/python ]; then
        bashio::log.info "Move data"
        # echo "Move data"
        mv /root/python /data/
    fi
}

create_ingress_user() {
    bashio::log.info "Create ingress user"
    # echo "Create ingress user"
    new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    octoprint --basedir /data --config /config/$OCTOPRINT_CONFIGDIR/config.yaml user add homeassistant --password $new_password --admin 2> /dev/null
}

create_config() {
    if [ ! -f /config/$OCTOPRINT_CONFIGDIR/config.yaml ]; then
        bashio::log.info "Create config"
        # echo "Create config"
        mkdir -p /config/$OCTOPRINT_CONFIGDIR/
        cd /config/$OCTOPRINT_CONFIGDIR
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
        echo "    pip_force_user: true" >> config.yaml
        echo "serial:" >> config.yaml
        echo "  additionalPorts:" >> config.yaml
        echo "  - /dev/tty*" >> config.yaml
        echo "server:" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl reload" >> config.yaml
        # echo "system:" >> config.yaml
        # echo "  actions:" >> config.yaml
        # echo "  - action: streamon" >> config.yaml
        # echo "    command: supervisorctl start mjpeg-streamer" >> config.yaml
        # echo "    confirm: false" >> config.yaml
        # echo "    name: Start webcam" >> config.yaml
        # echo "  - action: streamoff" >> config.yaml
        # echo "    command: supervisorctl stop mjpeg-streamer" >> config.yaml
        # echo "    confirm: false" >> config.yaml
        # echo "    name: Stop webcam" >> config.yaml
        # echo "webcam:" >> config.yaml
        # echo "  stream: /webcam/?action=stream" >> config.yaml
        # echo "  snapshot: http://127.0.0.1:8080/?action=snapshot" >> config.yaml
        # echo "  ffmpeg: /usr/bin/ffmpeg" >> config.yaml
    fi
}

set_ingress_entry() {
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    # sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

reset_password_if_requested(){
    if bashio::config.true 'reset_password'; then
        bashio::log.info "Password of user homeassistant was set to 'octoprint'"
        octoprint --basedir /data --config /config/$OCTOPRINT_CONFIGDIR/config.yaml user password homeassistant --password octoprint
    fi
}

reset_data_if_requested(){
    if bashio::config.exists 'request_reset_data'; then
        bashio::log.info "Entry to reset exists"
        if bashio::config.true 'request_reset_data'; then
            bashio::log.info "Data has been reset"
            rm -rf /data/python
        fi
    fi
}

reset_data_if_requested # If ´request_reset_data´ is set, will reset OctoPrint data folder (leave config untouched).
copy_data
create_config
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
reset_password_if_requested
set_ingress_entry
bashio::log.info "Launch"
# echo "Launch"
/usr/bin/supervisord -c /etc/supervisord.conf
tail -f /tmp/octoprint-stdout*
