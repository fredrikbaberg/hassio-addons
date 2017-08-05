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
# /data/OctoPrint/venv/bin/octoprint daemon restart --config /config/octoprint/config.yaml --basedir /config/octoprint > /home/octoprint/octo_out.txt
# /data/OctoPrint/venv/bin/octoprint daemon stop
# /data/OctoPrint/venv/bin/octoprint daemon restart --config /config/octoprint/config.yaml --basedir /config/octoprint

# # Kill process, if running.
# stop() {
#     if [ -f /data/current_octoprint_pid ]; then
#         kill -15 $(cat /data/current_octoprint_pid)
#         sudo rm -f /data/current_octoprint_pid
#     fi
# }

# # Run octoprint and store ID
# start() {
#     sudo -u octoprint /data/OctoPrint/venv/bin/octoprint serve --config /config/octoprint/config.yaml --basedir /config/octoprint & echo $! >> /data/current_octoprint_pid
# }

# if [ "$1" = "stop" ]; then
#     echo "========== Stop octoprint =========="
#     stop
# else
#     echo "========== (re)Start octoprint =========="
#     setup
#     echo "========== Folders created =========="
#     stop
#     echo "========== Previous process killed =========="
#     sleep 2
#     start
#     echo "========== Started octoprint =========="
# fi

# /data/OctoPrint/venv/bin/octoprint daemon start --config /config/octoprint/config.yaml --basedir /config/octoprint
