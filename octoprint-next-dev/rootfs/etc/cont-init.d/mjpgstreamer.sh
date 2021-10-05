#!/usr/bin/with-contenv bashio

bashio::log.info "mjpgstreamer cont-init.d"

# This file should update input arguments for script that launches mjpg-streamer.

# sed -i "s#%%mjpg_input%%#$(bashio::config 'mjpg_input')#g" /etc/supervisord.conf
