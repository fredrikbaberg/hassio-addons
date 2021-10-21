#!/usr/bin/with-contenv bashio

bashio::log.info "Moonraker cont-init.d"

# Copy Moonraker install to persistent storage, if missing.
if [ ! -d /data/python/Moonraker ]; then
    mkdir -p /data/python
    tar -zxf /root/Moonraker-python.tar.gz -C /data/python/
fi

# Copy source to persistent storage, if missing.
if [ ! -d /data/moonraker ]; then
    mkdir -p /data/moonraker
    tar -zxf /root/Moonraker-src.tar.gz -C /data/
fi

# Make sure log file exists
touch /tmp/moonraker.log
