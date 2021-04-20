#!/usr/bin/with-contenv bashio

bashio::log.info "Caddy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/caddy/Caddyfile

webcam_url=$(bashio::config 'webcam_url')
sed -i "s#%%webcam_url%%#${webcam_url}#g" /etc/caddy/Caddyfile

if bashio::config.true 'recovery'; then
    sed -i "s%# insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
fi