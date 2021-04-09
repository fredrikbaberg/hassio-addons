#!/usr/bin/with-contenv bashio

bashio::log.info "Caddy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)

sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/caddy/Caddyfile

if bashio::config.true 'recovery'; then
    sed -i "s#@ingress http://127.0.0.1:80#@ingress http://127.0.0.1:80/recovery#g" /etc/caddy/Caddyfile
fi