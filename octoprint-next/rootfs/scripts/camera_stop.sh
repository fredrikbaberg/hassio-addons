#!/usr/bin/with-contenv bashio

s6-svc -wD -d /var/run/s6/services/mjpg-streamer

# supervisorctl stop mjpg-streamer
