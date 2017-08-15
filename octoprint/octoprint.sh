#!/bin/sh
setup() {
    sudo mkdir -p /config/octoprint
    sudo chown -R octoprint:octoprint /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        sudo cp -a $HOME/.octoprint/config.yaml /config/octoprint/config.yaml
        echo "Copy .octoprint/config.yaml"
    # else
    #     sed 's+^    serverRestartCommand.*+    serverRestartCommand: /home/octoprint/octoprint.sh+' /config/octoprint/config.yaml
    fi
    sudo chown -R octoprint:octoprint /data/
    if [ ! -d /data/CuraEngine ]; then
        sudo cp -a $HOME/CuraEngine /data/
        echo "Copied CuraEngine"
    fi
    if [ ! -d /data/OctoPrint ]; then
        sudo cp -a $HOME/OctoPrint /data/
        echo "Copied OctoPrint"
    fi
    if [ ! -d /data/libArcus ]; then
        sudo cp -a $HOME/libArcus /data/
        echo "Copied libArcus"
    fi
}

setup
/data/OctoPrint/venv/bin/octoprint daemon restart --basedir /config/octoprint >> /home/octoprint/log_octo.txt
# /data/OctoPrint/venv/bin/octoprint serve --basedir /config/octoprint
# --config /config/octoprint/config.yaml  # Should be enough with basedir.
# >> /home/octoprint/log_octo.txt
