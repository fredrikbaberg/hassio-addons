#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

# Copy Klipper install to persistent storage, if missing.
if [ ! -d /data/python/Klipper ]; then
    mkdir -p /data/python
    tar -zxf /root/Klipper-python.tar.gz -C /data/python/
fi

# Copy source to persistent storage, if missing.
if [ ! -d /data/klipper ]; then
    mkdir -p /data/klipper
    tar -zxf /root/Klipper-src.tar.gz -C /data/
fi

# Make sure log file exists
touch /tmp/klippy.log
