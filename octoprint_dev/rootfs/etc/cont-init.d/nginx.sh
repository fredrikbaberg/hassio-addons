#!/usr/bin/with-contenv bashio

bashio::log.info "Nginx cont-init.d"

if [ -f "/config/octoprint"$(bashio::config 'config_folder_suffix')/nginx.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" "/config/octoprint"$(bashio::config 'config_folder_suffix')/nginx.conf
fi
