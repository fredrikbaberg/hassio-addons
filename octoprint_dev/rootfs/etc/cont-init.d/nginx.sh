#!/usr/bin/with-contenv bashio

bashio::log.info "Nginx cont-init.d"
ingress_entry=$(bashio::addon.ingress_entry)

if [ -f "/config/octoprint"$(bashio::config 'config_folder_suffix')/nginx.conf ]; then
    sed -i "s#%%base_path%%#${ingress_entry}#g" "/config/octoprint"$(bashio::config 'config_folder_suffix')/nginx.conf
fi
