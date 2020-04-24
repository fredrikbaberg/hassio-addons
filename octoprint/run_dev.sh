#!/bin/sh
set -e
# #!/usr/bin/with-contenv bashio

# Mostly the same as run.sh, but without bashio calls.

copy_data() {
    if [ ! -d /data/python ]; then
        # bashio::log.info "Copy data"
        echo "Move data"
        mv /root/python /data/
    fi
}

create_ingress_user() {
    # bashio::log.info "Create ingress user"
    echo "Create ingress user"
    octoprint --basedir /data --config /config/octoprint/config.yaml user add homeassistant --password octoprint --admin 2> /dev/null
}

create_config() {
    if [ ! -f /config/octoprint/config.yaml ]; then
        # bashio::log.info "Create config"
        echo "Create config"
        mkdir -p /config/octoprint/
        cd /config/octoprint
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
        if [ "${INSTALL_CURA_LEGACY}" != "0" ]; then
            echo "  cura:" >> config.yaml
            echo "    cura_engine: /sbin/CuraEngine" >> config.yaml
            echo "    debug_logging: false" >> config.yaml
        fi
        echo "  pluginmanager:" >> config.yaml
        echo "    pip_force_user: true" >> config.yaml
        echo "serial:" >> config.yaml
        echo "  additionalPorts:" >> config.yaml
        echo "  - /dev/tty*" >> config.yaml
        echo "server:" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl reload" >> config.yaml
        if [ "${INSTALL_CAMERA_SUPPORT}" != "0" ]; then
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
    fi
}

create_logging_file() {
    # Use this to clean up some of the logging.
    cd /data
    touch logging.yaml
    echo "" > logging.yaml # Replace content.
    echo "loggers:" >> logging.yaml
    for level_warn in "octoprint" "octoprint.util.pip" "octoprint.plugins.pluginmanager" "octoprint.plugins.softwareupdate" "octoprint.plugins.discovery" "octoprint.plugins.octoprint.plugins.discovery" "octoprint.server.util.flask"
    do
        echo "  $level_warn:" >> logging.yaml
        echo "    level: WARN" >> logging.yaml
    done
    for level_info in "octoprint.server.util.sockjs"
    do
        echo "  $level_info:" >> logging.yaml
        echo "    level: INFO" >> logging.yaml
    done
}

set_ingress_entry() {
    # ingress_entry=$(bashio::addon.ingress_entry)
    # sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

copy_data
create_config
# create_logging_file # Don't modify logging.
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
set_ingress_entry
# bashio::log.info "Launch"
echo "Launch"
/usr/bin/supervisord -c /etc/supervisord.conf
tail -f /tmp/octoprint-stdout*
