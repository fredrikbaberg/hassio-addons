#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper Linux Host cont-init.d"

if bashio::config.true 'klipper_linux_host'; then
    if [ ! -f /data/bin/klipper_mcu ]; then
        mkdir -p /data/bin
        cp /usr/local/bin/klipper_mcu /data/bin/klipper_mcu
    fi

    # Configure autostart of service
    rm -f /etc/services.d/klipper-linux-host/down
    rm -f /etc/services.d/klipper-linux-host/finish
else
    bashio::log.notice "Klipper linux host disabled"
fi
