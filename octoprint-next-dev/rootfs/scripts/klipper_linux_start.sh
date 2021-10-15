#!/usr/bin/with-contenv bashio

echo "Attempt to start Klipper MCU Linux"

/bin/s6-svc -wU -u /var/run/s6/services/klipper-linux
