#!/usr/bin/with-contenv bashio

echo "Attempt to stop Klipper MCU Linux"

/bin/s6-svc -wd -d /var/run/s6/services/klipper-linux
