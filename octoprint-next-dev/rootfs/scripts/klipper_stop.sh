#!/usr/bin/with-contenv bashio

echo "Attempt to stop Klipper"

# /bin/s6-svc -wU -u /var/run/s6/services/klipper
/bin/s6-svc -wd -d /var/run/s6/services/klipper