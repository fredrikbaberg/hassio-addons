#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

# Copy Klipper install to persistent storage, if missing.
if [ ! -d /data/python/Klipper ]; then
    mkdir -p /data/python
    tar -zxf /root/Klipper-python.tar.gz -C /data/python/
    # rm -rf /root/Klipper-python.tar.gz
fi

# Copy config to persistent storage, if missing.
if [ ! -d /data/config/klipper ]; then
    mkdir -p /data/config/klipper
    tar -zxf /root/Klipper-config.tar.gz -C /data/config/
    # rm -rf /root/Klipper-config.tar.gz
fi

# Copy source persistent storage, if missing.
if [ ! -d /data/klipper ]; then
    mkdir -p /data/klipper
    tar -zxf /root/Klipper-src.tar.gz -C /data/
    # rm -rf /root/Klipper-config.tar.gz
fi

touch /tmp/klippy.log
