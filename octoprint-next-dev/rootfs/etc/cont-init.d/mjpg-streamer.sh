#!/usr/bin/with-contenv bashio

bashio::log.info "mjpg-streamer cont-init.d"

mjpg_arguments=$(bashio::config 'mjpg_arguments')
sed -i "s#%%mjpg_arguments%%#$mjpg_arguments#g" /etc/services.d/mjpg-streamer/run
