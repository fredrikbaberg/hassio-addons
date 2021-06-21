#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

mkdir -p /data/klipper/

if [ ! -f ${HOME}/printer.cfg ]; then
    ln -s /data/klipper/printer.cfg ${HOME}/printer.cfg
    touch ${HOME}/printer.cfg
fi
