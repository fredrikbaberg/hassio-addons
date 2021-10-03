#!/usr/bin/with-contenv bashio

echo "Attempt to stop Klipper"

s6-svc -t /var/run/s6/services/klipper
