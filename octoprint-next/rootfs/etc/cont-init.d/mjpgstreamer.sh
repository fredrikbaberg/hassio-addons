#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare mjpgstreamer"

sed -i "s#%%mjpg_input%%#$(bashio::config 'mjpg_input')#g" /etc/supervisord.conf
