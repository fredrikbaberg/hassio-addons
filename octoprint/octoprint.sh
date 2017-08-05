#!/bin/sh
setup() {
    sudo mkdir -p /config/octoprint
    sudo chown -R octoprint:octoprint /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        sudo cp -a $HOME/.octoprint/config.yaml /config/octoprint/config.yaml
    fi
    sudo chown -R octoprint:octoprint /data/
    if [ ! -d /data/Cura ]; then
        # sudo cp -a $HOME/Cura /data/
        sudo mv $HOME/Cura /data/
    fi
    if [ ! -d /data/OctoPrint ]; then
        # sudo cp -a $HOME/OctoPrint /data/
        sudo mv $HOME/OctoPrint /data/
    fi
}

setup
/data/OctoPrint/venv/bin/octoprint daemon restart --config /config/octoprint/config.yaml --basedir /config/octoprint >> /home/octoprint/log_octo.txt
