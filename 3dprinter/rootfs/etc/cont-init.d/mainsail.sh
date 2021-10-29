#!/usr/bin/with-contenv bashio

bashio::log.info "Mainsail cont-init.d"

# Copy Klipper install to persistent storage, if missing.
if [ ! -d /data/mainsail ]; then
    if [ -f /root/Mainsail.tar.gz ]; then
        mkdir -p /data
        tar -zxf /root/Mainsail.tar.gz -C /data
        bashio::log.notice "Mainsail extracted"
    else
        bashio::log.warning "Mainsail archive not found"
    fi
fi
