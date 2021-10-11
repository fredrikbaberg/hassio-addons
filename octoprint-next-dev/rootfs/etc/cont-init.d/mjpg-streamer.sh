#!/usr/bin/with-contenv bashio

bashio::log.info "proxy cont-init.d"

sed -i "s#%%mjpg_arguments%%#$(bashio::config 'mjpg_arguments')#g" /var/run/s6/services/mjpg-streamer/run
