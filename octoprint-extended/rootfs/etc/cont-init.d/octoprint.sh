#!/usr/bin/with-contenv bashio

bashio::log.info "OctoPrint cont-init.d"

# Copy OctoPrint install to persistent storage, if missing.
if [ ! -d /data/python/OctoPrint ]; then
    if [ -f /root/OctoPrint-python.tar.gz ]; then
        mkdir -p /data/python
        tar -zxf /root/OctoPrint-python.tar.gz -C /data/python/
    else
        bashio::log.info "OctoPrint Python archive not found"
    fi
fi

# Copy config to persistent storage, if missing.
if [ ! -f /data/config/octoprint/config.yaml ]; then
    if [ -d /root/config/octoprint ]; then
        mkdir -p /data/config/octoprint
        cp -r /root/config/octoprint /data/config/
    else
        bashio::log.info "Default OctoPrint config not found"
    fi
fi

# Ensure Ingress user (homeassistant) exist.
new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
octoprint --basedir /data/config/octoprint user add homeassistant --password "$new_password" --admin # 2> /dev/null

# Configure autostart of service
if bashio::config.is_empty 'autostart_octoprint' || bashio::config.true 'autostart_octoprint'; then
    rm -f /etc/services.d/octoprint/down
else
    touch /etc/services.d/octoprint/down
fi
