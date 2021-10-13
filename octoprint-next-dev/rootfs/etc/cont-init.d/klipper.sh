#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

# Copy Klipper install to persistent storage, if missing.
if [ ! -d /data/python/Klipper ]; then
    mkdir -p /data/python
    tar -zxf /root/Klipper-python.tar.gz -C /data/python/
    # rm -rf /root/Klipper-python.tar.gz
fi

# Copy source to persistent storage, if missing.
if [ ! -d /data/klipper ]; then
    mkdir -p /data/klipper
    tar -zxf /root/Klipper-src.tar.gz -C /data/
    # rm -rf /root/Klipper-config.tar.gz
fi

# Make sure log file exists
touch /tmp/klippy.log
