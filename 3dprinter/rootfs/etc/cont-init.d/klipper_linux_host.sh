#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper Linux Host cont-init.d"

# Configure autostart of service
if bashio::config.true 'autostart_klipper_linux_host'; then
    rm -f /etc/services.d/klipper-linux/down
    rm -f /etc/services.d/klipper-linux/finish
else
    touch /etc/services.d/klipper-linux/down
    touch /etc/services.d/klipper-linux/finish
fi
