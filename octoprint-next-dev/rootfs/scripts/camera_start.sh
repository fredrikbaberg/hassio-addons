#!/usr/bin/with-contenv bashio

echo "Attempt to start camera"

s6-svc -wU -T 5000 -u /var/run/s6/services/mjpg-streamer

# supervisorctl start mjpg-streamer
