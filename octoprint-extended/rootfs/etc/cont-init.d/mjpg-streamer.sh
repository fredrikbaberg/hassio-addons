#!/usr/bin/with-contenv bashio

bashio::log.info "mjpg-streamer cont-init.d"

MJPG_ARGUMENTS=""
for I in $(bashio::config 'mjpg_arguments'); do
    to_add=${I//$'\n'/}
    MJPG_ARGUMENTS+="$to_add "
done

echo "exec mjpg_streamer $MJPG_ARGUMENTS" >> /etc/services.d/mjpg-streamer/run

# Configure autostart of service
if bashio::config.true 'autostart_mjpg_streamer'; then
    rm -f /etc/services.d/mjpg-streamer/down
    rm -f /etc/services.d/mjpg-streamer/finish
else
    touch /etc/services.d/mjpg-streamer/down
    touch /etc/services.d/mjpg-streamer/finish
fi
