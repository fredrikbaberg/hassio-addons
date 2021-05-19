#!/usr/bin/with-contenv bashio

s6-svc -wU -T 5000 -u /var/run/s6/services/mjpg-streamer

# supervisorctl start mjpg-streamer
