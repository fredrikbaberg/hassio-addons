#!/bin/sh
set -e

copy_data() {
    if [ ! -d /data/python ]; then
        echo "Copy data"
        cp -R /root/python /data/
    fi
}

create_homeassistant_user() {
    echo "Create ingress user"
    octoprint --basedir /data --config /config/octoprint/config.yaml user add homeassistant --password octoprint --admin 2> /dev/null
}

create_logging() {
    # if [ ! -f /config/octoprint/logging.yaml ]; then
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
    # fi
}

create_config() {
    if [ ! -f /config/octoprint/config.yaml ]; then
        echo "Create config"
        mkdir -p /config/octoprint/
        cd /config/octoprint
        touch config.yaml
        echo "accessControl:" >> config.yaml
        echo "  autologinAs: homeassistant" >> config.yaml
        echo "  autologinLocal: true" >> config.yaml
        echo "  localNetworks:" >> config.yaml
        echo "    - 172.30.32.2" >> config.yaml
        echo "    - 192.168.1.175" >> config.yaml
        echo "server:" >> config.yaml
        echo "  firstRun: false" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl reload" >> config.yaml
        echo "devel:" >> config.yaml
        echo "  virtualPrinter:" >> config.yaml
        echo "    enabled: true" >> config.yaml
    fi
}

copy_data
create_config
create_logging
create_homeassistant_user # Ensure homeassistant user exist.
bash debug.sh
# echo "Launch"
# /usr/bin/supervisord -c /etc/supervisord.conf
# tail -f /tmp/octoprint-stdout*
