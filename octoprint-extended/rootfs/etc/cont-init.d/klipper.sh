#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

# Copy Klipper install to persistent storage, if missing.
if [ ! -d /data/python/Klipper ]; then
    if [ -f /root/Klipper-python.tar.gz ]; then
        mkdir -p /data/python
        tar -zxf /root/Klipper-python.tar.gz -C /data/python/
    fi
fi

# Copy source to persistent storage, if missing.
if [ ! -d /data/klipper ]; then
    if [ -f /root/Klipper-src.tar.gz ]; then
        mkdir -p /data/klipper
        tar -zxf /root/Klipper-src.tar.gz -C /data/
    fi
fi

# Configure autostart of service
if bashio::config.true 'autostart_klipper'; then
    rm -f /etc/services.d/klipper/down
    rm -f /etc/services.d/klipper/finish
else
    touch /etc/services.d/klipper/down
    touch /etc/services.d/klipper/finish
fi

# Make sure log file exists
touch /tmp/klippy.log
