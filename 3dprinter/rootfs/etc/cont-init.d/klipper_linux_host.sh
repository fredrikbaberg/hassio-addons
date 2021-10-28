#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper Linux Host cont-init.d"

# Configure autostart of service
if bashio::config.true 'klipper_linux_host'; then
    rm -f /etc/services.d/klipper-linux-host/down
    rm -f /etc/services.d/klipper-linux-host/finish
else
    touch /etc/services.d/klipper-linux-host/down
    touch /etc/services.d/klipper-linux-host/finish
fi
