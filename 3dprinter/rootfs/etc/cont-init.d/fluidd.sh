#!/usr/bin/with-contenv bashio

bashio::log.info "Fluidd cont-init.d"

# Copy Klipper install to persistent storage, if missing.
if [ ! -d /data/fluidd ]; then
    if [ -f /root/Fluidd.tar.gz ]; then
        mkdir -p /data
        tar -zxf /root/Fluidd.tar.gz -C /data
        bashio::log.notice "Fluidd extracted"
    else
        bashio::log.warning "Fluidd archive not found"
    fi
fi
