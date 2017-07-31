#!/bin/sh
# octoprint start
sudo mkdir -p /config/octoprint
sudo chown -R octoprint:octoprint /config/octoprint
if [ ! -f /config/octoprint/config.yaml ]; then
    cp /home/octoprint/.octoprint/config.yaml /config/octoprint/config.yaml
fi
sudo -u octoprint /home/octoprint/OctoPrint/venv/bin/octoprint serve --config /config/octoprint/config.yaml --basedir /config/octoprint