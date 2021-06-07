#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare Klipper"

if [ ! -d /data/klippy-env ]; then
    tar -zxf /root/klippy-env.tar.gz -C /data/
    rm -rf /root/klippy-env.tar.gz
fi

if [ ! -d /data/klipper ]; then
    tar -zxf /root/klipper.tar.gz -C /data/
    rm -rf /root/klipper.tar.gz
fi
