#!/usr/bin/with-contenv bashio

bashio::log.info "HAProxy cont-init.d"

if [ -f /config/haproxy.cfg ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /config/haproxy.cfg
fi
