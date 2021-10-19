#!/usr/bin/with-contenv bashio

echo "Attempt to start Klipper"

/bin/s6-svc -wu -u /var/run/s6/services/klipper
