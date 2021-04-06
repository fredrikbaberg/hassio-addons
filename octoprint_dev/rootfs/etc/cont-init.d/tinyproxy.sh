#!/usr/bin/with-contenv bashio

bashio::log.info "TinyProxy cont-init.d"

if [ -f /config/tinyproxy-ingress.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /config/tinyproxy-ingress.conf
fi
if [ -f /config/tinyproxy-webui.conf ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /config/tinyproxy-webui.conf
fi
