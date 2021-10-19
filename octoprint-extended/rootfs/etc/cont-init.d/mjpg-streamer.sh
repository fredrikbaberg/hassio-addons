#!/usr/bin/with-contenv bashio

bashio::log.info "mjpg-streamer cont-init.d"

MJPG_ARGUMENTS=""
for I in $(bashio::config 'mjpg_arguments'); do
    to_add=${I//$'\n'/}
    MJPG_ARGUMENTS+="$to_add "
done

echo "exec mjpg_streamer $MJPG_ARGUMENTS" >> /etc/services.d/mjpg-streamer/run
