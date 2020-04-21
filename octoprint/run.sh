#!/bin/sh
set -e

copy_data() {
    if [ ! -d /data/python ]; then
        echo "Copy data"
        cp -R /root/python /data/
    fi
}

create_homeassistant_user() {
    octoprint user add homeassistant --password homeassistant2020
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
        echo "  cura:" >> config.yaml
        echo "    cura_engine: /sbin/CuraEngine" >> config.yaml
        echo "    debug_logging: false" >> config.yaml
        echo "  pluginmanager:" >> config.yaml
        echo "    pip_force_user: true" >> config.yaml
        echo "webcam:" >> config.yaml
        echo "  stream: /webcam/?action=stream" >> config.yaml
        echo "  snapshot: http://127.0.0.1:8080/?action=snapshot" >> config.yaml
        echo "  ffmpeg: /usr/bin/ffmpeg" >> config.yaml
        echo "serial:" >> config.yaml
        echo "  additionalPorts:" >> config.yaml
        echo "  - /dev/tty*" >> config.yaml
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
        echo "accessControl:" >> config.yaml
        echo "  enabled: true" >> config.yaml
        echo "  autologinAs: homeassistant" >> config.yaml
        echo "  localNetworks:" >> config.yaml
        echo "  - 172.30.32.2" >> config.yaml
    fi
}

copy_data
create_config
create_homeassistant_user
echo "Launch"
/usr/bin/supervisord -c /etc/supervisord.conf
tail -f /tmp/octoprint-stdout*
