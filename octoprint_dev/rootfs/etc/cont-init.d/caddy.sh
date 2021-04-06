#!/usr/bin/with-contenv bashio

bashio::log.info "Caddy cont-init.d"

if [ -f /config/Caddyfile ]; then
    ingress_entry=$(bashio::addon.ingress_entry)
    sed -i "s#%%base_path%%#${ingress_entry}#g" /config/Caddyfile
fi
