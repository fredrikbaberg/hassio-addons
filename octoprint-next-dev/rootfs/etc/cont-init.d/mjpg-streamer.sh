#!/usr/bin/with-contenv bashio

bashio::log.info "mjpg-streamer cont-init.d"

mjpg_arguments=$(bashio::addon.ingress_entry)
sed -i "s#%%mjpg_arguments%%#$mjpg_arguments#g" /var/run/s6/services/mjpg-streamer/run
