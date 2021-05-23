#!/usr/bin/with-contenv bashio

bashio::log.info "Stop camera"

s6-svc -t /var/run/s6/services/mjpg-streamer

# supervisorctl stop mjpg-streamer
