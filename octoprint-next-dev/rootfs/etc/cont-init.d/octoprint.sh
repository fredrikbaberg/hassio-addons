#!/usr/bin/with-contenv bashio

bashio::log.info "OctoPrint cont-init.d"

# Copy OctoPrint install to persistent storage, if missing.
if [ ! -d /data/python/OctoPrint ]; then
    mkdir -p /data/python
    tar -zxf /root/OctoPrint-python.tar.gz -C /data/python/
    # rm -rf /root/OctoPrint-python.tar.gz
fi

# Copy config to persistent storage, if missing.
if [ ! -d /data/config/octoprint ]; then
    mkdir -p /data/config/octoprint
    tar -zxf /root/OctoPrint-config.tar.gz -C /data/config/
    # rm -rf /root/OctoPrint-config.tar.gz
fi

# Ensure Ingress user (homeassistant) exist.
new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
octoprint --basedir /data/config/octoprint user add homeassistant --password "$new_password" --admin # 2> /dev/null
