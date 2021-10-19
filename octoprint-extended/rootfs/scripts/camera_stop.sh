#!/usr/bin/with-contenv bashio

echo "Attempt to stop camera"

/bin/s6-svc -wd -d /var/run/s6/services/mjpg-streamer
