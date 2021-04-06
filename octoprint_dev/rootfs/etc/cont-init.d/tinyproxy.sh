#!/usr/bin/with-contenv bashio

bashio::log.info "TinyProxy cont-init.d"
ingress_entry=$(bashio::addon.ingress_entry)

if [ -f "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-ingress.conf ]; then
    sed -i "s#%%base_path%%#${ingress_entry}#g" "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-ingress.conf
fi
if [ -f "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-webui.conf ]; then
    sed -i "s#%%base_path%%#${ingress_entry}#g" "/config/octoprint"$(bashio::config 'config_folder_suffix')/tinyproxy-webui.conf
fi
