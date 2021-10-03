#!/usr/bin/with-contenv bashio

echo "Attempt to stop Klipper MCU Linux"

s6-svc -t /var/run/s6/services/klipper-linux
