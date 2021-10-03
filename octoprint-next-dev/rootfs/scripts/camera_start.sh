#!/usr/bin/with-contenv bashio

echo "Attempt to start camera"

/bin/s6-svc -wU -u /var/run/s6/services/mjpg-streamer
# /bin/s6-svc -wd -d /var/run/s6/services/mjpg-streamer