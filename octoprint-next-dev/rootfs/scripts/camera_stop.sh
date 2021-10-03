#!/usr/bin/with-contenv bashio

echo "Attempt to stop camera"

s6-svc -t /var/run/s6/services/mjpg-streamer

# supervisorctl stop mjpg-streamer
