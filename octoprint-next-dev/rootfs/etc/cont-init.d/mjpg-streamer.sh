#!/usr/bin/with-contenv bashio

bashio::log.info "mjpg-streamer cont-init.d"

mjpg_arguments=$(bashio::config 'mjpg_arguments')

sed -i "s#%%mjpg_arguments%%#$(bashio::config 'mjpg_arguments')#g" /var/run/s6/services/mjpg-streamer/run
