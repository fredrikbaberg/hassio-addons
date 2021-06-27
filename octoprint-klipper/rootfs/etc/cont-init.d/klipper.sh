#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

mkdir -p /data/klipper/

if bashio::config.true 'update_klipper'; then
    echo "Update Klipper"
    cd /root/klipper && git pull
fi

if [ ! -f ${HOME}/printer.cfg ]; then
    ln -s /data/klipper/printer.cfg ${HOME}/printer.cfg
    touch ${HOME}/printer.cfg
fi
