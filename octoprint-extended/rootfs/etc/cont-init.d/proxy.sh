#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)

sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/caddy/Caddyfile

if bashio::config.true 'recovery'; then
    sed -i "s%#recovery%rewrite / /recovery%g" /etc/caddy/Caddyfile
    # Disable recovery mode option afterwards
    sed -i "s/\"recovery\": true,/\"recovery\": false,/g" /data/options.json
else
    # Remove recovery mode rewrite if option is not set.
    sed -i "s%rewrite / /recovery%#recovery%g" /etc/caddy/Caddyfile
fi
