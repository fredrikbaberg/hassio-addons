#!/usr/bin/with-contenv bashio

bashio::log.info "TinyProxy cont-init.d"

if [ -f "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-ingress.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-ingress.conf
fi
if [ -f "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-webui.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-webui.conf
fi
