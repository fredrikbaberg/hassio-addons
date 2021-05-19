#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare Caddy"

sed -i "s#%%base_path%%#$(bashio::addon.ingress_entry)#g" /etc/caddy/Caddyfile
if bashio::config.true 'recovery'; then
    sed -i "s%#insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
fi
