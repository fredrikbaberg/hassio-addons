#!/usr/bin/with-contenv bashio

echo "Attempt to stop Moonraker"

/bin/s6-svc -wd -d /var/run/s6/services/moonraker
