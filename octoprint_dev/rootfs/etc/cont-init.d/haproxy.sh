#!/usr/bin/with-contenv bashio

bashio::log.info "HAProxy cont-init.d"
OCTOPRINT_BASEDIR="/config/octoprint"$(bashio::config 'config_folder_suffix')

if [ -f /"$OCTOPRINT_BASEDIR"/haproxy.cfg ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /"$OCTOPRINT_BASEDIR"/haproxy.cfg
fi
