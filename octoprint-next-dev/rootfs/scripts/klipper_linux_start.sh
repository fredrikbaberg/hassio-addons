#!/usr/bin/with-contenv bashio

echo "Attempt to start Klipper MCU Linux"

s6-svc -wU -T 5000 -u /var/run/s6/services/klipper-linux
