#!/usr/bin/with-contenv bashio

bashio::log.info "Moonraker cont-init.d"

# Copy Moonraker install to persistent storage, if missing.
if [ ! -d /data/python/Moonraker ]; then
    if [ -f /root/Moonraker-python.tar.gz ]; then
        mkdir -p /data/python
        tar -zxf /root/Moonraker-python.tar.gz -C /data/python/
        echo "Moonraker Python extracted"
    else
        echo "Moonraker Python archive not found"
    fi
fi

# Copy source to persistent storage, if missing.
if [ ! -d /data/moonraker ]; then
    if [ -f /root/Moonraker-src.tar.gz ]; then
        mkdir -p /data/moonraker
        tar -zxf /root/Moonraker-src.tar.gz -C /data/
        bashio::log.notice "Moonraker src extracted"
    else
        bashio::log.warning "Moonraker src not found"
    fi
fi

# Copy config to persistent storage, if missing.
if [ ! -f /data/config/klipper/moonraker.conf ]; then
    if [ -f /root/config/klipper/moonraker.conf ]; then
        mkdir -p /data/config/klipper
        cp /root/config/klipper/moonraker.conf /data/config/klipper/moonraker.conf
        bashio::log.notice "Default Moonraker config copied"
    else
        bashio::log.warning "Default Moonraker config not found"
    fi
fi

# Make sure log file exists
touch /tmp/moonraker.log

# Configure autostart of service
if bashio::config.true 'moonraker'; then
    rm -f /etc/services.d/moonraker/down
    rm -f /etc/services.d/moonraker/finish
else
    touch /etc/services.d/moonraker/down
    touch /etc/services.d/moonraker/finish
fi
