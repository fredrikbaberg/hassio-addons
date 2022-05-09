#!/usr/bin/with-contenv bashio

bashio::log.info "mjpg-streamer cont-init.d"

MJPG_INPUT="$(bashio::config 'mjpg_input')"
MJPG_OUTPUT="$(bashio::config 'mjpg_output')"


echo "exec mjpg_streamer $MJPG_OUTPUT $MJPG_INPUT" >> /etc/services.d/mjpg-streamer/run

# Configure autostart of service
if bashio::config.true 'mjpg_streamer'; then
    rm -f /etc/services.d/mjpg-streamer/down
    rm -f /etc/services.d/mjpg-streamer/finish
else
    touch /etc/services.d/mjpg-streamer/down
    touch /etc/services.d/mjpg-streamer/finish
fi
