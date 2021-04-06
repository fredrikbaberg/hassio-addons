#!/usr/bin/with-contenv bashio

bashio::log.info "TinyProxy cont-init.d"
OCTOPRINT_BASEDIR="/config/octoprint"$(bashio::config 'config_folder_suffix')

if [ -f /"$OCTOPRINT_BASEDIR"/tinyproxy-ingress.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /"$OCTOPRINT_BASEDIR"/tinyproxy-ingress.conf
fi
if [ -f /"$OCTOPRINT_BASEDIR"/tinyproxy-webui.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /"$OCTOPRINT_BASEDIR"/tinyproxy-webui.conf
fi
