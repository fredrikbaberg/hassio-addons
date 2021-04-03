#!/usr/bin/with-contenv bashio

bashio::log.info "Caddy cont-init.d"

if [ ! -f /config/Caddyfile ]; then
    cp /etc/services.d/caddy/Caddyfile /config/Caddyfile
fi

ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%base_path%%#${ingress_entry}#g" /config/Caddyfile
# sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/services.d/caddy/Caddyfile