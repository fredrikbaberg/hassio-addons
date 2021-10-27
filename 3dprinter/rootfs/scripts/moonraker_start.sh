#!/usr/bin/with-contenv bashio

echo "Attempt to start Moonraker"

/bin/s6-svc -wu -u /var/run/s6/services/moonraker
