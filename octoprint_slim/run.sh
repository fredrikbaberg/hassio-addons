#!/bin/sh
set -e

copy_data() {
    if [ ! -d /data/python ]; then
        echo "Copy data"
        cp -R /root/python /data/
    fi
}

create_config() {
    if [ ! -f /config/octoprint/config.yaml ]; then
        echo "Create config"
        mkdir -p /config/octoprint/
        cd /config/octoprint
        touch config.yaml
        echo "server:" >> config.yaml
        echo "  commands:" >> config.yaml
        echo "    serverRestartCommand: supervisorctl reload" >> config.yaml
        echo "devel:" >> config.yaml
        echo "  virtualPrinter:" >> config.yaml
        echo "    enabled: true" >> config.yaml
        echo "folder:" >> config.yaml
        echo "  timelapse: /config/octoprint/timelapse" >> config.yaml
        echo "  uploads: /config/octoprint/uploads" >> config.yaml
        echo "  watched: /config/octoprint/watched" >> config.yaml
        echo "plugins:" >> config.yaml
        echo "  pluginmanager:" >> config.yaml
        echo "    pip_force_user: true" >> config.yaml
        echo "serial:" >> config.yaml
        echo "  additionalPorts:" >> config.yaml
        echo "  - /dev/tty*" >> config.yaml
    fi
}

copy_data
create_config
echo "Launch"
/usr/bin/supervisord -c /etc/supervisord.conf
tail -f /tmp/octoprint-stdout*
